# ▲ Hướng Dẫn Deploy Frontend Lên Vercel

> Deploy React Frontend lên Vercel với automatic deployments

---

## 📋 Tổng Quan

**Vercel** là platform tốt nhất để deploy React/Next.js apps. Miễn phí, nhanh, và tự động deploy khi push code.

**Features:**
- ✅ Deploy tự động từ GitHub
- ✅ HTTPS miễn phí
- ✅ CDN toàn cầu
- ✅ Preview deployments cho mỗi PR
- ✅ Environment variables

---

## 🎯 Phần 1: Chuẩn Bị

### Bước 1.1: Tạo tài khoản Vercel

1. Truy cập: https://vercel.com/signup
2. Sign up với **GitHub account** (khuyến nghị)
3. Authorize Vercel với GitHub

### Bước 1.2: Kiểm tra Build Local

Trước khi deploy, test build locally:

```bash
cd C:\Users\thanh\Downloads\Deploy\Deploy\client

# Install dependencies (nếu chưa)
npm install

# Test build
npm run build

# Test preview
npm run preview
```

Nếu build thành công, bạn sẽ thấy thư mục `dist/` được tạo.

### Bước 1.3: Tạo file `.env.production` (Template)

Vercel không dùng `.env` từ local. Bạn cần config trên Vercel Dashboard.

Tạo file `.env.example` cho team:

```env
# Backend API URL (production)
VITE_API_URL=https://your-backend.up.railway.app

# OAuth Redirect URIs (optional - nếu client cần)
VITE_GOOGLE_CLIENT_ID=your-google-client-id
```

---

## 🚀 Phần 2: Deploy Lên Vercel

### Bước 2.1: Import Project

1. Đăng nhập vào https://vercel.com/
2. Click **"Add New..."** → **"Project"**
3. Import repository: **Deploy**
4. Vercel sẽ tự động detect Vite project

### Bước 2.2: Cấu hình Project

**Framework Preset**: Vercel tự detect **Vite**

**Root Directory**: Đặt là `client` (vì code frontend ở đây)

**Build Settings:**
- **Build Command**: `npm run build`
- **Output Directory**: `dist`
- **Install Command**: `npm install`

### Bước 2.3: Thêm Environment Variables

Click **"Environment Variables"**, bạn sẽ thấy 2 cột: **Key** và **Value**.

Nhập từng dòng như sau:

| Key | Value |
|-----|-------|
| `VITE_API_URL` | `https://deploy-production-a16c.up.railway.app` |
| `NODE_ENV` | `production` |

**Cách nhập:**
1. Click vào ô **"Key"** → nhập tên biến (VD: `VITE_API_URL`)
2. Click vào ô **"Value"** → nhập giá trị (VD: `https://deploy-production-a16c.up.railway.app`)
3. Click **"Add"** hoặc nhấn Enter
4. Lặp lại cho các biến khác

⚠️ **LƯU Ý:** 
- Vite environment variables **phải bắt đầu với `VITE_`**
- Không thêm dấu ngoặc kép `""` cho value
- Không có dấu `=` giữa key và value (Vercel tự xử lý)
- Thay `deploy-production-a16c.up.railway.app` bằng Railway URL thật của bạn

### Bước 2.4: Deploy

1. Click **"Deploy"**
2. Vercel sẽ:
   - Install dependencies
   - Build project
   - Deploy lên CDN
3. Đợi 2-3 phút

### Bước 2.5: Lấy Vercel URL

Sau khi deploy xong:
1. Vercel tạo domain dạng: `your-app.vercel.app`
2. **Lưu lại URL này!**
3. Copy URL để update vào Railway Backend

---

## 🔗 Phần 3: Kết Nối Frontend - Backend

### Bước 3.1: Update Backend URL trong Frontend

#### Option A: Dùng Environment Variable (Khuyến nghị)

File: `client/src/services/api.ts` (hoặc config file tương tự)

```typescript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export const api = axios.create({
  baseURL: `${API_URL}/api`,
  withCredentials: true
});
```

Vercel sẽ tự động thay `VITE_API_URL` khi build.

#### Option B: Hardcode (Không khuyến nghị)

Nếu code chưa có env config, update trực tiếp:

```typescript
const API_URL = process.env.NODE_ENV === 'production'
  ? 'https://your-backend.up.railway.app'
  : 'http://localhost:5000';
```

### Bước 3.2: Update CLIENT_URL trên Railway

Vào Railway Backend service → Variables, update:

```env
CLIENT_URL=https://your-app.vercel.app
```

Railway sẽ tự động restart backend.

### Bước 3.3: Update CORS

Đảm bảo backend cho phép Vercel domain:

File: `server/src/app.ts`

```typescript
app.use(cors({
  origin: process.env.NODE_ENV === 'production'
    ? [
        process.env.CLIENT_URL,
        "https://your-app.vercel.app" // Vercel URL
      ]
    : true,
  credentials: true
}));
```

Commit và push → Railway tự deploy lại.

---

## 🔐 Phần 4: Cấu Hình OAuth Redirects

### Bước 4.1: Update Google OAuth

1. Vào: https://console.cloud.google.com/
2. Credentials → OAuth Client
3. **Authorized JavaScript origins**: Thêm
   - `https://your-app.vercel.app`
