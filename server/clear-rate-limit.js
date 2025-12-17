// Script to clear rate limiting cache
// Run this to immediately unblock yourself

const http = require('http');

console.log('🔧 Clearing rate limiting cache...\n');

// This script will restart the server, which clears the in-memory rate limit cache

const options = {
  hostname: 'localhost',
  port: 5000,
  path: '/api/debug/clear-rate-limit',
  method: 'POST',
  timeout: 5000
};

const req = http.request(options, (res) => {
  console.log('✅ Rate limit cache cleared!');
  console.log('Status:', res.statusCode);
  console.log('\n✨ You can now login again without restrictions.\n');
});

req.on('error', (error) => {
  console.log('\n⚠️  API endpoint not available.');
  console.log('\n💡 Alternative: Just restart your server to clear the cache:');
  console.log('   1. Stop the server (Ctrl+C)');
  console.log('   2. Start again: npm run dev');
  console.log('\n   The in-memory cache will be cleared on restart.\n');
});

req.on('timeout', () => {
  console.log('\n⚠️  Request timed out.');
  console.log('💡 Just restart your server to clear the cache.\n');
  req.destroy();
});

req.end();
