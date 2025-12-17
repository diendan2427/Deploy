# 🔐 Hướng Dẫn Cấu Hình OAuth Callbacks cho Railway

> Cấu hình Google, GitHub, Facebook OAuth cho backend Railway

**Backend Domain:** `https://deploy-production-a16c.up.railway.app`

---

## 📋 Tổng Quan

Sau khi deploy backend lên Railway, bạn cần cập nhật OAuth callback URLs trong các provider (Google, GitHub, Facebook) để cho phép authentication từ domain production.

---

## 🔵 1. Google OAuth Configuration

### Bước 1.1: Truy cập Google Cloud Console

1. Đăng nhập: https://console.cloud.google.com/
2. Chọn project của bạn (hoặc tạo mới nếu chưa có)
3. Vào **APIs & Services** → **Credentials**

### Bước 1.2: Tìm OAuth 2.0 Client ID

1. Trong danh sách **OAuth 2.0 Client IDs**, click vào client ID đang dùng
2. Hoặc tạo mới: Click **"+ CREATE CREDENTIALS"** → **"OAuth client ID"** → **"Web application"**

### Bước 1.3: Cấu hình URLs

#### A. Authorized JavaScript origins

Thêm các origins sau:

```
https://deploy-production-a16c.up.railway.app
http://localhost:5173
http://localhost:3000
```

#### B. Authorized redirect URIs

Thêm callback URL:

```
https://deploy-production-a16c.up.railway.app/api/auth/google/callback
http://localhost:5000/api/auth/google/callback
```

### Bước 1.4: Lưu thay đổi

1. Click **"SAVE"**
2. Copy **Client ID** và **Client Secret** (nếu chưa có)
3. Đảm bảo đã thêm vào Railway Environment Variables:
   ```env
   GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=your-google-client-secret
   ```

### ✅ Test Google OAuth

Truy cập:
```
https://deploy-production-a16c.up.railway.app/api/auth/google
```

Nếu redirect đến Google login → thành công!

---

## 🐙 2. GitHub OAuth Configuration

### Bước 2.1: Truy cập GitHub Developer Settings

1. Đăng nhập GitHub
2. Vào: https://github.com/settings/developers
3. Click **"OAuth Apps"**

### Bước 2.2: Chọn hoặc tạo OAuth App

- **Nếu đã có app**: Click vào app name
- **Nếu chưa có**: Click **"New OAuth App"**

### Bước 2.3: Cấu hình Application

Điền thông tin:

| Field | Value |
|-------|-------|
| **Application name** | BugHunter Production |
| **Homepage URL** | `https://deploy-production-a16c.up.railway.app` |
| **Application description** | BugHunter - Code Learning Platform |
| **Authorization callback URL** | `https://deploy-production-a16c.up.railway.app/api/auth/github/callback` |

### Bước 2.4: Lưu và lấy Credentials

1. Click **"Update application"** (hoặc **"Register application"** nếu mới tạo)
2. Copy **Client ID**
3. Click **"Generate a new client secret"** → Copy **Client Secret**
4. Thêm vào Railway Environment Variables:
   ```env
   GITHUB_CLIENT_ID=your-github-client-id
   GITHUB_CLIENT_SECRET=your-github-client-secret
   ```

### ✅ Test GitHub OAuth

Truy cập:
```
https://deploy-production-a16c.up.railway.app/api/auth/github
```

Nếu redirect đến GitHub authorize → thành công!

---

## 📘 3. Facebook OAuth Configuration

### Bước 3.1: Truy cập Facebook Developers

1. Đăng nhập: https://developers.facebook.com/
2. Vào **My Apps** → Chọn app của bạn (hoặc tạo mới)

### Bước 3.2: Cấu hình Facebook Login

1. Trong dashboard, vào **Products** → **Facebook Login** → **Settings**
2. Hoặc thêm Facebook Login: Click **"Add a Product"** → Chọn **"Facebook Login"**

### Bước 3.3: Cấu hình Valid OAuth Redirect URIs

Trong **Facebook Login Settings**, tìm **"Valid OAuth Redirect URIs"** và thêm:

```
https://deploy-production-a16c.up.railway.app/api/auth/facebook/callback
http://localhost:5000/api/auth/facebook/callback
```

### Bước 3.4: Cấu hình App Domains

1. Vào **Settings** → **Basic**
2. Tìm **"App Domains"**, thêm:
   ```
   deploy-production-a16c.up.railway.app
   localhost
   ```

### Bước 3.5: Cấu hình Site URL

Trong **Settings** → **Basic**, scroll xuống **"Website"**:

- **Site URL**: `https://deploy-production-a16c.up.railway.app`

### Bước 3.6: Lấy App Credentials

1. Trong **Settings** → **Basic**:
   - **App ID** → Copy
   - **App Secret** → Click **"Show"** → Copy
2. Thêm vào Railway Environment Variables:
   ```env
   FACEBOOK_APP_ID=your-facebook-app-id
   FACEBOOK_APP_SECRET=your-facebook-app-secret
   ```

### Bước 3.7: Chuyển App sang Live Mode (quan trọng!)

