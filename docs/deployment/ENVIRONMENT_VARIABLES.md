# 🔐 Environment Variables Reference

> Template và hướng dẫn cho tất cả environment variables trong project

---

## ⚠️ QUAN TRỌNG

**KHÔNG BAO GIỜ commit file này với giá trị thật vào Git!**

File này chỉ để reference. Sử dụng:
- `.env.example` để commit template
- `.env` để chứa giá trị thật (gitignore)

---

## 🚂 Railway Backend Environment Variables

### Required (Bắt buộc)

```env
# Server Configuration
NODE_ENV=production
PORT=5000

# MongoDB Atlas
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/database?retryWrites=true&w=majority

# JWT Authentication
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-long
JWT_EXPIRE=7d

# Client URL (Vercel frontend)
CLIENT_URL=https://your-app.vercel.app
```

### Optional - OAuth Providers

```env
# Google OAuth
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-secret

# GitHub OAuth
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-secret

# Facebook OAuth  
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-secret
```

### Optional - Judge0 (Code Execution)

```env
# Option A: RapidAPI Judge0 (Recommended)
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=your-rapidapi-key-xxxxxx

# Option B: Self-hosted Judge0
# JUDGE0_API_URL=http://localhost:2358
# JUDGE0_API_KEY=
```

### Optional - AI Features

```env
# Google Gemini Pro API
GEMINI_API_KEY=your-gemini-api-key
```

### Optional - Notifications

```env
# Twilio SMS (for notifications)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_twilio_token
TWILIO_PHONE_NUMBER=+1234567890

# Nodemailer (Email notifications)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
```

### Admin Configuration

```env
# Admin account email
ADMIN_EMAIL=admin@bughunter.com
```

---

## ▲ Vercel Frontend Environment Variables

### Required (Bắt buộc)

```env
# Backend API URL (Railway)
VITE_API_URL=https://your-backend.up.railway.app

# Environment
NODE_ENV=production
```

### Optional

```env
# Google OAuth Client ID (if needed client-side)
VITE_GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com

# Analytics (if using)
VITE_ANALYTICS_ID=your-analytics-id
```

---

## 🗂️ MongoDB Atlas Configuration

**Connection String Format:**
```
mongodb+srv://<username>:<password>@<cluster>.mongodb.net/<database>?retryWrites=true&w=majority&appName=<appname>
```

**Example:**
```
mongodb+srv://bughunter_admin:StrongPassword123@cluster0.kau5lqg.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0
```

**Components:**
- `username`: MongoDB Atlas user (e.g., `bughunter_admin`)
- `password`: User password (URL-encoded nếu có ký tự đặc biệt)
- `cluster`: Cluster hostname (e.g., `cluster0.kau5lqg.mongodb.net`)
- `database`: Database name (e.g., `BugHunter`)

---

## 🔑 How to Get OAuth Credentials

### Google OAuth

1. Go to: https://console.cloud.google.com/
2. Create Project → "APIs & Services" → "Credentials"
3. Create "OAuth 2.0 Client ID"
4. Application type: **Web application**
5. Authorized JavaScript origins:
   - `http://localhost:5000` (dev)
   - `https://your-backend.up.railway.app` (prod)
6. Authorized redirect URIs:
   - `http://localhost:5000/api/auth/google/callback` (dev)
   - `https://your-backend.up.railway.app/api/auth/google/callback` (prod)
7. Copy **Client ID** and **Client Secret**

### GitHub OAuth

1. Go to: https://github.com/settings/developers
2. "OAuth Apps" → "New OAuth App"
3. Application name: `BugHunter`
4. Homepage URL: `https://your-app.vercel.app`
5. Authorization callback URL: 
   - `https://your-backend.up.railway.app/api/auth/github/callback`
6. Copy **Client ID** and **Client Secret**

### Facebook OAuth

1. Go to: https://developers.facebook.com/
2. "My Apps" → "Create App"
3. Type: **Consumer**
4. Add "Facebook Login" product
5. Settings:
   - Valid OAuth Redirect URIs: 
     - `https://your-backend.up.railway.app/api/auth/facebook/callback`
6. Settings → Basic:
   - Copy **App ID** and **App Secret**

---

