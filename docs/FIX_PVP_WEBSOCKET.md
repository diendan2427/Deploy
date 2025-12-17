# 🐛 PvP System Bug Fix - Production Deployment

**Date:** 2025-12-17  
**Issue:** PvP features not working after deployment (WebSocket connection failed)

---

## 🔍 Root Causes Identified

### 1. Socket.IO CORS Configuration (Server-side)
**File:** `server/src/services/websocket.service.ts`

**Problem:**
```typescript
cors: {
  origin: [
    "http://localhost:5173",
    "http://localhost:3000",
    "http://127.0.0.1:5173",
    "http://127.0.0.1:3000"
  ],
  // ❌ Missing production URLs!
}
```

**Impact:**
- WebSocket connections from production domains (Vercel) were blocked by CORS
- PvP real-time features failed silently
- Friend system, matchmaking, rooms all non-functional

---

### 2. Hardcoded WebSocket URL (Client-side)
**File:** `client/src/services/websocket.service.ts`

**Problem:**
```typescript
constructor(url?: string) {
  // ❌ Hardcoded to localhost:5000, ignoring VITE_API_URL
  this.url = url || `${window.location.protocol}://${window.location.hostname}:5000`;
}
```

**Impact:**
- Client always tried to connect to `https://hunterbug.vercel.app:5000` (doesn't exist)
- Should connect to Railway backend URL
- Environment variable `VITE_API_URL` was ignored

---

## ✅ Fixes Applied

### Fix 1: Update Socket.IO CORS (Server)

**File:** `server/src/services/websocket.service.ts` (Line 111-131)

```typescript
this.io = new SocketIOServer(server, {
  cors: {
    origin: process.env.NODE_ENV === 'production'
      ? [
          process.env.CLIENT_URL || "http://localhost:3000",
          "https://hunterbug.vercel.app",
          "https://deploy-production-a16c.up.railway.app",
          "http://localhost:5173",
          "http://localhost:3000",
          "http://127.0.0.1:5173",
          "http://127.0.0.1:3000"
        ]
      : true, // Allow all origins in development
    methods: ["GET", "POST"],
    credentials: true
  },
  transports: ['websocket', 'polling'],
  pingTimeout: 60000,
  pingInterval: 25000,
  allowEIO3: true // Support older clients
});
```

**Changes:**
- ✅ Added production URLs (Vercel frontend, Railway backend)
- ✅ Dynamic based on `NODE_ENV`
- ✅ Allows all origins in development for easier testing
- ✅ Added `allowEIO3` for broader client compatibility

---

### Fix 2: Use Environment Variable for WebSocket URL (Client)

**File:** `client/src/services/websocket.service.ts` (Line 11-21)

```typescript
constructor(url?: string) {
  // Use VITE_API_URL from environment or fallback to window location
  const apiUrl = import.meta.env.VITE_API_URL || 
                 `${window.location.protocol}//${window.location.hostname}:5000`;
  
  // Remove /api suffix if present, Socket.IO connects to root
  this.url = url || apiUrl.replace(/\/api$/, '');
  
  console.log('WebSocket URL:', this.url);
  console.log('Environment API URL:', import.meta.env.VITE_API_URL);
}
```

**Changes:**
- ✅ Now uses `import.meta.env.VITE_API_URL` (Vercel env variable)
- ✅ Removes `/api` suffix (Socket.IO connects to root, not `/api`)
- ✅ Proper fallback for local development
- ✅ Added debug logging

---

## 🧪 Testing Checklist

### Before Deploy:
- [x] Identified CORS issues in server
- [x] Identified hardcoded URL in client
- [x] Fixed both files
- [x] Verified environment variables exist

### After Deploy:

#### 1. WebSocket Connection
- [ ] Open browser console on production: `https://hunterbug.vercel.app`
- [ ] Should see: `🔌 Socket.IO connected successfully!`
- [ ] Should NOT see: `Socket.IO connection error: CORS`

#### 2. PvP Room Creation
- [ ] Navigate to PvP page
- [ ] Click "Create Room"
- [ ] Room should appear in list
- [ ] Real-time updates work

#### 3. Friend System
- [ ] Navigate to Friends page
- [ ] Can see online users
- [ ] Can send friend requests
- [ ] Real-time notifications work

#### 4. Matchmaking
- [ ] Start matchmaking
- [ ] Should connect to WebSocket
- [ ] No errors in console

---

## 📊 Environment Variables Required

### Vercel (Frontend)
```env
VITE_API_URL=https://deploy-production-a16c.up.railway.app
```

**Verify:** Vercel Dashboard → Project → Settings → Environment Variables

