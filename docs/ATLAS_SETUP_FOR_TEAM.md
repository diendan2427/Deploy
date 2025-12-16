# 🚀 Quick Start - MongoDB Atlas Setup for Team

> Dành cho các thành viên team nhận được connection string từ team lead

## Bước 1: Copy file `.env.example` thành `.env`

```powershell
# Trong thư mục server\
cp .env.example .env
```

## Bước 2: Nhận Connection String từ Team Lead

Team lead sẽ gửi cho bạn MongoDB Atlas connection string, dạng:
```
mongodb+srv://username:password@cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
```

## Bước 3: Cập nhật file `.env`

Mở file `server\.env` và thay đổi dòng:

```env
MONGODB_URI=mongodb+srv://username:password@cluster.xxxxx.mongodb.net/bughunter?retryWrites=true&w=majority
```

Paste connection string mà team lead đã gửi.

## Bước 4: Cài đặt dependencies

```powershell
cd server
npm install
```

## Bước 5: Chạy server

```powershell
npm run dev
```

## Bước 6: Kiểm tra kết nối

Nếu thành công, bạn sẽ thấy:
```
✅ MongoDB Connected Successfully!
Database: mongodb+srv://...
Server is running on port 5000
```

## ⚠️ LƯU Ý QUAN TRỌNG

### 🔒 Bảo mật
- **KHÔNG BAO GIỜ** commit file `.env` lên Git
- **KHÔNG** chia sẻ connection string công khai
- File `.env` đã được thêm vào `.gitignore`

### 🐛 Troubleshooting

**Lỗi "Authentication failed":**
- Kiểm tra lại connection string
- Liên hệ team lead để verify

**Lỗi "Connection timeout":**
- Kiểm tra kết nối internet
- Có thể IP của bạn chưa được whitelist → Liên hệ team lead

**Lỗi "Database not found":**
- Database có thể chưa có data
- Chạy seed script: `npm run setup-db`

## 📞 Hỗ trợ

Nếu gặp vấn đề, liên hệ:
- Team lead
- Xem docs đầy đủ: `docs/MONGODB_ATLAS_MIGRATION.md`

---

**Happy coding! 🎉**
