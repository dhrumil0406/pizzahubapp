class AuthService {
  static Future<bool> loginUser(String email, String password) async {
    // Simulated API response
    await Future.delayed(const Duration(seconds: 2));

    // Example: match with dummy data
    if (email == 'test@pizza.com' && password == '123456') {
      return true;
    }
    return false;
  }

  static Future<bool> registerUser(Map<String, String> userData) async {

    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
}