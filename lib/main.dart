import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instergram_flutter/provider/user_provider.dart';
import 'package:instergram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instergram_flutter/responsive/responsive_screen.dart';
import 'package:instergram_flutter/responsive/web_screen_layout.dart';
import 'package:instergram_flutter/screeen/login_screen.dart';
import 'package:instergram_flutter/utilities/color.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDccALUhCkC0DRS_G-fl7vqBLO-NeDNcUM',
        appId: '1:554874149854:web:31c79c528a64f26e2a9b4f',
        messagingSenderId: '554874149854',
        projectId: 'instagram-clone-1515a',
        storageBucket: 'instagram-clone-1515a.appspot.com',
        measurementId: 'G-WGN1G5S08F',
        authDomain: 'instagram-clone-1515a.firebaseapp.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: ResponsiveLayout(
        //     mobileScreenLayout: MobileScreenLayout(),
        //     webScreenLayout: WebScreenLayout()),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
