# 📋 CHECKLIST CHO TEAM LEAD - Chia Sẻ Project Với Team

## ✅ Những Gì Team Members Cần:

### 1️⃣ **Repository Access**
- [ ] Thêm team member vào GitHub repository
- [ ] Cấp quyền **Write** hoặc **Developer**

### 2️⃣ **MongoDB Atlas Connection String**
**Chia sẻ qua kênh BẢO MẬT (Slack DM, Discord, Messenger):**

```
mongodb+srv://bughunter_admin:bughunter_admin123@cluster0.kau5lqg.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0
```

⚠️ **LƯU Ý:**
- KHÔNG gửi qua chat group công khai
- KHÔNG post trong GitHub Issues/PRs
- KHÔNG commit vào code

### 3️⃣ **Hướng Dẫn Setup**
Gửi cho team file: `TEAM_SETUP_GUIDE.md`

---

## 📤 Cách Chia Sẻ Connection String An Toàn

### **Phương Án 1: Slack/Discord (Khuyến nghị)**
1. DM riêng từng người
2. Paste connection string
3. Hướng dẫn họ cập nhật vào `.env`

### **Phương Án 2: Password Manager**
1. Tạo shared vault trên **1Password**, **LastPass**, hoặc **Bitwarden**
2. Lưu connection string vào vault
3. Chia sẻ vault với team

### **Phương Án 3: Environment Management Tool**
1. Dùng **Doppler**, **Vault**, hoặc **AWS Secrets Manager**
2. Team pull secrets tự động

---

## 🔐 Bảo Mật MongoDB Atlas

### **Tạo User Riêng Cho Từng Môi Trường (Khuyến nghị)**

**Development User:**
```
Username: bughunter_dev
Password: <strong-password>
Role: Read/Write to BugHunter database
```

**Production User (sau này):**
```
Username: bughunter_prod
Password: <strong-password>
Role: Read/Write to BugHunter-prod database
```

### **Whitelist IP Addresses**

**Để test nhanh (Development):**
- Whitelist: `0.0.0.0/0` (Allow all IPs)

**Cho Production (sau này):**
- Chỉ whitelist IP của server production
- KHÔNG dùng `0.0.0.0/0`

---

## 👥 Quy Trình Team Member Setup

### **Bước 1: Team Lead Chuẩn Bị**
1. ✅ Kiểm tra `.env` đã được thêm vào `.gitignore`
2. ✅ Commit `.env.example` lên repository
3. ✅ Commit `TEAM_SETUP_GUIDE.md` lên repository
4. ✅ Chuẩn bị connection string để chia sẻ

### **Bước 2: Team Member Thực Hiện**
1. Clone repository
2. Cài dependencies: `npm install`
3. Copy `.env.example` → `.env`
4. Nhận connection string từ team lead
5. Paste vào file `.env`
6. Chạy `npm run dev`

### **Bước 3: Verify**
Team member gửi screenshot terminal (KHÔNG screenshot `.env`):
```
✅ MongoDB Connected Successfully!
Server is running on port 5000
```

---

## 🎯 Template Message Cho Team

Copy message này gửi cho team members:

---

**📧 Message Template:**

```
Hi [Tên],

Chào mừng vào project BugHunter! 🚀

Để setup môi trường development, follow các bước này:

1. Clone repo: [repository-url]

2. Đọc file hướng dẫn: TEAM_SETUP_GUIDE.md

3. MongoDB Atlas connection string (PRIVATE - đừng share):
   mongodb+srv://bughunter_admin:bughunter_admin123@cluster0.kau5lqg.mongodb.net/BugHunter?retryWrites=true&w=majority&appName=Cluster0

4. Paste connection string vào file server/.env (tạo từ .env.example)

5. Run server: npm run dev

Nếu có vấn đề, ping mình hoặc xem Troubleshooting trong TEAM_SETUP_GUIDE.md.

Happy coding!
```

---

## ✅ Checklist Cho Team Lead

- [ ] `.gitignore` có `.env`
- [ ] `.env.example` đã commit lên repo
- [ ] `TEAM_SETUP_GUIDE.md` đã commit lên repo
- [ ] Connection string đã được tạo
- [ ] IP đã được whitelist trên Atlas (0.0.0.0/0 cho dev)
- [ ] Test connection string trước khi share
- [ ] Gửi connection string qua kênh bảo mật cho từng member
- [ ] Gửi hướng dẫn setup cho team
- [ ] Verify team members setup thành công

---

## 🔄 Khi Cần Đổi Connection String

**Trường hợp:**
- Password bị lộ
- Chuyển sang cluster khác
- Tạo user mới

**Quy trình:**
1. Tạo user mới hoặc reset password trên Atlas
2. Update connection string
3. Thông báo team qua kênh bảo mật
4. Team update lại file `.env`
5. Restart server

---

**Made with ❤️ by BugHunter Team**
