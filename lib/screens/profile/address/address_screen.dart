import 'package:flutter/material.dart';
import 'add_location_screen.dart';
import 'address_card.dart';
import '../../../services/address_service.dart';
import '../../../utils/user_preferences.dart'; // ✅ Import for shared prefs

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Future<List<Map<String, dynamic>>> _futureAddresses;
  String? userId; // Nullable until loaded

  @override
  void initState() {
    super.initState();
    _initializeAddresses();
  }

  Future<void> _initializeAddresses() async {
    userId = await UserPreferences.getUserId(); // ✅ Fetch from SharedPreferences
    if (userId != null) {
      _loadAddresses();
    }
  }

  void _loadAddresses() {
    setState(() {
      _futureAddresses = AddressService.fetchAddresses(int.parse(userId!));
    });
  }

  Future<void> _removeAddress(int addressId) async {
    try {
      final res = await AddressService.removeAddress(addressId);
      // print(addressId);
      if (res['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address removed successfully")),
        );
        _loadAddresses(); // refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Failed to remove address")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "My Addresses",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: const Icon(Icons.add_location_alt, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLocationScreen(),
                  ),
                ).then((_) => _loadAddresses()); // refresh on return
              },
            ),
          ),
        ],
      ),

      body: userId == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange)) // wait for SharedPref
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureAddresses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }

          final addresses = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return AddressCard(
                address: address,
                onDelete: () => _removeAddress(address['addressid']),
              );
            },
          );
        },
      ),
    );
  }
}