⚠️ **Lưu ý:** Facebook app mặc định ở chế độ **Development** - chỉ admin/testers mới dùng được.

Để cho phép tất cả người dùng:

1. Vào **Settings** → **Basic**
2. Scroll lên trên, chuyển toggle từ **"Development"** sang **"Live"**
3. Facebook có thể yêu cầu bạn điền thêm thông tin (Privacy Policy URL, Terms of Service URL)

### ✅ Test Facebook OAuth

Truy cập:
```
https://deploy-production-a16c.up.railway.app/api/auth/facebook
```

Nếu redirect đến Facebook login → thành công!

---

## 🔧 4. Cập Nhật Railway Environment Variables

Đảm bảo Railway có đầy đủ biến:

### Vào Railway Dashboard:

1. Chọn service Backend
2. Tab **"Variables"**
3. Thêm/kiểm tra:

```env
# OAuth - Google
GOOGLE_CLIENT_ID=123456789-abc...xyz.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-abc...xyz

# OAuth - GitHub
GITHUB_CLIENT_ID=Iv1.abc...xyz
GITHUB_CLIENT_SECRET=abc...xyz

# OAuth - Facebook
FACEBOOK_APP_ID=123456789012345
FACEBOOK_APP_SECRET=abc...xyz

# Client URL (frontend - sẽ update sau)
CLIENT_URL=http://localhost:3000
```

4. Click **"Save"** → Railway tự động restart

---

## 🧪 5. Testing OAuth Flow

### Test từng provider:

```bash
# Google OAuth
curl -I https://deploy-production-a16c.up.railway.app/api/auth/google

# GitHub OAuth
curl -I https://deploy-production-a16c.up.railway.app/api/auth/github

# Facebook OAuth
curl -I https://deploy-production-a16c.up.railway.app/api/auth/facebook
```

**Kết quả mong đợi:** Status `302 Found` (redirect đến provider)

### Test với Browser:

1. Mở browser, truy cập:
   ```
   https://deploy-production-a16c.up.railway.app/api/auth/google
   ```

2. Bạn sẽ được redirect đến Google login
3. Sau khi login, Google sẽ redirect về:
   ```
   https://deploy-production-a16c.up.railway.app/api/auth/google/callback?code=...
   ```

4. Backend xử lý và redirect về `CLIENT_URL` với token

---

## 🐛 Troubleshooting

### Lỗi: "redirect_uri_mismatch" (Google)

**Nguyên nhân:** Callback URL không khớp với Google Console

**Giải pháp:**
1. Kiểm tra lại **Authorized redirect URIs** trong Google Console
2. Đảm bảo URL chính xác: `https://deploy-production-a16c.up.railway.app/api/auth/google/callback`
3. Không có dấu `/` cuối URL
4. Đúng protocol (`https://`)

### Lỗi: "The redirect_uri MUST match the registered callback URL" (GitHub)

**Nguyên nhân:** GitHub callback URL không khớp

**Giải pháp:**
1. Vào GitHub OAuth App settings
2. Kiểm tra **Authorization callback URL**
3. URL phải chính xác: `https://deploy-production-a16c.up.railway.app/api/auth/github/callback`

### Lỗi: "Can't Load URL" (Facebook)

**Nguyên nhân:** Facebook app chưa ở Live mode hoặc domain chưa whitelist

**Giải pháp:**
1. Chuyển app sang **Live mode**
2. Kiểm tra **App Domains** có `deploy-production-a16c.up.railway.app`
3. Kiểm tra **Valid OAuth Redirect URIs** đúng
4. Xóa cache browser và thử lại

### Lỗi: "OAuth credentials not configured"

**Nguyên nhân:** Railway chưa có Environment Variables

**Giải pháp:**
1. Vào Railway Variables
2. Thêm `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, v.v.
3. Railway tự restart sau khi save

### Lỗi: CORS khi callback

**Nguyên nhân:** Frontend domain chưa được cho phép

**Giải pháp:**
- Đã fix! Code đã update CORS cho phép Railway domain
- Commit và push code mới

---

## ✅ Checklist Hoàn Thành

- [ ] Google OAuth configured
  - [ ] Authorized JavaScript origins updated
  - [ ] Authorized redirect URIs updated
  - [ ] Credentials added to Railway
- [ ] GitHub OAuth configured
  - [ ] Authorization callback URL updated
  - [ ] Credentials added to Railway
- [ ] Facebook OAuth configured
  - [ ] Valid OAuth Redirect URIs updated
  - [ ] App Domains updated
  - [ ] App in Live mode
  - [ ] Credentials added to Railway
- [ ] Railway Environment Variables updated
- [ ] CORS updated in code (đã done!)
- [ ] Code pushed to GitHub
- [ ] Railway deployed successfully
- [ ] Tested all OAuth flows

---

## 📚 Next Steps

Sau khi config OAuth:

1. ✅ Test OAuth flow từng provider
2. ➡️ Deploy Frontend lên Vercel
3. ➡️ Update `CLIENT_URL` trong Railway Variables
4. ➡️ Update OAuth redirect cho Frontend domain

---

**Made with ❤️ by BugHunter Team**
