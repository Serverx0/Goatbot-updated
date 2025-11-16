# Deployment Guide for Render/Railway

This guide explains how to deploy Goat Bot V2 to Render or Railway using Docker.

## Prerequisites

Before deploying, ensure you have:
1. **config.json** - Your bot configuration file
2. **configCommands.json** - Your commands configuration file
3. **account.txt** - Your Facebook account credentials (cookies/token)

## Important Notes

### Configuration Files
- The bot uses **regular files** (config.json, account.txt) in production
- Development files (*.dev.json, *.dev.txt) are only used locally with `NODE_ENV=development`
- Do NOT rename your files to .dev extensions for deployment

### Environment Variables
Set these environment variables in your deployment platform:

#### Required:
- `NODE_ENV=production` (automatically set by the Dockerfile)

#### Optional (if not using config files):
You can also provide configuration through environment variables:
- `PORT` - Port for health check endpoint (default: 3000)

## Deployment Instructions

### Option 1: Deploy to Render

1. **Create a new Web Service** on Render
2. Connect your GitHub/GitLab repository
3. Configure the service:
   - **Environment**: Docker
   - **Dockerfile Path**: `./Dockerfile`
   - **Instance Type**: Choose based on your needs (at least 512MB RAM recommended)

4. **Add Secret Files**:
   - Go to "Environment" → "Secret Files"
   - Add these files:
     - `config.json` - paste your configuration
     - `configCommands.json` - paste your commands config
     - `account.txt` - paste your Facebook credentials

5. **Environment Variables**:
   - `NODE_ENV` = `production` (optional, already set in Dockerfile)

6. **Deploy**: Click "Create Web Service"

### Option 2: Deploy to Railway

1. **Create a new project** on Railway
2. Select "Deploy from GitHub repo"
3. Configure the service:
   - Railway will auto-detect the Dockerfile

4. **Add Environment Variables**:
   - Go to "Variables" tab
   - You can add your configuration as environment variables OR use Railway's volume feature

5. **Add Configuration Files**:
   
   **Method A - Using Volumes (Recommended):**
   - Create a volume and mount it to `/app`
   - Upload your config.json, configCommands.json, and account.txt to the volume

   **Method B - Build-time:**
   - Include the files in your repository (make sure they're in .gitignore for security)
   - Or use Railway's secret management

6. **Deploy**: Railway will automatically deploy

## Persistent Storage

For the database (SQLite), you need persistent storage:

### Render:
- Add a persistent disk
- Mount path: `/app/database`
- Size: At least 1GB

### Railway:
- Create a volume
- Mount path: `/app/database`
- Size: At least 1GB

## Health Check

The bot doesn't have a built-in health check endpoint by default. If your platform requires one, you may need to add a simple HTTP server.

To add a health check, you can modify the bot to include a basic Express endpoint:

```javascript
// Add to Goat.js or index.js
const express = require('express');
const healthApp = express();
healthApp.get('/health', (req, res) => res.send('OK'));
healthApp.listen(process.env.PORT || 3000);
```

## Security Considerations

⚠️ **IMPORTANT SECURITY NOTES:**

1. **Never commit sensitive files** to your repository:
   - account.txt (contains Facebook credentials)
   - config.json (may contain sensitive data)
   - configCommands.json

2. **Add to .gitignore**:
   ```
   account.txt
   config.json
   configCommands.json
   *.dev.*
   database/*.sqlite
   ```

3. **Use platform secret management**:
   - Render: Use Secret Files feature
   - Railway: Use Volume or environment variables

4. **Facebook Account Security**:
   - Use app-specific passwords if possible
   - Enable 2FA on your Facebook account
   - Monitor login activity regularly
   - Consider using a dedicated Facebook account for the bot

## Troubleshooting

### Bot won't start

**Error: "config.json not found"**
- Ensure your config files are properly uploaded to the platform
- Check file permissions and paths

**Error: "account.txt not found"**
- Verify account.txt is in the root directory
- Ensure it contains valid Facebook credentials

### Database issues

**Error: "SQLITE_CANTOPEN"**
- Ensure persistent storage is properly mounted at `/app/database`
- Check volume permissions

### Memory issues

**Bot crashes with out-of-memory**
- Increase instance size (recommended: at least 512MB RAM)
- Monitor memory usage and optimize if needed

## Configuration File Examples

### Minimal config.json structure:
```json
{
  "facebookAccount": {
    "email": "",
    "password": "",
    "2FASecret": ""
  },
  "adminBot": ["YOUR_FACEBOOK_ID"],
  "prefix": "!",
  "language": "en",
  "database": {
    "type": "sqlite"
  }
}
```

### account.txt formats supported:
1. Facebook cookies (JSON array)
2. Access token (starts with EAAAA)
3. Cookie string (key=value;key2=value2)
4. Email and password (line 1: email, line 2: password)

## Monitoring

- Monitor your bot's logs through the platform dashboard
- Set up alerts for crashes or errors
- Regularly check Facebook login status
- Monitor resource usage (CPU, RAM, storage)

## Updates

To update your bot:

1. Push changes to your repository
2. Platform will auto-deploy (if auto-deploy is enabled)
3. Or manually trigger a deployment through the dashboard

## Support

For issues specific to:
- **Goat Bot**: See [GitHub repository](https://github.com/ntkhang03/Goat-Bot-V2)
- **Render**: Check [Render documentation](https://render.com/docs)
- **Railway**: Check [Railway documentation](https://docs.railway.app)
