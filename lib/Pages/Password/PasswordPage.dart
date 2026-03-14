import 'package:billbook/Widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import '../../Constant/app_theme.dart';
import '../Home/HomePage.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _securityController = TextEditingController();

  bool _isFirstTime = false;
  bool _obscureText = true;
  late Box _box;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox('passwordBox');
    setState(() {
      _isFirstTime = !_box.containsKey('userPassword');
    });
  }

  void _savePassword() {
    String pwd = _passwordController.text.trim();
    String confirm = _confirmController.text.trim();

    if (pwd.isEmpty || confirm.isEmpty) {
      _showSnack("Password cannot be empty");
      return;
    }
    if (pwd != confirm) {
      _showSnack("Passwords do not match");
      return;
    }
    _box.put('userPassword', pwd);
    _showSnack("Password created successfully!");
    _goToHome();
  }

  void _login() {
    String entered = _passwordController.text.trim();
    String saved = _box.get('userPassword', defaultValue: '');
    if (entered == saved) {
      _goToHome();
    } else {
      _showSnack("Incorrect Password");
      _passwordController.clear();
    }
  }

  void _forgotPassword() {
    _securityController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Answer the security question to reset password."),
            SizedBox(height: 12.h),
            TextField(
              controller: _securityController,
              decoration: InputDecoration(
                hintText: "Favourite Person",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                String answer = _securityController.text.trim().toLowerCase();
                if (answer == 'milan') {
                  _box.delete('userPassword');
                  Navigator.pop(context);
                  setState(() {
                    _isFirstTime = true;
                    _passwordController.clear();
                    _confirmController.clear();
                  });
                  _showSnack("You can now set a new password.");
                } else {
                  _showSnack("Incorrect answer. Cannot reset.");
                }
              },
              child: const Text("Verify"))
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // App Logo
                Image.asset(
                  'assets/logo.png',
                  width: 100.w,
                  height: 100.h,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Bill Book",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: AppTheme.cardShadow),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isFirstTime ? Icons.lock_open : Icons.lock,
                        size: 60.sp,
                        color: AppTheme.primary,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        _isFirstTime
                            ? "Set your numeric password"
                            : "Enter your password",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark),
                      ),
                      SizedBox(height: 20.h),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: "Enter 4-6 digit password",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none),
                          counterText: "",
                        ),
                      ),
                      if (_isFirstTime) ...[
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _confirmController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: "Confirm password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none),
                            counterText: "",
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: _isFirstTime ? _savePassword : _login,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 40.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r))),
                        child: Text(
                          _isFirstTime ? "Set Password" : "Unlock",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (!_isFirstTime)
                        TextButton(
                            onPressed: _forgotPassword,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.red),
                            ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}