class RealmConfig {
  // MongoDB Atlas configuration
  static const String appId = 'your-mongodb-atlas-app-id';
  static const String baseUrl = 'https://realm.mongodb.com';

  // Atlas App configuration for Vietnam region
  static const String atlasAppName = 'snaplingua-app';
  static const String databaseName = 'snaplingua_db';

  // Collections
  static const String usersCollection = 'users';
  static const String surveysCollection = 'survey_responses';
  static const String authSessionsCollection = 'auth_sessions';
  static const String passwordResetsCollection = 'password_resets';

  // Sync configuration
  static const bool enableSync = true;
  static const int syncTimeoutMs = 30000; // 30 seconds

  // Development settings
  static const bool useLocalRealm = true; // Set to false in production
  static const String localRealmPath = 'snaplingua_local.realm';
}

// MongoDB Atlas setup instructions
/*
SETUP INSTRUCTIONS FOR MONGODB ATLAS + REALM DEVICE SYNC:

1. Create MongoDB Atlas Account:
   - Go to https://cloud.mongodb.com
   - Create an account or sign in
   - Create a new project called "SnapLingua"

2. Create Database:
   - Click "Create Database"
   - Choose "Shared" (free tier)
   - Select region closest to Vietnam (Singapore recommended)
   - Database name: snaplingua_db

3. Create Realm App:
   - Go to App Services tab
   - Click "Create a New App"
   - App name: snaplingua-app
   - Link to your Atlas cluster

4. Enable Device Sync:
   - Go to Device Sync tab
   - Enable Flexible Sync
   - Set up authentication (Email/Password)
   - Configure sync rules

5. Set up Authentication:
   - Go to Authentication tab
   - Enable Email/Password authentication
   - Configure password reset settings
   - Add custom user data (optional)

6. Configure Schema:
   - Go to Schema tab
   - Define schemas for User, SurveyResponse, AuthSession, PasswordReset

7. Get App ID:
   - Copy the App ID from App Settings
   - Replace 'your-mongodb-atlas-app-id' in this config

8. Test Connection:
   - Use MongoDB Compass or Atlas Data Explorer
   - Verify sync is working

SECURITY CONFIGURATION:
- Set up IP whitelist in Atlas
- Configure user roles and permissions
- Enable audit logging for production
- Set up backup policies

VIETNAM-SPECIFIC CONSIDERATIONS:
- Use Singapore region for better latency
- Configure appropriate data residency settings
- Set up CDN for static assets if needed
*/