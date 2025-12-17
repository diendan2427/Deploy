# 🔧 Hướng Dẫn Thêm Environment Variables Mới

> Thêm Google CSE, YouTube API và External Resource configs lên deployment

---

## 📋 Các Biến Môi Trường Cần Thêm

```env
# Google Custom Search Engine
GOOGLE_CSE_ID=your-google-cse-id

# Google API (dùng cho CSE và YouTube)
GOOGLE_API_KEY=your-google-api-key

# YouTube API
YOUTUBE_API_KEY=your-youtube-api-key

# External Resource Cache Settings
EXTERNAL_RESOURCE_CACHE_TTL=900
EXTERNAL_RESOURCE_LIMIT=8
```

---

## 🚂 Bước 1: Thêm vào Railway (Backend)

### Cách 1: Sử dụng Railway Dashboard (Khuyến nghị)

1. **Truy cập Railway Dashboard:**
   - Vào: https://railway.app/
   - Login với GitHub
   - Chọn project **Deploy** (hoặc tên project của bạn)

2. **Mở Service Settings:**
   - Click vào **Backend Service** (service đang chạy code server)
   - Chọn tab **Variables**

3. **Thêm từng biến mới:**
   
   Click **New Variable** và thêm:

   ```
   Variable Name: GOOGLE_CSE_ID
   Value: your-google-cse-id
   ```

   ```
   Variable Name: GOOGLE_API_KEY
   Value: your-google-api-key
   ```

   ```
   Variable Name: YOUTUBE_API_KEY
   Value: your-youtube-api-key
   ```

   ```
   Variable Name: EXTERNAL_RESOURCE_CACHE_TTL
   Value: 900
   ```

   ```
   Variable Name: EXTERNAL_RESOURCE_LIMIT
   Value: 8
   ```

4. **Lưu và Deploy:**
   - Railway tự động save
   - Service sẽ **tự động restart** sau vài giây
   - Đợi deployment mới hoàn tất (theo dõi ở tab **Deployments**)

---

### Cách 2: Sử dụng Railway CLI (Advanced)

```bash
# Install Railway CLI (nếu chưa có)
npm install -g @railway/cli

# Login
railway login

# Link to project
railway link

# Add variables
railway variables --set GOOGLE_CSE_ID=your-google-cse-id
railway variables --set GOOGLE_API_KEY=your-google-api-key
railway variables --set YOUTUBE_API_KEY=your-youtube-api-key
railway variables --set EXTERNAL_RESOURCE_CACHE_TTL=900
railway variables --set EXTERNAL_RESOURCE_LIMIT=8

# Trigger redeploy
railway up
```

---

## ✅ Bước 2: Verify Variables Đã Thêm

### Kiểm tra trên Railway Dashboard:

1. Service → **Variables** tab
2. Scroll xuống, xem list variables
3. Đảm bảo 5 variables mới đã xuất hiện:
   - ✅ `GOOGLE_CSE_ID`
   - ✅ `GOOGLE_API_KEY`
   - ✅ `YOUTUBE_API_KEY`
   - ✅ `EXTERNAL_RESOURCE_CACHE_TTL`
   - ✅ `EXTERNAL_RESOURCE_LIMIT`

### Test API Endpoint:

Sau khi deployment hoàn tất, test endpoint:

```bash
curl https://your-backend.up.railway.app/api/debug/env

# Hoặc mở trong browser
```

Response sẽ show các env variables (không show giá trị sensitive):

```json
{
  "NODE_ENV": "production",
  "PORT": "5000",
  "GOOGLE_CSE_ID": "Set ✅",
  "GOOGLE_API_KEY": "Set ✅",
  "YOUTUBE_API_KEY": "Set ✅",
  "EXTERNAL_RESOURCE_CACHE_TTL": "900",
  "EXTERNAL_RESOURCE_LIMIT": "8"
}
```

---

## 🔍 Bước 3: Test Chức Năng Sử Dụng Variables

### Test Google Custom Search:

```bash
# Test search endpoint (thay your-backend URL)
curl -X POST https://your-backend.up.railway.app/api/resources/search \
  -H "Content-Type: application/json" \
  -d '{"query": "JavaScript tutorial", "limit": 5}'

# Expected response: Danh sách search results từ Google CSE
```

### Test YouTube API:

```bash
# Test YouTube search
curl -X GET "https://your-backend.up.railway.app/api/resources/youtube?query=python+tutorial&limit=3"

# Expected response: Danh sách YouTube videos
```

---

## 📝 Bước 4: Update Documentation

### Cập nhật file `deployment-env-reference.txt`:

Thêm vào section Backend:

```env
# ===== BACKEND (Railway) =====
# ... (existing variables) ...

# Google Custom Search & YouTube
GOOGLE_CSE_ID=your-google-cse-id
GOOGLE_API_KEY=your-google-api-key
YOUTUBE_API_KEY=your-youtube-api-key

# External Resource Settings
EXTERNAL_RESOURCE_CACHE_TTL=900
EXTERNAL_RESOURCE_LIMIT=8
```

### Update `.env.example`:

```bash
cd server
```

Thêm vào `server/.env.example`:

```env
# Google Custom Search Engine Configuration
GOOGLE_CSE_ID=your-google-cse-id
GOOGLE_API_KEY=your-google-api-key

# YouTube API Configuration
YOUTUBE_API_KEY=your-youtube-api-key

# External Resource Settings
EXTERNAL_RESOURCE_CACHE_TTL=900          # Cache TTL in seconds (default: 900 = 15 minutes)
EXTERNAL_RESOURCE_LIMIT=8                # Max external resources per request
```

---

## 🔐 Security Best Practices

### ⚠️ Không Commit API Keys

Đảm bảo các API keys **KHÔNG BAO GIỜ** commit lên GitHub:

```bash
# Check .gitignore đã có:
*.env
.env
.env.local
.env.production
deployment-env-reference.txt
```

### 🔒 Rotate Keys Định Kỳ

- Google API Key: Rotate mỗi 3-6 tháng
- Giới hạn API key chỉ cho domains cụ thể (Google Cloud Console)

### 📊 Monitor API Usage

1. **Google Cloud Console:**
   - https://console.cloud.google.com/
   - APIs & Services → Dashboard
   - Theo dõi quotas và usage

2. **Railway Logs:**
   - Railway Dashboard → Service → **Logs**
   - Monitor API calls và errors

---

## 🚨 Troubleshooting

### Lỗi: "Google API Key invalid"

**Giải pháp:**
1. Kiểm tra key đã copy đúng chưa (không có spaces)
2. Verify key active tại Google Cloud Console
3. Đảm bảo APIs đã enable:
   - Custom Search API
   - YouTube Data API v3

### Lỗi: "EXTERNAL_RESOURCE_CACHE_TTL is not a number"

**Giải pháp:**
- Railway variables đều là string
- Backend code cần parse: `parseInt(process.env.EXTERNAL_RESOURCE_CACHE_TTL)`

Check code:

```typescript
// server/src/config/environment.ts
export const ENV = {
  // ...
  EXTERNAL_RESOURCE_CACHE_TTL: parseInt(
    process.env.EXTERNAL_RESOURCE_CACHE_TTL || '900'
  ),
  EXTERNAL_RESOURCE_LIMIT: parseInt(
    process.env.EXTERNAL_RESOURCE_LIMIT || '8'
  ),
};
```

### Lỗi: Variables không apply sau khi thêm

**Giải pháp:**
1. Railway Dashboard → Service → **Deployments**
2. Check deployment status
3. Nếu không tự restart, click **Redeploy**
4. Xem logs để debug

---

## 📸 Screenshot Hướng Dẫn

### Thêm Variable trên Railway:

```
1. Railway Dashboard
   ↓
2. Chọn Backend Service
   ↓
3. Tab "Variables"
   ↓
4. Click "New Variable"
   ↓
5. Nhập Name và Value
   ↓
6. Service tự động restart
```

---

## ✅ Final Checklist

- [ ] Đã thêm 5 environment variables trên Railway
- [ ] Service đã restart thành công
- [ ] Test API endpoints (Google Search, YouTube)
- [ ] Variables hiển thị đúng trong logs
- [ ] Đã update `.env.example`
- [ ] Đã update `deployment-env-reference.txt`
- [ ] Đã commit changes (KHÔNG commit API keys!)
- [ ] Team members đã được thông báo

---

## 🎯 Next Steps

### Sau khi thêm variables:

1. **Test end-to-end:**
   - Login vào app production
   - Test tính năng sử dụng Google Search
   - Test YouTube search
   - Verify cache working

2. **Monitor usage:**
   - Check Google API quotas
   - Railway service logs
   - Response times

3. **Optimize nếu cần:**
   - Tăng/giảm `EXTERNAL_RESOURCE_CACHE_TTL`
   - Adjust `EXTERNAL_RESOURCE_LIMIT`

---

## 📞 Support

Nếu gặp vấn đề:
1. Check Railway logs
2. Test với local `.env` trước
3. Verify API keys còn valid
4. Contact Railway support: https://railway.app/help

---

**✨ Done! Variables đã được thêm vào production!**

**Thời gian ước tính:** 5-10 phút  
**Downtime:** ~10-30 giây (auto-restart)
