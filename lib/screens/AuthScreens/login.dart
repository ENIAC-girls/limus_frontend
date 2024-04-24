import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:limus/screens/camera/photoScreen.dart';

List<CameraDescription> camerasList = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoginScreen());
}

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   List<CameraDescription> camerasList = [];


  @override
  void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availableCameras(),
      builder: (context, snapshot) {
        
          if(snapshot.hasData){
            camerasList = snapshot.data ?? [];
          }

        return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF23231A),
          primaryColor: const Color(0xFF84B48B),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF23231A),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFB2DE97)),
            bodyMedium: TextStyle(color: Color(0xFFB2DE97)),
          ),
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 370.0,
                    height: 370.0,
                    child: Image.asset(
                      'assets/limus_icon.png',
                      width: 500.0,
                      height: 500.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  LoginForm(camerasList: camerasList,),
                ],
              ),
            ),
          ),
        ),
      );
        
      },
    );
  }
}

class LoginForm extends StatefulWidget {

  final List<CameraDescription> camerasList;

  const LoginForm({super.key, required this.camerasList});


  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            cursorColor: const Color(0xFF84B48B),
            controller: _emailController,
            decoration: const InputDecoration(
              focusColor: Color(0xFF84B48B),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color(0xFF84B48B))),
              labelText: 'Email',
              labelStyle: TextStyle(color: Color(0xFF84B48B)),
              filled: true,
              fillColor: Color(0xFF2B2B2A),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            ),
            style: const TextStyle(color: Color(0xFF84B48B)),
            textCapitalization: TextCapitalization.none,
          ),
          const SizedBox(height: 10.0),
          TextField(
            cursorColor:  Color(0xFF84B48B),
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
               focusColor: Color(0xFF84B48B),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color(0xFF84B48B))),
              labelText: 'Password',
              labelStyle: TextStyle(color: Color(0xFF84B48B)),
              filled: true,
              fillColor: Color(0xFF2B2B2A),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            ),
            style: const TextStyle(color: Color(0xFF84B48B)),
          ),
          const SizedBox(height: 70.0),
          ElevatedButton(
            onPressed: () {
               Navigator.push(
                  context,
                  PageRouteBuilder(pageBuilder: (context, _ , __) => PhotosScreen(widget.camerasList)),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 0),
              padding: const EdgeInsets.all(7.0),
              backgroundColor: const Color(0xFF84B48B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Log In',
                style: TextStyle(color: Color(0xFF23231A), fontSize: 18.0),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFFB2DE97),
                  ),
                ),
                TextSpan(
                  text: 'Sign up now!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFFB2DE97),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFB2DE97),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}