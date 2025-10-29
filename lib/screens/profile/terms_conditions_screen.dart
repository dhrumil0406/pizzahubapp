import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Removed orange background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParagraph(
                "Welcome to PizzaHub! By accessing or using our application, "
                    "you agree to comply with and be bound by the following Terms and Conditions. "
                    "Please read them carefully before using the app."),

            _buildSectionTitle("1. Acceptance of Terms"),
            _buildParagraph(
                "By using PizzaHub, you confirm that you are at least 18 years old "
                    "and have the legal authority to enter into this agreement. "
                    "If you do not agree to these terms, please discontinue using the app immediately."),

            _buildSectionTitle("2. Ordering and Payment"),
            _buildParagraph(
                "All orders placed through PizzaHub are subject to restaurant availability. "
                    "Prices, discounts, and offers may change without prior notice. "
                    "Payment methods supported include Cash on Delivery and online payments "
                    "via integrated payment gateways. Once an order is confirmed, it cannot be canceled."),

            _buildSectionTitle("3. Delivery Policy"),
            _buildParagraph(
                "Delivery times may vary depending on order volume, location, and restaurant capacity. "
                    "PizzaHub strives to deliver orders promptly but cannot be held responsible "
                    "for delays caused by traffic, weather, or unforeseen circumstances."),

            _buildSectionTitle("4. User Responsibilities"),
            _buildParagraph(
                "You agree to provide accurate contact, address, and payment information. "
                    "Providing false details may result in order cancellation or account suspension. "
                    "You are responsible for maintaining the confidentiality of your login credentials."),

            _buildSectionTitle("5. Refunds and Cancellations"),
            _buildParagraph(
                "Refunds will only be processed for incorrect, missing, or damaged orders "
                    "after verification. Refunds may take 5–7 business days to reflect, "
                    "depending on your payment provider."),

            _buildSectionTitle("6. Data Privacy"),
            _buildParagraph(
                "PizzaHub respects your privacy. Any personal data collected is used solely "
                    "for order processing, delivery, and service improvement. We do not share "
                    "your information with third parties without consent."),

            _buildSectionTitle("7. Intellectual Property"),
            _buildParagraph(
                "All logos, content, and images within PizzaHub are owned by the company "
                    "and protected under copyright law. Unauthorized use is strictly prohibited."),

            _buildSectionTitle("8. Limitation of Liability"),
            _buildParagraph(
                "PizzaHub shall not be liable for any indirect, incidental, or consequential damages "
                    "arising from the use or inability to use our app, services, or products."),

            _buildSectionTitle("9. Modifications"),
            _buildParagraph(
                "PizzaHub reserves the right to update or modify these terms at any time. "
                    "Continued use of the app constitutes acceptance of any revised terms."),

            _buildSectionTitle("10. Contact Us"),
            _buildParagraph(
                "If you have any questions or concerns regarding these Terms & Conditions, "
                    "please reach out to us through the Contact Us section in the app."),

            const SizedBox(height: 24),
            Center(
              child: Text(
                "© ${DateTime.now().year} PizzaHub. All Rights Reserved.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
