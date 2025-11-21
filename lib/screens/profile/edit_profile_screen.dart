// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pizzahub/utils/api.dart';
import '../../services/user_service.dart';
import '../../utils/user_preferences.dart'; // 🔹 for stored userId

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? userId;

  // 🔹 Password visibility state
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // fetch user on screen open
  }

  Future<void> _loadUserData() async {
    userId = await UserPreferences.getUserId(); // get saved userId
    final user = await UserService.fetchUser(int.parse(userId!));

    if (user != null) {
      setState(() {
        usernameController.text = user.username;
        firstnameController.text = user.firstname;
        lastnameController.text = user.lastname;
        emailController.text = user.email;
        phoneController.text = user.phoneno;
        passwordController.text = user.password!;
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final message = await UserService.updateUser(
        userId: int.parse(userId!),
        username: usernameController.text,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        email: emailController.text,
        phoneno: phoneController.text,
        password: passwordController.text.isNotEmpty
            ? passwordController.text
            : null,
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (message.toLowerCase().contains("success")) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure && !_isPasswordVisible,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            // 🔹 Add visibility toggle only for password field
            suffixIcon: obscure
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter $label" : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.orange,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: const NetworkImage(
                          "$baseUrl/images/profilePic.jpg",
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 20,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Input fields
                _buildTextField("Username", usernameController),
                _buildTextField("First Name", firstnameController),
                _buildTextField("Last Name", lastnameController),
                _buildTextField(
                  "Email",
                  emailController,
                  keyboard: TextInputType.emailAddress,
                ),
                _buildTextField(
                  "Phone No",
                  phoneController,
                  keyboard: TextInputType.phone,
                ),
                _buildTextField("Password", passwordController, obscure: true),

                const SizedBox(height: 10),

                // Save Button
                ElevatedButton(
                  onPressed: isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(width: 15),
                            Text(
                              'Saving...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
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
