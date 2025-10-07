# MongoDB Atlas + Realm Device Sync Setup Guide

## Overview
This guide will help you set up MongoDB Atlas with Realm Device Sync for the SnapLingua app, supporting user registration, login, and survey functionality.

## Prerequisites
- MongoDB Atlas account
- Basic understanding of NoSQL databases
- Flutter development environment

## Step 1: Create MongoDB Atlas Cluster

### 1.1 Create Account and Project
1. Go to [MongoDB Atlas](https://cloud.mongodb.com)
2. Create an account or sign in
3. Create a new project named "SnapLingua"

### 1.2 Create Database Cluster
1. Click "Create Database"
2. Choose "Shared" (M0 - Free tier)
3. Select **Singapore (ap-southeast-1)** region for better performance in Vietnam
4. Cluster name: `snaplingua-cluster`
5. Click "Create Cluster"

### 1.3 Configure Network Access
1. Go to "Network Access" tab
2. Click "Add IP Address"
3. Choose "Allow access from anywhere" (0.0.0.0/0) for development
4. For production, restrict to specific IPs

### 1.4 Create Database User
1. Go to "Database Access" tab
2. Click "Add New Database User"
3. Username: `snaplingua_user`
4. Password: Generate a strong password
5. Role: "Read and write to any database"

## Step 2: Set Up Realm App

### 2.1 Create Realm Application
1. Go to "App Services" tab in Atlas
2. Click "Create a New App"
3. App name: `snaplingua-app`
4. Choose your cluster: `snaplingua-cluster`
5. Environment: Development
6. Click "Create App"

### 2.2 Configure Authentication
1. In your Realm app, go to "Authentication"
2. Click "Authentication Providers"
3. Enable "Email/Password"
4. Settings:
   - User Confirmation: "Automatically confirm users"
   - Password Reset: "Send a password reset email"
   - Password Requirements: Minimum 6 characters

### 2.3 Enable Device Sync
1. Go to "Device Sync" tab
2. Click "Enable Sync"
3. Choose "Flexible Sync"
4. Partition-based sync: No (we're using Flexible Sync)
5. Development Mode: Enable (for easier schema development)

### 2.4 Configure Sync Rules
```javascript
// Default rule - allow users to sync their own data
{
  "userId": "%%user.id"
}
```

## Step 3: Database Schema

### 3.1 Collections Structure
```javascript
// Users Collection
{
  "_id": ObjectId,
  "userId": String, // Realm user ID
  "email": String,
  "name": String,
  "gender": String,
  "birthDay": String,
  "birthMonth": String,
  "birthYear": String,
  "purpose": String,
  "studyTime": String,
  "surveyCompleted": Boolean,
  "level": Number,
  "xp": Number,
  "streak": Number,
  "isVerified": Boolean,
  "avatarUrl": String,
  "deviceId": String,
  "fcmToken": String,
  "createdAt": Date,
  "updatedAt": Date,
  "lastLoginAt": Date
}

// Survey Responses Collection
{
  "_id": ObjectId,
  "userId": String,
  "name": String,
  "gender": String,
  "birthDay": String,
  "birthMonth": String,
  "birthYear": String,
  "purpose": String,
  "studyTime": String,
  "completedAt": Date,
  "createdAt": Date,
  "updatedAt": Date
}

// Auth Sessions Collection
{
  "_id": ObjectId,
  "userId": String,
  "email": String,
  "refreshToken": String,
  "accessToken": String,
  "tokenExpiresAt": Date,
  "deviceId": String,
  "deviceName": String,
  "isActive": Boolean,
  "createdAt": Date,
  "lastActiveAt": Date
}

// Password Resets Collection
{
  "_id": ObjectId,
  "email": String,
  "resetCode": String,
  "expiresAt": Date,
  "isUsed": Boolean,
  "createdAt": Date
}
```

## Step 4: Flutter App Configuration

### 4.1 Get App ID
1. In your Realm app, go to "App Settings"
2. Copy the "App ID"
3. Replace the App ID in `lib/app/data/config/realm_config.dart`:

```dart
static const String appId = 'your-copied-app-id-here';
```

### 4.2 Initialize Services
Add to your `main.dart`:

```dart
import 'package:snaplingua/app/data/services/service_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database services
  await DatabaseInitializer.initialize();

  runApp(MyApp());
}
```

### 4.3 Update App Dependencies
Run:
```bash
flutter pub get
dart run build_runner build
```

## Step 5: Testing the Setup

### 5.1 Test User Registration
```dart
final authService = AuthService.to;
final result = await authService.register(
  email: 'test@example.com',
  password: 'password123',
  name: 'Test User',
);
```

### 5.2 Test Survey Submission
```dart
final surveyService = SurveyService.to;
final result = await surveyService.submitSurvey(
  name: 'Test User',
  gender: 'Nam',
  birthDay: '15',
  birthMonth: '03',
  birthYear: '1995',
  purpose: 'Học tập',
  studyTime: '30-60 phút',
);
```

## Step 6: Production Configuration

### 6.1 Security Hardening
1. **Network Access**: Restrict IP addresses to your server IPs
2. **User Permissions**: Create specific roles with minimal required permissions
3. **Environment**: Switch to Production environment
4. **Backup**: Enable continuous backup
5. **Monitoring**: Set up alerts for errors and performance

### 6.2 Performance Optimization
1. **Indexes**: Create indexes on frequently queried fields:
   ```javascript
   // On users collection
   db.users.createIndex({ "email": 1 })
   db.users.createIndex({ "userId": 1 })

   // On survey_responses collection
   db.survey_responses.createIndex({ "userId": 1 })
   db.survey_responses.createIndex({ "completedAt": -1 })
   ```

2. **Connection Pooling**: Configure appropriate connection limits
3. **Caching**: Implement client-side caching for frequently accessed data

### 6.3 Monitoring and Analytics
1. Enable Atlas monitoring
2. Set up custom alerts for:
   - High connection count
   - Slow queries
   - Error rates
3. Use Atlas Data Explorer for data analysis

## Step 7: Data Migration (If Needed)

If you have existing user data, create migration scripts:

```javascript
// Example migration script
db.users.updateMany(
  { surveyCompleted: { $exists: false } },
  { $set: { surveyCompleted: false, level: 1, xp: 0, streak: 0 } }
);
```

## Troubleshooting

### Common Issues
1. **Connection timeouts**: Check network access whitelist
2. **Authentication failures**: Verify App ID and user credentials
3. **Sync not working**: Check sync rules and user permissions
4. **Schema validation errors**: Ensure data types match the schema

### Debug Commands
```bash
# Check Realm logs
flutter logs

# Verify dependencies
flutter doctor

# Clean and rebuild
flutter clean && flutter pub get
```

## Support and Resources
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Realm Flutter SDK](https://docs.mongodb.com/realm/sdk/flutter/)
- [MongoDB University](https://university.mongodb.com/) - Free courses

## Environment Variables
Create a `.env` file for sensitive configuration:
```
MONGODB_APP_ID=your-app-id
MONGODB_API_KEY=your-api-key
MONGODB_SECRET=your-secret
```

## Backup Strategy
1. Enable continuous backup in Atlas
2. Set up regular exports for critical data
3. Test restore procedures regularly
4. Document recovery procedures

This setup provides a robust, scalable database solution for your SnapLingua app with proper user management, survey handling, and real-time synchronization capabilities.