## 🎮 Judge0 Setup

### Option A: RapidAPI (Recommended)

1. Go to: https://rapidapi.com/judge0-official/api/judge0-ce
2. Sign up / Login
3. Subscribe to **FREE plan** (50 requests/day)
4. Go to "Endpoints" → Copy **X-RapidAPI-Key**
5. Use:
   ```env
   JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
   JUDGE0_API_KEY=<your-rapidapi-key>
   ```

### Option B: Self-hosted (Advanced)

Run Judge0 locally with Docker:
```bash
docker-compose up -d
```

Use:
```env
JUDGE0_API_URL=http://localhost:2358
JUDGE0_API_KEY=
```

---

## 🤖 Google Gemini AI

1. Go to: https://makersuite.google.com/app/apikey
2. Create API key
3. Copy key:
   ```env
   GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxxxxxxx
   ```

**Note:** Gemini có FREE tier với limits. Check: https://ai.google.dev/pricing

---

## 🔐 JWT Secret Generation

**Never use default/weak secrets in production!**

Generate strong JWT secret:

```bash
# Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# OpenSSL
openssl rand -hex 32

# Online (use with caution)
# https://www.grc.com/passwords.htm
```

Example output:
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6
```

---

## 📋 Environment Variables Templates

### Development (.env.development)

```env
NODE_ENV=development
PORT=5000
MONGODB_URI=mongodb://localhost:27017/bughunter
JWT_SECRET=dev-secret-key-change-in-production
JWT_EXPIRE=7d
CLIENT_URL=http://localhost:3000
JUDGE0_API_URL=http://localhost:2358
JUDGE0_API_KEY=
ADMIN_EMAIL=admin@bughunter.com
```

### Production (.env.production) - Railway

```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/BugHunter?retryWrites=true&w=majority
JWT_SECRET=<strong-generated-secret>
JWT_EXPIRE=7d
CLIENT_URL=https://your-app.vercel.app
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=<your-rapidapi-key>
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-secret>
GITHUB_CLIENT_ID=<your-github-client-id>
GITHUB_CLIENT_SECRET=<your-github-secret>
FACEBOOK_APP_ID=<your-facebook-app-id>
FACEBOOK_APP_SECRET=<your-facebook-secret>
GEMINI_API_KEY=<your-gemini-key>
ADMIN_EMAIL=admin@bughunter.com
```

---

## ✅ Validation Checklist

Before deploying, verify:

### Backend (Railway)
- [ ] `MONGODB_URI` connects successfully
- [ ] `JWT_SECRET` is strong (min 32 chars)
- [ ] `CLIENT_URL` matches Vercel URL
- [ ] OAuth credentials are valid
- [ ] Judge0 API key works (if using RapidAPI)

### Frontend (Vercel)
- [ ] `VITE_API_URL` matches Railway backend URL
- [ ] All VITE_ prefixed vars are set

### OAuth Providers
- [ ] Callback URLs updated for production
- [ ] JavaScript origins whitelisted
- [ ] App domains configured

---

## 🔄 How to Update Environment Variables

### Railway

1. Dashboard → Service → **Variables**
2. Add/Edit variable
3. Click **Save** → Auto-restart

### Vercel

1. Dashboard → Project → **Settings** → **Environment Variables**
2. Add/Edit variable
3. Redeploy project to apply changes

---

## 🐛 Common Issues

### Issue: "Invalid MongoDB URI"

**Check:**
- Username và password đúng
- Special characters trong password đã URL-encode
- Database name đúng
- IP address đã whitelist (0.0.0.0/0 for all)

### Issue: "OAuth authentication failed"

**Check:**
- Callback URLs chính xác
- Client ID/Secret không có spaces thừa
- Authorized origins đã thêm

### Issue: "Judge0 timeout"

**Check:**
- RapidAPI key valid
- Quota chưa hết (FREE: 50 calls/day)
- URL đúng: `https://judge0-ce.p.rapidapi.com`

---

## 📞 Support

For help with:
- **MongoDB Atlas**: https://cloud.mongodb.com/support
- **Google OAuth**: https://console.cloud.google.com/support
- **RapidAPI**: https://rapidapi.com/support

---

**Made with ❤️ by BugHunter Team**
