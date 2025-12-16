# 🚀 Deployment Guide - BugHunter Full Stack

> Hướng dẫn deploy complete: Frontend (Vercel) + Backend (Railway) + Judge0

---

## 📋 Tổng Quan Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         PRODUCTION                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │   Frontend   │────────▶│   Backend    │                 │
│  │   (Vercel)   │  HTTPS  │  (Railway)   │                 │
│  │  React+Vite  │         │ Express+TS   │                 │
│  └──────────────┘         └──────┬───────┘                 │
│        │                          │                          │
│        │                          ├──────────┐              │
│        │                          │          │              │
│        │                  ┌───────▼───┐  ┌───▼──────────┐  │
│        │                  │ MongoDB   │  │   Judge0     │  │
│        └─────OAuth────────│  Atlas    │  │  RapidAPI    │  │
│          Callbacks        │  (Cloud)  │  │  or Docker   │  │
│                           └───────────┘  └──────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## ⏱️ Timeline Ước Tính

| Bước | Mô tả | Thời gian |
|------|-------|-----------|
| 1 | Chuẩn bị và commit code | 15 phút |
| 2 | Deploy Backend (Railway) | 20 phút |
| 3 | Setup Judge0 (RapidAPI hoặc Docker) | 15 phút |
| 4 | Deploy Frontend (Vercel) | 10 phút |
| 5 | Cấu hình OAuth callbacks | 10 phút |
| 6 | Testing end-to-end | 20 phút |
| **TỔNG** | | **~90 phút** |

---

## 📦 Phần 1: Chuẩn Bị (15 phút)

### ✅ Checklist Trước Khi Deploy

- [ ] Code đã được test kỹ trên local
- [ ] MongoDB Atlas đã setup và có data
- [ ] Git repository đã push lên GitHub
- [ ] Environment variables đã document
- [ ] Dependencies đã update và fix vulnerabilities

### Bước 1.1: Kiểm Tra Git

```bash
cd C:\Users\thanh\Downloads\Deploy\Deploy

# Check branch
git branch
# Đảm bảo đang ở main

# Check status
git status
# Đảm bảo không có uncommitted changes

# Check remote
git remote -v
# Đảm bảo có origin
```

### Bước 1.2: Commit Các File Config

```bash
# Add deployment files
git add server/Dockerfile
git add server/.dockerignore
git add railway.json
git add client/vercel.json
git add docs/deployment/

# Commit
git commit -m "chore: add deployment configurations

- Dockerfile for Railway backend
- vercel.json for SPA routing
- railway.json for Railway config
- Deployment documentation

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"

# Push
git push origin main
```

### Bước 1.3: Document Environment Variables

Tạo file reference cho environment variables (KHÔNG commit):

**File: `deployment-env-reference.txt`** (gitignore)

```env
# ===== BACKEND (Railway) =====
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://...
JWT_SECRET=...
JWT_EXPIRE=7d
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GITHUB_CLIENT_ID=...
GITHUB_CLIENT_SECRET=...
FACEBOOK_APP_ID=...
FACEBOOK_APP_SECRET=...
CLIENT_URL=https://your-app.vercel.app
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=...
GEMINI_API_KEY=...
ADMIN_EMAIL=admin@bughunter.com

# ===== FRONTEND (Vercel) =====
VITE_API_URL=https://your-backend.up.railway.app
NODE_ENV=production
```

---

## 🚂 Phần 2: Deploy Backend (Railway) - 20 phút

### Bước 2.1: Tạo Railway Account

1. Truy cập: https://railway.app/
2. Sign up với GitHub
3. Verify email

### Bước 2.2: Deploy Backend Service

1. Dashboard → **New Project** → **Deploy from GitHub**
2. Authorize Railway với GitHub
3. Chọn repository: **Deploy**
4. Railway auto-detect và deploy

### Bước 2.3: Cấu Hình Service

**Settings:**
- Root Directory: `server`
- Build Command: `npm install && npm run build`
- Start Command: `npm start`
- Dockerfile Path: `server/Dockerfile`

### Bước 2.4: Thêm Environment Variables

Copy từ `deployment-env-reference.txt`, paste vào Railway Variables.