### Railway (Backend)
```env
NODE_ENV=production
CLIENT_URL=https://hunterbug.vercel.app
```

**Verify:** Railway Dashboard → Service → Variables

---

## 🔍 Debugging Commands

### Check WebSocket Connection (Browser Console)
```javascript
// On production site
console.log('API URL:', import.meta.env.VITE_API_URL);

// Should show Railway URL
// Expected: https://deploy-production-a16c.up.railway.app
```

### Check Socket.IO Connection
```javascript
// In browser console after page load
localStorage.getItem('token'); // Should return a JWT token

// Check WebSocket service
window.__ws_debug = true; // Enable debug mode (if implemented)
```

### Server Logs (Railway)
```bash
# Check WebSocket connections
# Look for:
# "User authenticated: [username]"
# "User connected: [username]"
```

---

## 🚀 Deployment Steps

### 1. Commit Changes
```bash
git add server/src/services/websocket.service.ts
git add client/src/services/websocket.service.ts
git commit -m "fix: resolve PvP WebSocket connection issues in production

- Update Socket.IO CORS to include production URLs
- Fix client WebSocket URL to use VITE_API_URL environment variable
- Add support for both development and production environments
- Improve error logging for debugging

Fixes:
- PvP room creation/joining
- Friend system real-time updates
- Matchmaking functionality
- Online users display

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
```

### 2. Push to GitHub
```bash
git push origin main
```

### 3. Verify Auto-Deploy
- **Railway:** Auto-deploys backend (2-3 minutes)
- **Vercel:** Auto-deploys frontend (1-2 minutes)

### 4. Test Production
- Wait for both deploys to complete
- Test all PvP features
- Check browser console for errors

---

## 🔄 Rollback Plan (If Needed)

If issues persist:

```bash
# Revert to previous commit
git revert HEAD
git push origin main

# Or reset to specific commit
git reset --hard <previous-commit-hash>
git push origin main --force
```

---

## 📝 Related Issues

### Issue 1: Room not appearing in list
**Cause:** WebSocket not connected, no real-time updates  
**Fix:** This patch resolves it

### Issue 2: Cannot see friends online
**Cause:** WebSocket CORS blocked  
**Fix:** This patch resolves it

### Issue 3: Matchmaking stuck on "Searching..."
**Cause:** WebSocket connection failed  
**Fix:** This patch resolves it

---

## 🎯 Expected Behavior After Fix

### PvP System:
- ✅ Create room → Room appears in list immediately
- ✅ Join room → See other players join in real-time
- ✅ Start match → All players get synchronized start

### Friend System:
- ✅ See online friends with green dot
- ✅ Send friend request → Target user gets notification immediately
- ✅ Accept request → Both users see update instantly

### Matchmaking:
- ✅ Start matchmaking → System searches for opponent
- ✅ Match found → Both players get notification
- ✅ Match starts → Synchronized for both players

---

## 🔧 Additional Notes

### Why Socket.IO and not just REST API?

PvP requires **real-time bidirectional communication**:
- Player joins room → Notify all players instantly
- Player submits code → Show submission to opponent
- Timer sync → All players see same countdown
- Friend comes online → Update status immediately

REST API would require constant polling (inefficient).

### Why separate CORS for Socket.IO?

Socket.IO has its own CORS middleware separate from Express CORS. Both must be configured:
- `app.ts`: Express CORS for HTTP requests
- `websocket.service.ts`: Socket.IO CORS for WebSocket connections

---

## ✅ Verification After Deploy

Run this in browser console on production:

```javascript
// Check if Socket.IO connected
window.io && window.io.connected 
  ? '✅ WebSocket Connected' 
  : '❌ WebSocket Not Connected';

// Check environment
console.table({
  'API URL': import.meta.env.VITE_API_URL,
  'Mode': import.meta.env.MODE,
  'Token': localStorage.getItem('token') ? 'Present' : 'Missing'
});
```

Expected output:
```
✅ WebSocket Connected

API URL: https://deploy-production-a16c.up.railway.app
Mode: production
Token: Present
```

---

## 📞 Support

If issues persist after this fix:

1. Check Railway logs for WebSocket errors
2. Check Vercel function logs
3. Verify environment variables on both platforms
4. Test with different browsers (Chrome, Firefox, Safari)
5. Clear browser cache and localStorage
6. Test with VPN disabled (some VPNs block WebSockets)

---

**Status:** ✅ Fix Ready for Deployment  
**Impact:** Critical - Restores all PvP functionality  
**Downtime:** None (hot reload)  
**Risk Level:** Low (only affecting non-working features)
