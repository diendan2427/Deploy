# 🚀 Quick Deployment Reference Card

> Cheat sheet nhanh cho deployment BugHunter

---

## ⚡ TL;DR - Deploy Trong 30 Phút

```bash
# 1. Push code
git add . && git commit -m "deploy" && git push

# 2. Railway: Deploy backend
# → railway.app → New Project → GitHub → Deploy
# → Add env vars → Generate domain

# 3. RapidAPI: Setup Judge0  
# → rapidapi.com/judge0-ce → Subscribe FREE
# → Copy API key → Add to Railway vars

# 4. Vercel: Deploy frontend
# → vercel.com → New Project → GitHub → Deploy
# → Add VITE_API_URL → Deploy

# 5. Connect
# → Update CLIENT_URL in Railway
# → Update OAuth callbacks

# 6. Test
# → Open Vercel URL → Test all features ✅
```

---

## 📋 Deployment URLs

| Service | URL | Admin Access |
|---------|-----|--------------|
| **Frontend** | `https://your-app.vercel.app` | `/admin` |
| **Backend** | `https://your-backend.up.railway.app` | `/api/debug/health` |
| **Database** | MongoDB Atlas (không public) | Atlas dashboard |
| **Judge0** | RapidAPI hoặc Railway | N/A |

---

## 🔑 Environment Variables Quick Copy

### Railway Backend (server)

```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://your-username:your-password@cluster0.xxxxx.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0
JWT_SECRET=change-this-to-strong-secret
JWT_EXPIRE=7d
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-secret
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-secret
CLIENT_URL=https://your-app.vercel.app
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
JUDGE0_API_KEY=your-rapidapi-key
GEMINI_API_KEY=your-gemini-key
ADMIN_EMAIL=admin@bughunter.com
```

### Vercel Frontend (client)

```env
VITE_API_URL=https://your-backend.up.railway.app
NODE_ENV=production
```

---

## 🎯 Step-by-Step Checklist

### Phase 1: Pre-Deploy (5 phút)
- [ ] Code đã test local
- [ ] Git đã push lên GitHub
- [ ] MongoDB Atlas đã có data

### Phase 2: Backend (10 phút)
- [ ] Railway account created
- [ ] Project deployed từ GitHub
- [ ] Environment variables added
- [ ] Domain generated
- [ ] Health check OK: `/api/debug/health`

### Phase 3: Judge0 (5 phút)
- [ ] RapidAPI account created
- [ ] Subscribed Judge0 CE FREE
- [ ] API key added to Railway
- [ ] Test Judge0: `/api/debug/test/judge0`

### Phase 4: Frontend (5 phút)
- [ ] Vercel account created
- [ ] Project deployed từ GitHub
- [ ] VITE_API_URL added
- [ ] Site loads OK

### Phase 5: Connect (3 phút)
- [ ] CLIENT_URL updated in Railway
- [ ] CORS checked
- [ ] OAuth callbacks updated

### Phase 6: Test (2 phút)
- [ ] Login/Register works
- [ ] Submit code works (Judge0)
- [ ] PvP works (WebSocket)
- [ ] OAuth works

---

## 🔗 OAuth Callback URLs

Thêm vào mỗi OAuth provider:

### Google
- Origins: `https://your-backend.up.railway.app`, `https://your-app.vercel.app`
- Callback: `https://your-backend.up.railway.app/api/auth/google/callback`

### GitHub
- Homepage: `https://your-app.vercel.app`
- Callback: `https://your-backend.up.railway.app/api/auth/github/callback`

### Facebook
- App Domain: `your-app.vercel.app`
- OAuth Redirect: `https://your-backend.up.railway.app/api/auth/facebook/callback`

---

## 🐛 Common Issues & Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| **CORS Error** | Check `CLIENT_URL` in Railway vars |
| **OAuth Fails** | Verify callback URLs updated |
| **Judge0 Timeout** | Check RapidAPI key và quota |
| **404 on Refresh** | Ensure `vercel.json` exists |
| **WebSocket Fails** | Add `transports: ['websocket', 'polling']` |
| **Build Error** | Check logs, test `npm run build` local |

---

## 📊 Health Check Commands

```bash
# Backend health
curl https://your-backend.up.railway.app/api/debug/health

# Judge0 test
curl https://your-backend.up.railway.app/api/debug/test/judge0

# Challenges endpoint
curl https://your-backend.up.railway.app/api/challenges

# Frontend (browser)
# Open: https://your-app.vercel.app
```

---

## 💡 Pro Tips

1. **Auto-Deploy:** Push to `main` → Auto deploy cả Railway và Vercel
2. **Preview:** Create PR → Vercel tạo preview URL tự động
3. **Rollback:** Railway/Vercel có rollback 1-click nếu lỗi
4. **Logs:** Railway/Vercel dashboard có real-time logs
5. **Monitor:** Setup alerts trong Railway/Vercel settings

---

## 🆘 Emergency Rollback

```bash
# Railway: Dashboard → Deployments → Click previous deployment → Rollback
# Vercel: Dashboard → Deployments → Previous → Promote to Production
```

---

## 📱 Mobile Access

Test mobile bằng:
- Chrome DevTools → Device toolbar
- Hoặc scan QR code từ Vercel deployment

---

## 🔐 Security Checklist

- [ ] `JWT_SECRET` đã đổi (không dùng default)
- [ ] `.env` files không commit
- [ ] OAuth secrets an toàn
- [ ] MongoDB IP whitelist cụ thể (production)
- [ ] HTTPS enabled (auto)
- [ ] CORS restricted to specific domains

---

## 📞 Quick Links

- **Railway Dashboard:** https://railway.app/dashboard
- **Vercel Dashboard:** https://vercel.com/dashboard
- **MongoDB Atlas:** https://cloud.mongodb.com/
- **RapidAPI:** https://rapidapi.com/hub
- **GitHub Repo:** [Your repo URL]

---

## ✅ Final Verification

```bash
# Run all checks
curl https://your-backend.up.railway.app/api/debug/health && \
curl https://your-backend.up.railway.app/api/challenges && \
echo "✅ Backend OK"

# Open browser
open https://your-app.vercel.app
# Test: Login → Submit code → Check PvP
```

---

## 🎉 Success!

**Your app is LIVE at:**
- 🌐 Frontend: `https://your-app.vercel.app`
- ⚙️ Backend: `https://your-backend.up.railway.app`
- 👤 Admin: Email: `admin@bughunter.com` / Pass: `admin123`

---

**Made with ❤️ by BugHunter Team**