**⚠️ LƯU Ý:** Chưa có `CLIENT_URL` và `JUDGE0_API_URL`, sẽ update sau.

### Bước 2.5: Generate Domain

1. Settings → Domains → **Generate Domain**
2. Railway tạo URL: `https://your-service.up.railway.app`
3. **LƯU LẠI URL NÀY!**

### Bước 2.6: Verify Deployment

```bash
# Test health endpoint
curl https://your-backend.up.railway.app/api/debug/health

# Expected response:
{
  "status": "ok",
  "mongodb": "connected"
}
```

**Chi tiết:** Xem `docs/deployment/RAILWAY_DEPLOYMENT.md`

---

## 🎮 Phần 3: Setup Judge0 - 15 phút

### Option A: Judge0 RapidAPI (Khuyến nghị - Dễ nhất)

#### Bước 3A.1: Đăng ký RapidAPI

1. Truy cập: https://rapidapi.com/judge0-official/api/judge0-ce
2. Sign up / Login
3. Subscribe **FREE plan** (50 calls/day)
4. Copy **X-RapidAPI-Key** từ dashboard

#### Bước 3A.2: Update Railway Variables

```env
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=<your-rapidapi-key>
```

Railway tự restart sau khi save.

#### Bước 3A.3: Test Judge0

```bash
curl https://your-backend.up.railway.app/api/debug/test/judge0

# Expected: Judge0 available và có thể submit code
```

**✅ Xong! Code của bạn đã support RapidAPI Judge0.**

---

### Option B: Self-hosted Judge0 trên Railway (Advanced)

⚠️ **Cảnh báo:** Railway FREE tier có thể không đủ resources!

#### Bước 3B.1: Add Redis

Railway → **New** → **Database** → **Redis**

#### Bước 3B.2: Add PostgreSQL

Railway → **New** → **Database** → **PostgreSQL**

#### Bước 3B.3: Add Judge0 Service

1. **New** → **Empty Service**
2. Source: Docker Image
3. Image: `judge0/judge0:1.13.0`
4. Environment Variables:

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

5. Expose port: `2358`
6. Generate domain

#### Bước 3B.4: Update Backend Variables

```env
JUDGE0_API_URL=https://judge0-service.up.railway.app
JUDGE0_API_KEY=
```

**Chi tiết:** Xem `docs/deployment/RAILWAY_DEPLOYMENT.md` → Phần 3

---

## ▲ Phần 4: Deploy Frontend (Vercel) - 10 phút

### Bước 4.1: Tạo Vercel Account

1. Truy cập: https://vercel.com/signup
2. Sign up với GitHub
3. Authorize Vercel

### Bước 4.2: Import Project

1. Dashboard → **Add New** → **Project**
2. Import repository: **Deploy**
3. Vercel auto-detect Vite

### Bước 4.3: Cấu Hình Build

- Framework: **Vite**
- Root Directory: `client`
- Build Command: `npm run build`
- Output Directory: `dist`

### Bước 4.4: Thêm Environment Variables

```env
VITE_API_URL=https://your-backend.up.railway.app
NODE_ENV=production
```

Thay `your-backend.up.railway.app` bằng Railway URL thật.

### Bước 4.5: Deploy

Click **Deploy** → Đợi 2-3 phút

### Bước 4.6: Lấy Vercel URL

Vercel tạo domain: `https://your-app.vercel.app`

**LƯU LẠI URL NÀY!**

**Chi tiết:** Xem `docs/deployment/VERCEL_DEPLOYMENT.md`

---

## 🔗 Phần 5: Kết Nối Frontend - Backend - 10 phút

### Bước 5.1: Update CLIENT_URL trên Railway

Railway Backend → Variables:

```env
CLIENT_URL=https://your-app.vercel.app
```

Save → Railway tự restart.

### Bước 5.2: Verify API Connection

1. Mở: `https://your-app.vercel.app`
2. Open DevTools Console
3. Không có CORS errors
4. API calls đến đúng Railway URL

### Bước 5.3: Update OAuth Callbacks

#### Google OAuth:

1. https://console.cloud.google.com/
2. Credentials → OAuth Client
3. Authorized origins: Thêm
   - `https://your-backend.up.railway.app`
   - `https://your-app.vercel.app`
4. Redirect URIs: Thêm
   - `https://your-backend.up.railway.app/api/auth/google/callback`

#### GitHub OAuth:

1. https://github.com/settings/developers
2. OAuth App
3. Homepage: `https://your-app.vercel.app`
4. Callback: `https://your-backend.up.railway.app/api/auth/github/callback`

#### Facebook OAuth:

1. https://developers.facebook.com/
2. App Settings
3. App Domains: `your-app.vercel.app`
4. OAuth Redirect: `https://your-backend.up.railway.app/api/auth/facebook/callback`

---

## ✅ Phần 6: Testing End-to-End - 20 phút

### Test Checklist

#### 1. Authentication
- [ ] Đăng ký user mới
- [ ] Đăng nhập với email/password
- [ ] Đăng nhập Google OAuth
- [ ] Đăng nhập GitHub OAuth
- [ ] Đăng nhập Facebook OAuth
- [ ] Logout

#### 2. Challenges
- [ ] Load danh sách challenges
- [ ] Xem chi tiết challenge
- [ ] Submit code (test Judge0)
- [ ] Xem kết quả submission
- [ ] AI analysis hiển thị đúng

#### 3. PvP System
- [ ] Tạo phòng PvP
- [ ] Join phòng
- [ ] Submit code trong PvP
- [ ] Real-time updates (WebSocket)
- [ ] Kết thúc match và update Elo

#### 4. Other Features
- [ ] Leaderboard load đúng
- [ ] Friend system
- [ ] Notifications
- [ ] Comments
- [ ] Favorites

#### 5. Admin Panel
- [ ] Đăng nhập admin
- [ ] Quản lý users
- [ ] Quản lý challenges
- [ ] View statistics

---

## 🐛 Troubleshooting Common Issues

### 1. CORS Errors

**Lỗi:** "Access to XMLHttpRequest has been blocked by CORS"

**Giải pháp:**
```typescript
// server/src/app.ts
app.use(cors({
  origin: [
    process.env.CLIENT_URL,
    "https://your-app.vercel.app"
  ],
  credentials: true
}));
```

### 2. OAuth Not Working

**Lỗi:** Redirect loop hoặc authentication failed

**Giải pháp:**
- Re-check callback URLs (phải là Railway backend URL)
- Clear cookies và test với Incognito
- Verify CLIENT_URL trong Railway Variables

### 3. Judge0 Timeout

**Lỗi:** "Judge0 API timeout"

**Giải pháp:**
- Kiểm tra JUDGE0_API_KEY (RapidAPI)
- Test Judge0 trực tiếp: `curl https://judge0-ce.p.rapidapi.com/languages`
- Nếu self-hosted: Check Judge0 service logs

### 4. WebSocket Connection Failed

**Lỗi:** PvP real-time không hoạt động

**Giải pháp:**
```typescript
// client/src/services/websocket.ts
const socket = io(import.meta.env.VITE_API_URL, {
  withCredentials: true,
  transports: ['websocket', 'polling']
});
```

### 5. 404 on Page Refresh (Vercel)

**Lỗi:** Refresh trang bị 404

**Giải pháp:**
- Đảm bảo có file `client/vercel.json` với rewrites
- Vercel sẽ tự động apply config

---

## 📊 Monitoring và Maintenance

### Railway Monitoring

1. Railway Dashboard → Service → **Metrics**
2. Theo dõi:
   - CPU usage
   - Memory usage
   - Network traffic
   - Response time

### Vercel Analytics

1. Vercel Project → **Analytics**
2. Enable Vercel Analytics
3. Theo dõi:
   - Page views
   - Performance (Core Web Vitals)
   - Error rate

### MongoDB Atlas Monitoring

1. Atlas Dashboard → Cluster → **Metrics**
2. Theo dõi:
   - Connections
   - Operations/sec
   - Storage size

---

## 💰 Cost Estimate

### FREE Tier Limits

