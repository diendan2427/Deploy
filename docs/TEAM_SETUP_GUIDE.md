# 🚀 Hướng Dẫn Setup Project Cho Thành Viên Team

> Dành cho các thành viên mới tham gia project BugHunter

---

## 📋 Điều Kiện Tiên Quyết

Đảm bảo đã cài đặt:
- ✅ **Node.js 18+** → https://nodejs.org/
- ✅ **Git** → https://git-scm.com/
- ✅ **MongoDB Compass** (Optional - để xem database) → https://www.mongodb.com/products/compass

---

## 🎯 Các Bước Setup (10 phút)

### **Bước 1: Clone Project**

```bash
# Clone repository
git clone <repository-url>
cd Deploy
```

### **Bước 2: Cài Đặt Dependencies**

```bash
# Cài đặt dependencies cho SERVER
cd server
npm install

# Cài đặt dependencies cho CLIENT (terminal mới)
cd ../client
npm install
```

### **Bước 3: Tạo File `.env` Cho Server**

```bash
# Vào thư mục server
cd server

# Copy file .env.example thành .env
copy .env.example .env     # Windows CMD
# HOẶC
cp .env.example .env       # PowerShell/Git Bash
```

### **Bước 4: Lấy MongoDB Atlas Connection String Từ Team Lead**

**⚠️ QUAN TRỌNG:** Liên hệ **team lead** để lấy connection string qua kênh bảo mật (Slack DM, Discord, Messenger,...)

**KHÔNG chia sẻ connection string công khai!**

Team lead sẽ gửi cho bạn string dạng:
```
mongodb+srv://bughunter_admin:password@cluster0.kau5lqg.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0
```

### **Bước 5: Cập Nhật File `.env`**

Mở file `server\.env` và thay đổi dòng `MONGODB_URI`:

**TỪ:**
```env
MONGODB_URI=mongodb+srv://username:password@cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
```

**SANG:**
```env
MONGODB_URI=<connection-string-từ-team-lead>
```

**Paste đúng connection string mà team lead đã gửi!**

### **Bước 6: Kiểm Tra Các Config Khác (Optional)**

File `.env` còn các config khác, **KHÔNG cần thay đổi** cho development:

```env
PORT=5000                    # ✅ Giữ nguyên
NODE_ENV=development         # ✅ Giữ nguyên
JWT_SECRET=...               # ✅ Giữ nguyên
GOOGLE_CLIENT_ID=...         # ✅ Đã có sẵn
JUDGE0_API_URL=...           # ✅ Đã có sẵn
GEMINI_API_KEY=...           # ✅ Đã có sẵn
```

**Chỉ cần thay `MONGODB_URI` là đủ!**

### **Bước 7: Start Server**

```bash
# Trong thư mục server/
npm run dev
```

**Nếu thành công, bạn sẽ thấy:**
```
✅ MongoDB Connected Successfully!
Database: mongodb+srv://...
Server is running on port 5000
```

### **Bước 8: Start Client (Terminal mới)**

```bash
# Mở terminal mới, vào thư mục client/
cd client
npm run dev
```

**Client sẽ chạy tại:** http://localhost:3000

### **Bước 9: Test Ứng Dụng**

Mở browser: `http://localhost:3000`

**Test các chức năng:**
1. ✅ Đăng ký tài khoản mới
2. ✅ Đăng nhập
3. ✅ Làm challenges
4. ✅ Xem leaderboard

**Nếu muốn test admin:**
- Email: `admin@bughunter.com`
- Password: `admin123`

---

## 🔒 BẢO MẬT - QUAN TRỌNG!

### ⛔ KHÔNG BAO GIỜ:
- ❌ **Commit file `.env`** lên Git
- ❌ **Share connection string** công khai (chat group, issue, PR,...)
- ❌ **Screenshot file `.env`** có connection string thật
- ❌ **Hardcode connection string** trong code

### ✅ NÊN:
- ✅ Giữ file `.env` ở local machine
- ✅ Nhận connection string qua kênh riêng tư
- ✅ Dùng file `.env.example` để chia sẻ template

### 🔍 Kiểm Tra Trước Khi Commit:
```bash
# Xem file nào sẽ được commit
git status

# Đảm bảo .env KHÔNG có trong danh sách
# Nếu có, thêm vào .gitignore ngay!
```

---

## 🐛 Troubleshooting - Xử Lý Lỗi

