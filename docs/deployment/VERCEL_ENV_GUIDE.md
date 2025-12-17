# 📝 Hướng Dẫn Nhập Environment Variables trên Vercel

## Giao diện Vercel Environment Variables

Khi bạn vào phần **Environment Variables** trên Vercel, bạn sẽ thấy giao diện như sau:

```
┌─────────────────────────────────────────────────────────────┐
│  Environment Variables                                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐  ┌──────────────────────────────────┐ │
│  │ Key             │  │ Value                            │ │
│  └─────────────────┘  └──────────────────────────────────┘ │
│                                                              │
│  [Add Another]                                               │
└─────────────────────────────────────────────────────────────┘
```

## ✅ Cách Nhập ĐÚNG

### Ví dụ 1: VITE_API_URL

**Cột Key (bên trái):**
```
VITE_API_URL
```

**Cột Value (bên phải):**
```
https://deploy-production-a16c.up.railway.app
```

### Ví dụ 2: NODE_ENV

**Cột Key (bên trái):**
```
NODE_ENV
```

**Cột Value (bên phải):**
```
production
```

### Ví dụ 3: VITE_GOOGLE_CLIENT_ID (nếu cần)

**Cột Key (bên trái):**
```
VITE_GOOGLE_CLIENT_ID
```

**Cột Value (bên phải):**
```
123456789-abc...xyz.apps.googleusercontent.com
```

---

## ❌ Các Lỗi Thường Gặp

### ❌ SAI: Nhập cả dòng vào Key

**ĐỪNG làm thế này:**

Cột Key:
```
VITE_API_URL=https://deploy-production-a16c.up.railway.app
```

Cột Value:
```
(để trống)
```

→ **Sai vì:** Key không được chứa dấu `=` và value

---

### ❌ SAI: Thêm dấu ngoặc kép

**ĐỪNG làm thế này:**

Cột Key:
```
VITE_API_URL
```

Cột Value:
```
"https://deploy-production-a16c.up.railway.app"
```

→ **Sai vì:** Vercel sẽ lưu cả dấu `""` vào giá trị, khiến URL lỗi

---

### ❌ SAI: Copy-paste từ file .env

**ĐỪNG làm thế này:**

Copy toàn bộ từ file `.env`:
```
VITE_API_URL=https://deploy-production-a16c.up.railway.app
NODE_ENV=production
```

Rồi paste vào cột Key hoặc Value

→ **Sai vì:** Vercel cần nhập từng biến riêng, không thể paste nhiều dòng

---

## ✅ Quy Trình Nhập ĐÚNG (Step-by-step)

### Bước 1: Nhập biến đầu tiên

1. Click vào ô **"Key"** (bên trái)
2. Nhập: `VITE_API_URL`
3. Nhấn **Tab** hoặc click vào ô **"Value"** (bên phải)
4. Nhập: `https://deploy-production-a16c.up.railway.app`
5. Click nút **"Add"** hoặc nhấn **Enter**

### Bước 2: Vercel tự động tạo hàng mới

Sau khi Add, Vercel sẽ:
- Lưu biến vừa nhập
- Tạo sẵn 1 hàng mới để bạn nhập biến tiếp theo

### Bước 3: Nhập biến thứ 2

1. Click vào ô **"Key"** mới
2. Nhập: `NODE_ENV`
3. Click vào ô **"Value"**
4. Nhập: `production`
5. Click **"Add"**

### Bước 4: Lặp lại cho các biến khác

Tiếp tục nhập cho đến khi có đủ các biến cần thiết.

---

## 📋 Danh Sách Biến Cần Nhập cho BugHunter

| # | Key | Value | Mô tả |
|---|-----|-------|-------|
| 1 | `VITE_API_URL` | `https://deploy-production-a16c.up.railway.app` | Backend API URL |
| 2 | `NODE_ENV` | `production` | Node environment |
| 3 | `VITE_GOOGLE_CLIENT_ID` | `(Google Client ID)` | OAuth Google (nếu frontend cần) |

**Lưu ý:**
- Biến số 3 chỉ cần nếu frontend xử lý OAuth redirect
- Thường backend xử lý OAuth nên không cần `VITE_GOOGLE_CLIENT_ID`

---

## 🎯 Sau Khi Nhập Xong

1. Vercel sẽ hiển thị danh sách biến đã nhập:
   ```
   VITE_API_URL = https://deploy-production-a16c.up.railway.app
   NODE_ENV = production
   ```

2. Chọn **Environment** áp dụng:
   - ✅ **Production** (bắt buộc)
   - ✅ **Preview** (khuyến nghị - cho PR preview)
   - ⬜ Development (không cần - dùng .env local)

3. Click **"Save"**

4. Vercel sẽ **tự động redeploy** với biến mới

---

## 🔍 Kiểm Tra Biến Đã Lưu

Sau khi deploy xong:

1. Vào **Settings** → **Environment Variables**
2. Bạn sẽ thấy danh sách biến đã lưu
3. Vercel **ẩn giá trị** để bảo mật (hiển thị `***`)
4. Click **"Edit"** để xem/sửa giá trị

---

## 🧪 Test Biến Trong Code

File: `client/src/services/api.ts`

```typescript
// Log để kiểm tra (chỉ dùng khi debug)
console.log('API URL:', import.meta.env.VITE_API_URL);
console.log('ENV:', import.meta.env.MODE);

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export const api = axios.create({
  baseURL: `${API_URL}/api`,
  withCredentials: true
});
```

Sau khi deploy, mở **Console** trên browser:
```
API URL: https://deploy-production-a16c.up.railway.app
ENV: production
```

Nếu thấy đúng → Biến đã được load thành công!

---

## 💡 Tips

1. **Không thêm comment**: Vercel không hỗ trợ comment trong env vars
   ```
   ❌ VITE_API_URL  (key)
   ❌ https://... # Backend URL  (value)
   ```

2. **Không có khoảng trắng thừa**: Vercel lưu nguyên, kể cả space
   ```
   ❌ " VITE_API_URL" (có space đầu)
   ❌ "production " (có space cuối)
   ```

3. **Phân biệt hoa thường**: `VITE_API_URL` ≠ `vite_api_url`

4. **Không cần xuống dòng**: Mỗi biến 1 hàng riêng

---

**Made with ❤️ by BugHunter Team**