| Service | FREE Tier | Limit |
|---------|-----------|-------|
| **Railway** | $5 credit/month | ~500 hours execution |
| **Vercel** | Hobby Plan | 100 GB bandwidth, unlimited projects |
| **MongoDB Atlas** | M0 FREE | 512 MB storage |
| **Judge0 RapidAPI** | FREE | 50 calls/day |

### Khi Nào Cần Upgrade?

- Railway: Khi > 500 hours/month → **Hobby $5/month**
- Vercel: Khi > 100 GB bandwidth → **Pro $20/month**
- MongoDB: Khi > 512 MB → **M2 $9/month**
- Judge0: Khi > 50 calls/day → **Basic $10/month**

**Ước tính chi phí ban đầu:** **$0/month** (FREE tier đủ dùng)

---

## 📚 Documentation Deployment

### Files Đã Tạo

```
docs/deployment/
├── RAILWAY_DEPLOYMENT.md      # Chi tiết Railway backend
├── VERCEL_DEPLOYMENT.md       # Chi tiết Vercel frontend
└── DEPLOYMENT_COMPLETE.md     # File này - tổng hợp

server/
├── Dockerfile                 # Docker config cho Railway
├── .dockerignore             # Docker ignore
└── railway.json              # Railway config

client/
└── vercel.json               # Vercel SPA routing
```

### Chia Sẻ Cho Team

1. Commit tất cả docs lên GitHub
2. Team members đọc:
   - `DEPLOYMENT_COMPLETE.md` (overview)
   - `RAILWAY_DEPLOYMENT.md` (backend details)
   - `VERCEL_DEPLOYMENT.md` (frontend details)

---

## 🎉 Phần 7: Go Live!

### Pre-Launch Checklist

- [ ] Tất cả tests đã pass
- [ ] OAuth đã config đúng
- [ ] Environment variables đã secure
- [ ] Monitoring đã setup
- [ ] Backup database đã có
- [ ] Custom domain đã config (optional)
- [ ] SSL certificates active (auto)
- [ ] Error logging setup (optional)

### Launch Steps

1. **Announcement:**
   - Thông báo cho team
   - Post lên social media (nếu cần)
   - Email đến early users

2. **Monitor:**
   - Theo dõi logs 24h đầu
   - Check error rates
   - User feedback

3. **Iterate:**
   - Fix bugs nhanh chóng
   - Deploy hotfixes nếu cần
   - Update documentation

---

## 🔄 Continuous Deployment

### Auto-Deploy Flow

```
Developer → Push to GitHub
                ↓
         GitHub Webhook
          ↙         ↘
    Railway      Vercel
    Auto-deploy  Auto-deploy
          ↘         ↙
        Production Live
```

### Branch Strategy

- `main` → Production (Railway + Vercel)
- `develop` → Preview deployments (Vercel preview)
- Feature branches → PR previews

---

## 📞 Support và Resources

### Official Docs
- Railway: https://docs.railway.app/
- Vercel: https://vercel.com/docs
- MongoDB Atlas: https://docs.atlas.mongodb.com/

### Community
- Railway Discord: https://discord.gg/railway
- Vercel Discord: https://vercel.com/discord

### Project Resources
- GitHub Repository: [Your repo URL]
- Production URL: https://your-app.vercel.app
- Backend API: https://your-backend.up.railway.app

---

## ✅ Final Checklist

- [ ] Backend deployed lên Railway
- [ ] Frontend deployed lên Vercel
- [ ] Judge0 hoạt động (RapidAPI hoặc self-hosted)
- [ ] MongoDB Atlas connected
- [ ] OAuth callbacks updated
- [ ] CORS configured
- [ ] Environment variables set
- [ ] All tests passed
- [ ] Documentation updated
- [ ] Team notified

---

**🎊 CHÚC MỪNG! BẠN ĐÃ DEPLOY THÀNH CÔNG!**

**Production URLs:**
- Frontend: `https://your-app.vercel.app`
- Backend: `https://your-backend.up.railway.app`
- Admin: `https://your-app.vercel.app/admin` (admin@bughunter.com / admin123)

---

**Made with ❤️ by BugHunter Team**
**Deployed on:** [Date]
**Version:** 1.0.0