### **Lỗi 1: "Cannot connect to MongoDB"**

**Nguyên nhân:** Connection string sai hoặc IP chưa được whitelist

**Giải pháp:**
1. Kiểm tra lại connection string (copy đúng, không thừa/thiếu ký tự)
2. Kiểm tra internet
3. Liên hệ team lead để whitelist IP của bạn

### **Lỗi 2: "Authentication failed"**

**Nguyên nhân:** Sai username/password trong connection string

**Giải pháp:**
- Xin lại connection string mới từ team lead
- Đảm bảo không có khoảng trắng thừa

### **Lỗi 3: "Port 5000 already in use"**

**Nguyên nhân:** Port 5000 đang được sử dụng bởi process khác

**Giải pháp:**

**Windows:**
```powershell
# Tìm process đang dùng port 5000
netstat -ano | findstr :5000

# Kill process (thay <PID> bằng số PID tìm được)
taskkill /PID <PID> /F
```

**Hoặc đổi port trong `.env`:**
```env
PORT=5001
```

### **Lỗi 4: "npm install fails"**

**Nguyên nhân:** Node modules bị lỗi hoặc cache

**Giải pháp:**
```bash
# Xóa node_modules và package-lock
rm -rf node_modules package-lock.json

# Cài lại
npm install
```

### **Lỗi 5: "Judge0 not responding"**

**Nguyên nhân:** Docker Judge0 chưa chạy

**Giải pháp:**
```bash
# Vào thư mục root của project
cd Deploy

# Start Judge0 với Docker
docker-compose up -d

# Kiểm tra Judge0 đang chạy
docker-compose ps
```

**Nếu chưa có Docker:**
- Judge0 là optional, các chức năng khác vẫn hoạt động
- Chỉ cần cho chức năng chạy code

---

## 📚 Tài Liệu Tham Khảo

| Tài liệu | Mô tả |
|----------|-------|
| `README.md` | Tổng quan project |
| `docs/MONGODB_ATLAS_MIGRATION.md` | Chi tiết về MongoDB Atlas |
| `server/ATLAS_SETUP_FOR_TEAM.md` | Quick start (file này) |
| `docs/setup/INSTALLATION.md` | Hướng dẫn cài đặt chi tiết |
| `docs/troubleshooting/DEBUG_GUIDE.md` | Hướng dẫn debug |

---

## 📂 Cấu Trúc Project

```
Deploy/
├── client/              # React Frontend
│   ├── src/
│   ├── .env            # ❌ KHÔNG có file này (client dùng Vite)
│   └── package.json
├── server/             # Express Backend
│   ├── src/
│   ├── .env            # ✅ CẦN TẠO FILE NÀY!
│   ├── .env.example    # Template
│   └── package.json
├── docs/               # Tài liệu
├── docker-compose.yml  # Judge0 config
└── README.md
```

---

## ✅ Checklist Setup Hoàn Thành

Đánh dấu khi hoàn thành:

- [ ] Clone repository thành công
- [ ] Cài đặt dependencies (server + client)
- [ ] Tạo file `server/.env` từ `.env.example`
- [ ] Nhận connection string từ team lead
- [ ] Cập nhật `MONGODB_URI` trong `.env`
- [ ] Server chạy thành công (`npm run dev`)
- [ ] Thấy message "MongoDB Connected Successfully"
- [ ] Client chạy thành công
- [ ] Truy cập được `http://localhost:3000`
- [ ] Test đăng ký/đăng nhập thành công
- [ ] Kiểm tra `.env` không bị commit (`git status`)

---

## 🆘 Cần Giúp Đỡ?

Nếu gặp vấn đề:

1. **Kiểm tra lại từng bước** trong hướng dẫn này
2. **Xem logs** trong terminal để biết lỗi cụ thể
3. **Tìm trong Troubleshooting** ở trên
4. **Liên hệ team:**
   - Team lead
   - Chat group
   - Tạo issue trên GitHub (KHÔNG gửi kèm connection string!)

---

## 🎉 Hoàn Thành!

Chúc mừng! Bạn đã setup xong môi trường development.

**Next steps:**
1. Đọc `README.md` để hiểu tổng quan project
2. Xem `docs/` để hiểu các tính năng
3. Tạo branch mới và bắt đầu code: `git checkout -b feature/your-feature`

**Happy coding! 🚀**

---

**Made with ❤️ by BugHunter Team**
