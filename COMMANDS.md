### Deploy firebase rules
`firebase deploy --only firestore:rules && firebase deploy --only storage`

### Update project config files
After this initial running of flutterfire configure, you need to re-run the command any time that you: 
- Start supporting a new platform in your Flutter app.
- Start using a new Firebase service or product in your Flutter app, especially if you start using sign-in with Google,
Crashlytics, Performance Monitoring, or Realtime Database.

`flutterfire configure --project=flat-on-fire-service`

### Android Key Store Commands
Android commands that are needed for understanding and getting keystore values 

`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore`


### Flutter building

`flutter clean && flutter build apk --split-per-abi`