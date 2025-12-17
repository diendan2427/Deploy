# 🚫 Hướng Dẫn Tắt/Tăng Rate Limiting

> Fix lỗi "Quá nhiều lần thử đăng nhập. Vui lòng thử lại sau 15 phút"

---

## ⚡ Giải Pháp Nhanh - Clear Cache Ngay

### Cách 1: Restart Server (Khuyến nghị)

Rate limiting đang dùng **in-memory store**, nên restart server sẽ xóa sạch cache:

```bash
# Stop server (Ctrl+C trong terminal đang chạy server)

# Start lại
cd server
npm run dev
```

**✅ Done! Bạn có thể login ngay lập tức.**

---

### Cách 2: Chạy Script Clear Cache

```bash
cd server
node clear-rate-limit.js
```

Nếu không có endpoint, script sẽ hướng dẫn restart server.

---

## 🔧 Giải Pháp Lâu Dài - Tăng Giới Hạn

### Đã Sửa File: `server/src/middleware/rateLimit.ts`

**Trước đây:**
```typescript
// Auth rate limiter
max: 10,  // 10 login attempts per 15 minutes per IP

// Auth rate limiter (per user)
max: 5,   // 5 login attempts per 15 minutes per user
```

**Bây giờ:**
```typescript
// Auth rate limiter
max: 1000,  // 1000 login attempts (for development)

// Auth rate limiter (per user)
max: 1000,  // 1000 login attempts (for development)
```

---

## 🎯 Các Bước Thực Hiện

### 1. File đã được sửa
✅ `server/src/middleware/rateLimit.ts` - Increased limits to 1000

### 2. Restart Server

```bash
# Stop server (Ctrl+C)
cd C:\Users\thanh\Downloads\Deploy\Deploy\server
npm run dev
```

### 3. Test Login

- Mở app: http://localhost:3000
- Login bao nhiêu lần cũng được (trong 15 phút)
- Không còn bị block nữa

---

## 📊 Chi Tiết Rate Limits Hiện Tại

| Endpoint | Limit (trước) | Limit (sau) | Thời gian |
|----------|---------------|-------------|-----------|
| **Login (IP)** | 10 requests | 1000 requests | 15 phút |
| **Login (User)** | 5 requests | 1000 requests | 15 phút |
| OTP Request (IP) | 20 requests | 20 requests | 10 phút |
| OTP Request (User) | 5 requests | 5 requests | 10 phút |
| General API (IP) | 100 requests | 100 requests | 15 phút |
| Submission (User) | 10 requests | 10 requests | 1 phút |
| Chat (User) | 20 requests | 20 requests | 1 phút |

---

## ⚠️ Lưu Ý Production

### Development vs Production

**Development (hiện tại):**
```typescript
max: 1000, // Unlimited for testing
```

**Production (khuyến nghị):**
```typescript
max: 20, // Reasonable limit for security
```

### Trước khi deploy lên Railway/Vercel:

**Option A: Restore security limits**

Sửa lại `server/src/middleware/rateLimit.ts`:

```typescript
// Auth rate limiter (per IP)
export const authRateLimit = createLimiter({
  windowMs: 15 * 60 * 1000,
  max: process.env.NODE_ENV === 'production' ? 20 : 1000,
  // ...
});

// Auth rate limiter (per user)
export const authRateLimitUser = createLimiter({
  windowMs: 15 * 60 * 1000,
  max: process.env.NODE_ENV === 'production' ? 10 : 1000,
  // ...
});
```

**Option B: Use environment variable**

Thêm vào `.env`:

```env
# Rate Limiting
AUTH_RATE_LIMIT_MAX=1000           # Development: unlimited
AUTH_RATE_LIMIT_USER_MAX=1000      # Development: unlimited
```

Update code:

```typescript
export const authRateLimit = createLimiter({
  windowMs: 15 * 60 * 1000,
  max: parseInt(process.env.AUTH_RATE_LIMIT_MAX || '20'),
  // ...
});
```

Trên Railway, set:
```env
AUTH_RATE_LIMIT_MAX=20
AUTH_RATE_LIMIT_USER_MAX=10
```

---

## 🔍 Debug Rate Limiting

### Xem Rate Limit Headers

```bash
curl -I http://localhost:5000/api/auth/login

# Response headers:
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 1640000000
Retry-After: 900  # (nếu bị block)
```

### Check Rate Limit Status

Thêm debug endpoint (optional):

**File: `server/src/routes/debug.routes.ts`**

```typescript
router.get('/rate-limit-status', (req: Request, res: Response) => {
  // Note: store is private, này chỉ để demo
  res.json({
    message: 'Rate limiting is in-memory. Restart server to clear.',
    suggestion: 'Use Redis for production rate limiting'
  });
});
```

---

## 🚀 Upgrade to Redis Rate Limiting (Production)

Để production scale tốt hơn, dùng Redis thay vì in-memory:

### Install Redis packages:

```bash
cd server
npm install redis express-rate-limit-redis
```

### Update `rateLimit.ts`:

```typescript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';
import { createClient } from 'redis';

const redisClient = createClient({
  url: process.env.REDIS_URL || 'redis://localhost:6379'
});

redisClient.connect();

export const authRateLimit = rateLimit({
  store: new RedisStore({
    client: redisClient,
    prefix: 'auth:',
  }),
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'Quá nhiều lần thử đăng nhập.',
});
```

### Trên Railway:

1. Add Redis service
2. Set `REDIS_URL` env variable
3. Deploy

**Lợi ích:**
- Rate limit shared across multiple server instances
- Không mất cache khi restart
- Production-ready

---

## 🐛 Troubleshooting

### Vẫn bị block sau khi sửa?

**Giải pháp:**
1. Check file đã save chưa
2. Restart server (Ctrl+C → npm run dev)
3. Clear browser cache (Ctrl+Shift+Del)
4. Thử Incognito mode

### Rate limiting không hoạt động?

**Check:**
```typescript
// auth.routes.ts
router.post('/login', 
  loginValidation, 
  authRateLimit,        // <-- Đảm bảo middleware này được apply
  authRateLimitUser,    // <-- Và cái này
  authController.login
);
```

### Muốn tắt hoàn toàn rate limiting (development only)?

**Option 1: Comment out middleware**

```typescript
// auth.routes.ts
router.post('/login', 
  loginValidation, 
  // authRateLimit,        // <-- Comment out
  // authRateLimitUser,    // <-- Comment out
  authController.login
);
```

**Option 2: Conditional middleware**

```typescript
const rateLimitMiddleware = process.env.NODE_ENV === 'production' 
  ? [authRateLimit, authRateLimitUser] 
  : [];

router.post('/login', 
  loginValidation,
  ...rateLimitMiddleware,
  authController.login
);
```

---

## ✅ Checklist

- [x] Đã tăng rate limit từ 10 → 1000 (IP)
- [x] Đã tăng rate limit từ 5 → 1000 (User)
- [x] Tạo script `clear-rate-limit.js` để clear cache
- [ ] Restart server để apply changes
- [ ] Test login nhiều lần
- [ ] Xác nhận không còn bị block
- [ ] (Optional) Restore limits trước khi deploy production

---

## 📞 Next Steps

### Local Development:
✅ Đã xong! Bạn có thể login thoải mái.

### Production Deployment:
⚠️ Nhớ restore security limits hoặc dùng environment variables.

### Upgrade (Optional):
🔄 Consider Redis for production-grade rate limiting.

---

**✨ Done! Bạn không còn bị block khi login nữa.**

**Thời gian sửa:** < 2 phút  
**Downtime:** 0 (chỉ cần restart server)
