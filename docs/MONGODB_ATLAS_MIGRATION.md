# 🚀 Hướng Dẫn Chuyển Database từ MongoDB Compass sang MongoDB Atlas

## 📋 Tổng Quan
Hướng dẫn chi tiết cách migrate toàn bộ dữ liệu từ MongoDB local (Compass) sang MongoDB Atlas (Cloud).

---

## ✅ Phần 1: Tạo MongoDB Atlas Cluster (15 phút)

### Bước 1.1: Đăng ký MongoDB Atlas
1. Truy cập: https://www.mongodb.com/cloud/atlas/register
2. Đăng ký tài khoản miễn phí (có thể dùng Google Account)
3. Verify email

### Bước 1.2: Tạo Organization và Project
1. Sau khi đăng nhập, tạo Organization mới (hoặc dùng có sẵn)
2. Tạo Project mới, đặt tên: **BugHunter** (hoặc tên bạn muốn)

### Bước 1.3: Tạo Cluster (Database)
1. Click **"Build a Database"** hoặc **"Create"**
2. Chọn **FREE tier M0** (miễn phí)
   - RAM: 512 MB
   - Storage: 5 GB
   - Shared CPU
3. Chọn **Cloud Provider & Region**:
   - Provider: **AWS** hoặc **Google Cloud**
   - Region: **Singapore (ap-southeast-1)** hoặc **Tokyo (ap-northeast-1)** (gần Việt Nam nhất)
4. Cluster Name: **BugHunter-Cluster** (hoặc tên bạn muốn)
5. Click **"Create Cluster"** → Đợi 3-5 phút

### Bước 1.4: Tạo Database User
1. Trong màn hình **Security Quickstart**, tạo user:
   - **Username**: `bughunter_admin` (hoặc tên bạn muốn)
   - **Password**: Tạo password mạnh (LƯU LẠI!)
   - Click **"Create User"**

### Bước 1.5: Whitelist IP Address
1. Trong **Network Access**:
   - Click **"Add IP Address"**
   - Chọn **"Allow Access from Anywhere"** (0.0.0.0/0)
   - Hoặc thêm IP cụ thể của bạn
   - Click **"Confirm"**

⚠️ **LƯU Ý**: Trong production nên giới hạn IP cụ thể thay vì 0.0.0.0/0

### Bước 1.6: Lấy Connection String
1. Click **"Connect"** ở cluster của bạn
2. Chọn **"Connect your application"**
3. Driver: **Node.js**
4. Version: **4.1 or later**
5. Copy Connection String, dạng:
   ```
   mongodb+srv://bughunter_admin:<password>@bughunter-cluster.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. Thay `<password>` bằng password thật của user
7. Thêm tên database vào sau `.net/`: `bughunter`
   ```
   mongodb+srv://bughunter_admin:<password>@bughunter-cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
   ```

✅ **Hoàn thành Phần 1!** Bạn đã có MongoDB Atlas cluster.

---

## 📦 Phần 2: Cài Đặt MongoDB Database Tools

### Cách 1: Tải MongoDB Database Tools (Khuyến nghị)
1. Truy cập: https://www.mongodb.com/try/download/database-tools
2. Chọn:
   - Platform: **Windows**
   - Package: **zip**
3. Download và giải nén
4. Copy tất cả file `.exe` trong thư mục `bin/` vào:
   - `C:\Program Files\MongoDB\Tools\100\bin\`
   hoặc
   - Thêm đường dẫn vào Environment Variable PATH

### Cách 2: Sử dụng MongoDB Compass GUI (Dễ nhất)
MongoDB Compass có sẵn chức năng Export/Import!

**Không cần cài MongoDB Database Tools nếu dùng cách này.**

---

## 💾 Phần 3: Backup Dữ Liệu từ MongoDB Local

### Phương Án A: Dùng MongoDB Compass (Khuyến nghị - Dễ nhất)

#### Bước 3A.1: Export từng Collection
1. Mở **MongoDB Compass**
2. Connect tới `mongodb://localhost:27017`
3. Chọn database **bughunter**
4. Với mỗi collection:
   - Click vào collection
   - Click **"Export Data"** (icon Export)
   - Chọn format: **JSON**
   - Chọn đường dẫn lưu: `C:\Users\thanh\Downloads\Deploy\Deploy\backup\`
   - Đặt tên: `<collection-name>.json`
   - Click **Export**

#### Collections cần export:
- `users.json`
- `challenges.json`
- `submissions.json`
- `pvprooms.json`
- `pvpmatches.json`
- `friends.json`
- `favorites.json`
- `chathistories.json`
- `chatmessages.json`
- `trainingdata.json`
- `notifications.json`
- `comments.json`
- `achievements.json`
- `learningresources.json`
- `reports.json`
- `feedbacks.json`
- ... (các collection khác nếu có)

### Phương Án B: Dùng mongodump (Nếu đã cài Database Tools)

```bash
# Tạo thư mục backup
mkdir C:\Users\thanh\Downloads\Deploy\Deploy\backup

