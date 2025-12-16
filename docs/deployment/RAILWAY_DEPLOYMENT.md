# 🚂 Hướng Dẫn Deploy Backend Lên Railway

> Deploy Express Backend + Judge0 Docker lên Railway

---

## 📋 Tổng Quan

**Railway** là platform cho phép deploy backend và Docker containers miễn phí (có giới hạn).

**Trong guide này:**
- ✅ Deploy Express Backend
- ✅ Deploy Judge0 với Docker
- ✅ Cấu hình environment variables
- ✅ Kết nối MongoDB Atlas
- ✅ Setup domain và HTTPS

---

## 🎯 Phần 1: Chuẩn Bị

### Bước 1.1: Tạo tài khoản Railway

1. Truy cập: https://railway.app/
2. Sign up với **GitHub account** (khuyến nghị)
3. Verify email

### Bước 1.2: Kiểm tra code đã push lên GitHub

```bash
cd C:\Users\thanh\Downloads\Deploy\Deploy

# Kiểm tra git status
git status

# Nếu có thay đổi, commit và push
git add .
git commit -m "chore: prepare for deployment"
git push origin main
```

### Bước 1.3: Chuẩn bị file cần thiết

Railway cần các file sau (tôi sẽ tạo cho bạn):
- ✅ `railway.json` - Railway config
- ✅ `Dockerfile` - Để build Backend
- ✅ `.dockerignore` - Ignore files khi build
- ✅ `nixpacks.toml` - Nixpacks config (optional)

---

## 🐳 Phần 2: Deploy Backend (Express Server)

### Bước 2.1: Tạo Project trên Railway

1. Đăng nhập vào https://railway.app/
2. Click **"New Project"**
3. Chọn **"Deploy from GitHub repo"**
4. Authorize Railway với GitHub (nếu chưa)
5. Chọn repository: **Deploy**
6. Railway sẽ tự động detect và deploy

### Bước 2.2: Cấu hình Service

1. Trong Railway dashboard, click vào **service** vừa tạo
2. Vào tab **"Settings"**
3. **Root Directory**: Đặt là `server` (vì code backend ở thư mục này)
4. **Start Command**: `npm start`
5. **Build Command**: `npm install && npm run build`

### Bước 2.3: Thêm Environment Variables

Vào tab **"Variables"**, thêm các biến sau:

```env
# Server Config
NODE_ENV=production
PORT=5000

# MongoDB Atlas (copy từ .env của bạn)
MONGODB_URI=mongodb+srv://your-username:your-password@cluster0.xxxxx.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-railway-2024
JWT_EXPIRE=7d

# OAuth (copy từ .env)
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret

# Client URL (sẽ update sau khi deploy Vercel)
CLIENT_URL=https://your-app.vercel.app

# Judge0 (sẽ setup ở Phần 3)
JUDGE0_API_URL=http://judge0:2358
JUDGE0_API_KEY=your-judge0-api-key

# Gemini AI (copy từ .env)
GEMINI_API_KEY=your-gemini-api-key

# Admin
ADMIN_EMAIL=admin@bughunter.com
```

⚠️ **LƯU Ý:** Railway sẽ tự động restart sau khi thêm variables.

### Bước 2.4: Lấy Railway Backend URL

1. Trong service settings, vào tab **"Settings"**
2. Scroll xuống **"Domains"**
3. Click **"Generate Domain"**
4. Railway sẽ tạo domain dạng: `your-service.up.railway.app`
5. **Lưu lại URL này!** (dùng cho Frontend)

---

## 🐋 Phần 3: Deploy Judge0 Docker Container

Judge0 cần Redis, PostgreSQL và Judge0 API. Trên Railway, bạn cần tạo 3 services riêng.

### Option A: Deploy Judge0 Trên Railway (Phức tạp - FREE tier có thể không đủ)

**⚠️ Vấn đề:** Railway FREE tier giới hạn resources, Judge0 cần nhiều services (Redis, PostgreSQL, Judge0 API).

**Khuyến nghị:** Dùng **Judge0 CE RapidAPI** (miễn phí, dễ setup hơn) - xem Option B.

