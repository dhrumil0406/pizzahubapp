import 'package:flutter/material.dart';
import '../../../services/address_service.dart';
import '../../../utils/user_preferences.dart'; // ✅ Import preferences

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedType = "Home";
  bool _isLoading = false; // ✅ loader state
  String? userId; // ✅ nullable until loaded

  final TextEditingController nameController = TextEditingController();
  final TextEditingController homeNoController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId(); // ✅ load user id when screen opens
  }

  Future<void> _loadUserId() async {
    final id = await UserPreferences.getUserId();
    setState(() {
      userId = id;
    });
  }

  // ✅ Function to save address
  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      setState(() {
        _isLoading = true; // show loader
      });

      try {
        final result = await AddressService.addAddress(
          userid: int.parse(userId!), // ✅ use fetched userId
          addressType: selectedType,
          name: nameController.text,
          apartmentNo: homeNoController.text,
          buildingName: buildingController.text,
          streetArea: streetController.text,
          city: cityController.text,
        );

        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Error saving address")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false; // hide loader
        });
      }
    }
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Add New Address",
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
        child: userId == null
            ? const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        )
            : Column(
          children: [
            // Form takes all available height
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Save This Address As",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Address Type Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ["Home", "Office", "Other"].map((type) {
                          bool isSelected = selectedType == type;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = type;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25),
                      const Text(
                        "Add Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildLabeledField(
                        "Name",
                        "Enter your full name",
                        nameController,
                        TextInputType.name,
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              "Home No.",
                              "Ex: 22B",
                              homeNoController,
                              TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildLabeledField(
                              "Building",
                              "Building name",
                              buildingController,
                              TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      _buildLabeledField(
                        "Street/Area",
                        "Street name or area",
                        streetController,
                        TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 15),

                      _buildLabeledField(
                        "City",
                        "Enter your city",
                        cityController,
                        TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Save Button with Loader
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveAddress,
                  child: _isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Saving...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                      : const Text(
                    "Save Address",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Styled field like LoginScreen
  Widget _buildLabeledField(
      String label,
      String hint,
      TextEditingController controller,
      TextInputType inputType,
      ) {
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
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 14.0,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $label";
            }
            return null;
          },
        ),
      ],
    );
  }
}