# Backup toàn bộ database
mongodump --uri="mongodb://localhost:27017/bughunter" --out="C:\Users\thanh\Downloads\Deploy\Deploy\backup"
```

---

## 📤 Phần 4: Restore Dữ Liệu lên MongoDB Atlas

### Phương Án A: Dùng MongoDB Compass (Khuyến nghị)

#### Bước 4A.1: Connect tới Atlas
1. Mở **MongoDB Compass**
2. Click **"New Connection"**
3. Paste Connection String từ Bước 1.6:
   ```
   mongodb+srv://bughunter_admin:<password>@bughunter-cluster.xxxxx.mongodb.net/bughunter
   ```
4. Thay `<password>` bằng password thật
5. Click **"Connect"**

#### Bước 4A.2: Import từng Collection
1. Trong Compass (đã connect tới Atlas)
2. Chọn database **bughunter** (tự tạo nếu chưa có)
3. Click **"Create Collection"** → Tạo collection mới (ví dụ: `users`)
4. Click vào collection vừa tạo
5. Click **"Add Data"** → **"Import JSON or CSV file"**
6. Chọn file tương ứng từ thư mục backup (ví dụ: `users.json`)
7. Click **"Import"**
8. Lặp lại với tất cả collections

### Phương Án B: Dùng mongorestore (Nếu đã cài Database Tools)

```bash
# Restore toàn bộ database
mongorestore --uri="mongodb+srv://bughunter_admin:<password>@bughunter-cluster.xxxxx.mongodb.net/bughunter" "C:\Users\thanh\Downloads\Deploy\Deploy\backup\bughunter"
```

⚠️ **Thay `<password>` bằng password thật!**

---

## ⚙️ Phần 5: Cập Nhật Code

### Bước 5.1: Backup file .env hiện tại
```bash
cp server\.env server\.env.local.backup
```

### Bước 5.2: Cập nhật MONGODB_URI trong `.env`

Mở file `server\.env` và thay đổi dòng:

**TỪ:**
```env
MONGODB_URI=mongodb://localhost:27017/bughunter
```

**SANG:**
```env
MONGODB_URI=mongodb+srv://bughunter_admin:<password>@bughunter-cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
```

⚠️ **Nhớ thay `<password>` bằng password thật!**

### Bước 5.3: Tạo file `.env.example` (để chia sẻ team)
Tạo file mới với connection string mẫu (KHÔNG có password thật):
```env
MONGODB_URI=mongodb+srv://username:password@cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
```

---

## ✅ Phần 6: Test Kết Nối

### Bước 6.1: Stop server hiện tại
```bash
# Nếu server đang chạy, bấm Ctrl+C để dừng
```

### Bước 6.2: Khởi động server
```bash
cd C:\Users\thanh\Downloads\Deploy\Deploy\server
npm run dev
```

### Bước 6.3: Kiểm tra logs
Xem terminal, nếu thành công sẽ thấy:
```
✅ MongoDB Connected Successfully!
Database: mongodb+srv://bughunter_admin:***@bughunter-cluster.xxxxx.mongodb.net/bughunter
Server is running on port 5000
```

### Bước 6.4: Test các chức năng
1. Mở client: `http://localhost:3000`
2. Test login/register
3. Test challenges
4. Test PvP
5. Kiểm tra leaderboard

---