#### Bước 3A.1: Tạo Redis Service

1. Trong Railway project, click **"New"** → **"Database"** → **"Add Redis"**
2. Railway tự tạo Redis service
3. Copy **Redis URL** (có dạng: `redis://default:password@host:port`)

#### Bước 3A.2: Tạo PostgreSQL Service

1. Click **"New"** → **"Database"** → **"Add PostgreSQL"**
2. Railway tự tạo PostgreSQL
3. Copy **DATABASE_URL**

#### Bước 3A.3: Tạo Judge0 Service

1. Click **"New"** → **"Empty Service"**
2. Vào **"Settings"** → **"Source"**
3. Chọn **"Docker Image"**: `judge0/judge0:1.13.0`
4. Thêm Environment Variables:

```env
REDIS_HOST=<redis-internal-url>
REDIS_PORT=6379
POSTGRES_HOST=<postgres-internal-url>
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<postgres-password>
POSTGRES_DB=judge0
ENABLE_WORKER=true
ENABLE_CE=true
MAX_CPU_TIME_LIMIT=15
MAX_WALL_TIME_LIMIT=30
```

5. Expose port **2358**
6. Generate domain cho Judge0

**⚠️ Lưu ý:** Cách này tốn nhiều resources và có thể vượt FREE tier.

---

### Option B: Dùng Judge0 CE trên RapidAPI (Khuyến nghị)

**Ưu điểm:**
- ✅ Miễn phí (50 requests/day)
- ✅ Không cần setup Docker
- ✅ Ổn định, nhanh
- ✅ Không tốn Railway resources

#### Bước 3B.1: Đăng ký RapidAPI

1. Truy cập: https://rapidapi.com/judge0-official/api/judge0-ce
2. Sign up hoặc login
3. Subscribe **FREE plan** (50 calls/day)
4. Copy **API Key** từ dashboard

#### Bước 3B.2: Update Environment Variables trên Railway

Vào Backend service → Variables, update:

```env
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=<your-rapidapi-key>
```

#### Bước 3B.3: Update Code (Nếu cần)

Code của bạn đã support RapidAPI Judge0! Kiểm tra file `server/src/services/judge0Service.ts`:

```typescript
// Code đã có logic check RapidAPI headers
if (this.apiKey) {
  headers['X-RapidAPI-Key'] = this.apiKey;
  headers['X-RapidAPI-Host'] = 'judge0-ce.p.rapidapi.com';
}
```

✅ **Không cần thay đổi code!**

---

### Option C: Dùng Judge0 CE Self-hosted Khác (Render, Fly.io)

Nếu muốn self-host Judge0 miễn phí, có thể dùng:
- **Render.com** (FREE tier, có Docker support)
- **Fly.io** (FREE tier với Docker)

Chi tiết xem: `docs/deployment/JUDGE0_EXTERNAL_HOSTING.md`

---

## 🔧 Phần 4: Cấu Hình CORS và OAuth Callbacks

### Bước 4.1: Update CORS trong Code

Đảm bảo CORS cho phép domain production:

File: `server/src/app.ts`

```typescript
app.use(cors({
  origin: process.env.NODE_ENV === 'production'
    ? [
        process.env.CLIENT_URL,
        "https://your-app.vercel.app",
        "https://bughunter-backend.up.railway.app"
      ]
    : true,
  credentials: true
}));
```

### Bước 4.2: Update OAuth Callback URLs

#### Google OAuth:
1. Vào: https://console.cloud.google.com/
2. Credentials → Chọn OAuth Client
3. **Authorized JavaScript origins**: Thêm
   - `https://your-backend.up.railway.app`
   - `https://your-app.vercel.app`
4. **Authorized redirect URIs**: Thêm
   - `https://your-backend.up.railway.app/api/auth/google/callback`

#### GitHub OAuth:
1. Vào: https://github.com/settings/developers
2. Chọn OAuth App
3. **Authorization callback URL**: Update
   - `https://your-backend.up.railway.app/api/auth/github/callback`

#### Facebook OAuth:
1. Vào: https://developers.facebook.com/
2. App Settings → Basic
3. **App Domains**: Thêm `your-backend.up.railway.app`
4. **Valid OAuth Redirect URIs**: Thêm
   - `https://your-backend.up.railway.app/api/auth/facebook/callback`

