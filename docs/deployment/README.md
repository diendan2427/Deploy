# 📚 Deployment Documentation

> Complete deployment guides for BugHunter Full Stack Application

---

## 📖 Table of Contents

| Document | Description | Time | Difficulty |
|----------|-------------|------|------------|
| [DEPLOYMENT_COMPLETE.md](./DEPLOYMENT_COMPLETE.md) | **Complete deployment guide** - Step by step từ A-Z | ~90 min | ⭐⭐⭐ |
| [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) | **Quick reference card** - Deploy nhanh trong 30 phút | ~30 min | ⭐⭐ |
| [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md) | Backend deployment chi tiết (Railway + Judge0) | ~35 min | ⭐⭐⭐ |
| [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md) | Frontend deployment chi tiết (Vercel) | ~15 min | ⭐⭐ |
| [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) | Environment variables reference và setup | ~20 min | ⭐⭐ |

---

## 🚀 Quick Start

### Đã biết cách deploy? Dùng Quick Reference:
👉 **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - 30 phút deploy xong!

### Lần đầu deploy? Đọc Complete Guide:
👉 **[DEPLOYMENT_COMPLETE.md](./DEPLOYMENT_COMPLETE.md)** - Hướng dẫn chi tiết từng bước

---

## 🎯 Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      PRODUCTION                             │
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

## 📋 Prerequisites

Before deployment, ensure you have:

- [ ] GitHub account
- [ ] Code pushed to GitHub repository
- [ ] MongoDB Atlas account với database setup
- [ ] Railway account (sign up with GitHub)
- [ ] Vercel account (sign up with GitHub)
- [ ] RapidAPI account (for Judge0 - optional)
- [ ] OAuth credentials (Google, GitHub, Facebook - optional)

---

## 🛠️ Technology Stack

| Layer | Technology | Platform |
|-------|-----------|----------|
| **Frontend** | React 18 + TypeScript + Vite | Vercel |
| **Backend** | Node.js + Express + TypeScript | Railway |
| **Database** | MongoDB 6 | MongoDB Atlas |
| **Code Execution** | Judge0 CE | RapidAPI or Railway |
| **Real-time** | Socket.IO | Railway (WebSocket) |
| **Authentication** | JWT + OAuth | Railway Backend |
| **AI** | Google Gemini Pro | Google AI API |

---

## 💰 Cost Estimate

### FREE Tier (Recommended cho development và small projects)

| Service | FREE Tier | Limits |
|---------|-----------|--------|
| **Railway** | $5 credit/month | ~500 hours execution time |
| **Vercel** | Hobby plan | 100 GB bandwidth, unlimited projects |
| **MongoDB Atlas** | M0 FREE tier | 512 MB storage, 100 connections |
| **Judge0 RapidAPI** | FREE plan | 50 submissions/day |

**Total cost:** **$0/month** ✨

### Paid Tier (Khi traffic tăng)

| Service | Plan | Cost | Limits |
|---------|------|------|--------|
| **Railway** | Hobby | $5/month | $5 credit (~500 hours) |
| **Vercel** | Pro | $20/month | 1 TB bandwidth, priority support |
| **MongoDB Atlas** | M2 | $9/month | 2 GB storage, shared CPU |
| **Judge0 RapidAPI** | Basic | $10/month | 1000 submissions/day |

**Estimated cost:** **$44/month** cho production với moderate traffic.

---

## ⏱️ Deployment Timeline

### First-time Deployment

| Phase | Steps | Time |
|-------|-------|------|
| **Preparation** | Setup accounts, push code | 15 min |
| **Backend Deploy** | Railway setup, env vars | 20 min |
| **Judge0 Setup** | RapidAPI or self-hosted | 15 min |
| **Frontend Deploy** | Vercel setup, build | 10 min |
| **OAuth Config** | Update callbacks | 10 min |
| **Testing** | End-to-end testing | 20 min |
| **TOTAL** | | **~90 minutes** |

### Subsequent Deployments (Auto)

| Action | Time |
|--------|------|
| Push code to GitHub | Instant |
| Auto-deploy Railway | ~2-3 min |
| Auto-deploy Vercel | ~1-2 min |
| **TOTAL** | **~5 minutes** ⚡ |

---

## 📁 Deployment Files

### Config Files Created

```
Deploy/
├── railway.json              # Railway deployment config
├── server/
│   ├── Dockerfile           # Docker config for Railway
│   ├── .dockerignore        # Docker ignore rules
│   └── .env.example         # Environment template
├── client/
│   ├── vercel.json          # Vercel SPA routing
│   └── .env.example         # Frontend env template
└── docs/
    └── deployment/
        ├── README.md                    # This file
        ├── DEPLOYMENT_COMPLETE.md       # Complete guide
        ├── QUICK_REFERENCE.md           # Quick start
        ├── RAILWAY_DEPLOYMENT.md        # Backend details
        ├── VERCEL_DEPLOYMENT.md         # Frontend details
        └── ENVIRONMENT_VARIABLES.md     # Env vars reference
```

---

## 🎓 Learning Path

### Beginner (Chưa từng deploy)

1. **Start:** [DEPLOYMENT_COMPLETE.md](./DEPLOYMENT_COMPLETE.md)
2. **Understand:** [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md)
3. **Reference:** [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)
4. **Reference:** [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md)