## 🔒 Phần 7: Bảo Mật (Quan trọng!)

### 7.1: Thêm `.env` vào `.gitignore`
Kiểm tra file `.gitignore` có dòng:
```
.env
.env.local
.env.*.local
```

### 7.2: Không commit password thật
- Chỉ commit `.env.example` với thông tin mẫu
- **KHÔNG BAO GIỜ** commit file `.env` có password thật!

### 7.3: Tạo User riêng cho từng môi trường
Trong MongoDB Atlas, tạo nhiều users:
- `bughunter_dev` - Cho development
- `bughunter_prod` - Cho production (quyền hạn chế hơn)

### 7.4: Giới hạn IP trong Production
- Trong **Network Access**, xóa `0.0.0.0/0`
- Chỉ thêm IP của server production

---

## 🚀 Phần 8: Chia Sẻ Với Team

### Bước 8.1: Tạo file hướng dẫn cho team
Tạo file `server\ATLAS_SETUP_FOR_TEAM.md`:

```markdown
# Setup MongoDB Atlas cho Team

## Bước 1: Lấy Connection String
Liên hệ team lead để lấy MongoDB Atlas connection string.

## Bước 2: Tạo file `.env`
Copy file `.env.example` thành `.env`:
\`\`\`bash
cp .env.example .env
\`\`\`

## Bước 3: Cập nhật MONGODB_URI
Mở file `.env` và thay đổi dòng:
\`\`\`env
MONGODB_URI=<connection-string-from-team-lead>
\`\`\`

## Bước 4: Chạy server
\`\`\`bash
npm run dev
\`\`\`
```

### Bước 8.2: Chia sẻ Connection String qua kênh an toàn
- **KHÔNG** chia sẻ qua email/chat công khai
- Dùng: 1Password, LastPass, hoặc tin nhắn riêng

---

## 📊 So Sánh MongoDB Local vs Atlas

| Tiêu chí | MongoDB Local (Compass) | MongoDB Atlas (Cloud) |
|----------|-------------------------|----------------------|
| **Truy cập** | Chỉ máy local | Từ mọi nơi có internet |
| **Chia sẻ** | Không thể | Nhiều người cùng lúc |
| **Backup** | Thủ công | Tự động (Atlas có sẵn) |
| **Bảo mật** | Thấp | Cao (SSL, Authentication) |
| **Deploy** | Không thể | Sẵn sàng deploy |
| **Chi phí** | Miễn phí | FREE tier 512MB |

---

## ❓ Troubleshooting

### Lỗi: "Authentication failed"
**Nguyên nhân**: Sai username/password

**Giải pháp**:
1. Vào MongoDB Atlas → Database Access
2. Edit user, reset password
3. Cập nhật lại connection string

### Lỗi: "Connection timeout"
**Nguyên nhân**: IP chưa được whitelist

**Giải pháp**:
1. Vào MongoDB Atlas → Network Access
2. Add IP Address → Allow access from anywhere (0.0.0.0/0)

### Lỗi: "Database not found"
**Nguyên nhân**: Chưa có database/collection

**Giải pháp**:
1. Import lại data từ backup
2. Hoặc chạy script seed: `npm run setup-db`

### Lỗi: "mongodump not found"
**Nguyên nhân**: Chưa cài MongoDB Database Tools

**Giải pháp**:
- Dùng MongoDB Compass GUI để export/import
- Hoặc cài Database Tools theo Phần 2

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra lại từng bước
2. Xem logs trong terminal
3. Check MongoDB Atlas Dashboard → Metrics → Connection

---

## ✅ Checklist Hoàn Thành

- [ ] Tạo MongoDB Atlas cluster
- [ ] Tạo database user
- [ ] Whitelist IP
- [ ] Lấy connection string
- [ ] Backup data từ local
- [ ] Import data lên Atlas
- [ ] Cập nhật `.env`
- [ ] Test kết nối thành công
- [ ] Server chạy không lỗi
- [ ] Tất cả chức năng hoạt động
- [ ] Thêm `.env` vào `.gitignore`
- [ ] Tạo `.env.example` cho team

**🎉 Chúc mừng! Bạn đã migrate thành công sang MongoDB Atlas!**