---

## ✅ Phần 5: Verify Deployment

### Bước 5.1: Kiểm tra Backend Health

1. Mở browser, truy cập:
   ```
   https://your-backend.up.railway.app/api/debug/health
   ```

2. Nếu thành công, bạn sẽ thấy:
   ```json
   {
     "status": "ok",
     "mongodb": "connected",
     "judge0": "healthy"
   }
   ```

### Bước 5.2: Kiểm tra Logs

1. Trong Railway dashboard, click vào service
2. Vào tab **"Logs"**
3. Xem logs deploy và runtime:
   ```
   ✅ MongoDB Connected Successfully!
   Server is running on port 5000
   ```

### Bước 5.3: Test API Endpoints

```bash
# Test health check
curl https://your-backend.up.railway.app/api/debug/health

# Test challenges endpoint
curl https://your-backend.up.railway.app/api/challenges
```

---

## 🐛 Troubleshooting

### Lỗi: "Application failed to respond"

**Nguyên nhân:** Port không đúng hoặc app không start

**Giải pháp:**
1. Kiểm tra Environment Variable `PORT=5000`
2. Đảm bảo `server/src/app.ts` listen đúng port:
   ```typescript
   const PORT = process.env.PORT || 5000;
   server.listen(PORT, () => {
     console.log(`Server is running on port ${PORT}`);
   });
   ```

### Lỗi: "Cannot connect to MongoDB"

**Nguyên nhân:** MongoDB URI sai hoặc IP chưa whitelist

**Giải pháp:**
1. Kiểm tra `MONGODB_URI` trong Railway Variables
2. Vào MongoDB Atlas → Network Access → Whitelist `0.0.0.0/0`

### Lỗi: "Build failed"

**Nguyên nhân:** Missing dependencies hoặc TypeScript error

**Giải pháp:**
1. Xem logs trong Railway để biết lỗi cụ thể
2. Đảm bảo `tsconfig.json` và `package.json` đúng
3. Test build local trước:
   ```bash
   cd server
   npm install
   npm run build
   ```

### Lỗi: "Judge0 not responding"

**Nguyên nhân:** Judge0 service chưa chạy hoặc URL sai

**Giải pháp:**
- Nếu dùng **RapidAPI**: Kiểm tra API key và quota
- Nếu dùng **Self-hosted**: Kiểm tra Judge0 service logs
- Test Judge0 endpoint:
  ```bash
  curl https://judge0-ce.p.rapidapi.com/languages \
    -H "X-RapidAPI-Key: your-key"
  ```

---

## 📊 Monitoring và Scaling

### Free Tier Limits (Railway)

- **Execution Time**: 500 hours/month
- **RAM**: 512 MB - 8 GB
- **Disk**: 1 GB
- **Network**: 100 GB/month

### Upgrade khi cần

Nếu traffic tăng:
1. Railway Hobby Plan: $5/month
2. Hoặc scale sang AWS, GCP, DigitalOcean

---

## 🔐 Bảo Mật Production

### ✅ Checklist:

- [ ] Đổi `JWT_SECRET` thành giá trị mạnh
- [ ] Whitelist IP cụ thể trên MongoDB Atlas (không dùng 0.0.0.0/0)
- [ ] Enable HTTPS (Railway tự enable)
- [ ] Set `NODE_ENV=production`
- [ ] Rate limiting đã enable (code có sẵn)
- [ ] Helmet middleware đã enable (code có sẵn)
- [ ] CORS chỉ cho phép domain cụ thể

---

## 📚 Next Steps

1. ✅ Backend đã deploy lên Railway
2. ➡️ Deploy Frontend lên Vercel (xem `VERCEL_DEPLOYMENT.md`)
3. ➡️ Update `CLIENT_URL` trong Railway Variables
4. ➡️ Test toàn bộ flow end-to-end

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
- Railway Docs: https://docs.railway.app/
- Railway Discord: https://discord.gg/railway
- GitHub Issues của project

---

**Made with ❤️ by BugHunter Team**