4. **Authorized redirect URIs**: Thêm
   - `https://your-backend.up.railway.app/api/auth/google/callback`

### Bước 4.2: Update GitHub OAuth

1. Vào: https://github.com/settings/developers
2. OAuth App → Update
3. **Homepage URL**: `https://your-app.vercel.app`
4. **Authorization callback URL**: 
   - `https://your-backend.up.railway.app/api/auth/github/callback`

### Bước 4.3: Update Facebook OAuth

1. Vào: https://developers.facebook.com/
2. App Settings
3. **App Domains**: `your-app.vercel.app`
4. **Valid OAuth Redirect URIs**:
   - `https://your-backend.up.railway.app/api/auth/facebook/callback`

---

## ⚙️ Phần 5: Custom Domain (Optional)

### Bước 5.1: Thêm Domain

1. Vào Vercel Project → **Settings** → **Domains**
2. Click **"Add"**
3. Nhập domain của bạn (ví dụ: `bughunter.com`)
4. Follow hướng dẫn update DNS

### Bước 5.2: Update DNS Records

Tại nhà cung cấp domain (GoDaddy, Namecheap,...), thêm records:

**A Record:**
```
Type: A
Name: @
Value: 76.76.21.21
```

**CNAME Record:**
```
Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

### Bước 5.3: Verify Domain

1. Đợi DNS propagate (5-30 phút)
2. Vercel tự động verify và enable HTTPS
3. Domain sẽ redirect tự động

---

## 🔄 Phần 6: Automatic Deployments

### Branch Deployments

Vercel tự động deploy mỗi khi:
- ✅ Push lên `main` branch → Production
- ✅ Push lên branch khác → Preview deployment
- ✅ Tạo Pull Request → Preview URL

### Cấu hình Git Integration

1. Vào Project → **Settings** → **Git**
2. **Production Branch**: `main`
3. **Deploy Hooks**: Enable/Disable tùy ý

### Preview Deployments

Mỗi PR sẽ có preview URL dạng:
```
https://your-app-git-feature-branch-username.vercel.app
```

---

## ✅ Phần 7: Verify Deployment

### Bước 7.1: Test Frontend

1. Truy cập: `https://your-app.vercel.app`
2. Kiểm tra:
   - ✅ Trang load đúng
   - ✅ Không có lỗi console
   - ✅ Assets (images, fonts) load đúng

### Bước 7.2: Test API Connection

1. Đăng nhập hoặc đăng ký
2. Test các features:
   - ✅ Authentication
   - ✅ Load challenges
   - ✅ Submit code (Judge0)
   - ✅ PvP mode
   - ✅ Leaderboard

### Bước 7.3: Test OAuth

1. Test đăng nhập Google
2. Test đăng nhập GitHub
3. Test đăng nhập Facebook

Nếu lỗi, check:
- OAuth callback URLs đã update đúng chưa
- CORS đã allow Vercel domain chưa

---

## 🐛 Troubleshooting

### Lỗi: "Build failed"

**Nguyên nhân:** TypeScript errors hoặc missing dependencies

**Giải pháp:**
1. Check logs trong Vercel dashboard
2. Test build locally: `npm run build`
3. Fix errors và push lại

### Lỗi: "Cannot connect to backend"

**Nguyên nhân:** `VITE_API_URL` sai hoặc CORS issue

**Giải pháp:**
1. Check Environment Variables trong Vercel
2. Verify Railway backend đang chạy
3. Check CORS config trong backend
4. Test API trực tiếp: `curl https://backend-url/api/health`

### Lỗi: "OAuth not working"

**Nguyên nhân:** Callback URLs chưa update

**Giải pháp:**
1. Re-check OAuth settings (Google, GitHub, Facebook)
2. Đảm bảo callback URL là Railway backend URL, KHÔNG phải Vercel URL
3. Test với Incognito mode để clear cookies

### Lỗi: "404 on page refresh"

**Nguyên nhân:** React Router không config đúng

**Giải pháp:** Vercel cần file `vercel.json` để handle SPA routing (tôi sẽ tạo cho bạn).

---

## 📊 Performance và Analytics

### Vercel Analytics (Optional)

1. Vào Project → **Analytics**
2. Enable **Vercel Analytics**
3. Theo dõi:
   - Page views
   - Performance metrics
   - User behavior

### Web Vitals

Vercel tự động track:
- **LCP** (Largest Contentful Paint)
- **FID** (First Input Delay)  
- **CLS** (Cumulative Layout Shift)

---

## 🔐 Bảo Mật

### ✅ Checklist:

- [ ] Environment variables không commit lên Git
- [ ] OAuth callback URLs đã update
- [ ] HTTPS enabled (Vercel tự động)
- [ ] CORS config đúng (chỉ allow specific domains)
- [ ] API keys không expose trong client code

---

## 📚 Next Steps

1. ✅ Frontend đã deploy lên Vercel
2. ✅ Backend đã deploy lên Railway
3. ➡️ Test toàn bộ features end-to-end
4. ➡️ Setup monitoring và alerts
5. ➡️ Document deployment process cho team

---

## 📞 Hỗ Trợ

- Vercel Docs: https://vercel.com/docs
- Vercel Support: https://vercel.com/support
- Vercel Discord: https://vercel.com/discord

---

**Made with ❤️ by BugHunter Team**