### Intermediate (Đã deploy 1-2 lần)

1. **Quick Start:** [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
2. **Troubleshoot:** [DEPLOYMENT_COMPLETE.md](./DEPLOYMENT_COMPLETE.md#troubleshooting)

### Advanced (Deployment expert)

1. Use **QUICK_REFERENCE.md** làm cheat sheet
2. Customize configs trong `railway.json` và `vercel.json`
3. Setup CI/CD pipelines với GitHub Actions

---

## ✅ Deployment Checklist

### Pre-Deployment

- [ ] Code tested thoroughly on local
- [ ] All dependencies updated
- [ ] Environment variables documented
- [ ] Database migrated to MongoDB Atlas
- [ ] Git repository pushed to GitHub
- [ ] OAuth apps created và configured
- [ ] Deployment files added (Dockerfile, railway.json, vercel.json)

### Deployment

- [ ] Railway backend deployed
- [ ] Environment variables set on Railway
- [ ] Railway domain generated
- [ ] Judge0 setup (RapidAPI or Docker)
- [ ] Vercel frontend deployed
- [ ] Frontend env vars set (VITE_API_URL)
- [ ] Vercel domain generated

### Post-Deployment

- [ ] CLIENT_URL updated in Railway
- [ ] CORS configured properly
- [ ] OAuth callback URLs updated
- [ ] Health checks passing
- [ ] All features tested end-to-end
- [ ] Monitoring setup (optional)
- [ ] Team notified

---

## 🐛 Common Issues

### 1. CORS Errors

**Symptom:** "Access to XMLHttpRequest blocked by CORS policy"

**Solution:** Check [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md#troubleshooting)

### 2. OAuth Not Working

**Symptom:** Redirect loop hoặc authentication fails

**Solution:** Check [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md#troubleshooting)

### 3. Judge0 Timeout

**Symptom:** Code submission timeout

**Solution:** Verify API key và quota in [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md#phần-3-setup-judge0)

### 4. Build Failures

**Symptom:** Deploy fails at build step

**Solution:** Test `npm run build` locally, check logs

---

## 📊 Monitoring

### Railway

- Dashboard → Service → **Metrics**
- Monitor: CPU, Memory, Network
- View logs in real-time

### Vercel

- Dashboard → Project → **Analytics**
- Enable Vercel Analytics
- Track: Page views, Performance, Errors

### MongoDB Atlas

- Dashboard → Cluster → **Metrics**
- Monitor: Connections, Operations, Storage

---

## 🔐 Security Best Practices

1. **Never commit secrets** - Use `.gitignore` for `.env` files
2. **Strong JWT secret** - Generate với `crypto.randomBytes(32)`
3. **Whitelist IPs** - MongoDB Atlas network access
4. **Update OAuth** - Production callback URLs
5. **Enable HTTPS** - Railway và Vercel auto-enable
6. **CORS restrictions** - Only allow specific domains
7. **Rate limiting** - Code has built-in rate limits
8. **Helmet middleware** - Already enabled in code

---

## 🔄 Continuous Deployment

### Auto-Deploy Flow

```
Developer
    ↓ (git push)
GitHub
    ↓ (webhook)
  ┌──────┴──────┐
  ↓             ↓
Railway       Vercel
(Backend)    (Frontend)
  ↓             ↓
Production Live!
```

### Branch Strategy

- `main` → Production (auto-deploy)
- `develop` → Staging/Preview (Vercel preview)
- `feature/*` → PR previews (Vercel)

---

## 🆘 Support

### Official Documentation

- **Railway:** https://docs.railway.app/
- **Vercel:** https://vercel.com/docs
- **MongoDB Atlas:** https://docs.atlas.mongodb.com/
- **Judge0:** https://ce.judge0.com/

### Community

- **Railway Discord:** https://discord.gg/railway
- **Vercel Discord:** https://vercel.com/discord
- **Stack Overflow:** Tag với `railway`, `vercel`, `mongodb`

### Project-Specific

- **GitHub Issues:** [Your repo]/issues
- **Team Chat:** [Your Slack/Discord]
- **Documentation:** `docs/` folder in repo

---

## 🎉 Success Stories

> _"Deployed in 45 minutes following the complete guide!"_ - Team Member A

> _"Quick Reference card giúp tôi deploy trong 30 phút cho lần thứ 2!"_ - Team Member B

---

## 📞 Contact

**Questions about deployment?**

- Open an issue on GitHub
- Contact team lead
- Refer to specific guide based on issue

---

## 🎯 Next Steps After Deployment

1. **Monitor:** Setup alerts cho downtime
2. **Optimize:** Check performance metrics
3. **Scale:** Upgrade plans khi cần
4. **Maintain:** Regular updates và security patches
5. **Document:** Update docs với lessons learned

---

## 📚 Additional Resources

- [MongoDB Atlas Best Practices](https://docs.atlas.mongodb.com/best-practices/)
- [Railway Best Practices](https://docs.railway.app/guides/best-practices)
- [Vercel Edge Network](https://vercel.com/docs/edge-network/overview)
- [Judge0 Documentation](https://ce.judge0.com/)

---

**Made with ❤️ by BugHunter Team**

**Last Updated:** December 2025

**Version:** 1.0.0
