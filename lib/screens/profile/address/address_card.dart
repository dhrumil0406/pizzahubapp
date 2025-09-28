import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final VoidCallback onDelete;

  const AddressCard({super.key, required this.address, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // allow delete button to overflow
      children: [
        // Card container
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address["addressType"] ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${address["name"] ?? ""}, "
                      "${address["apartmentNo"] ?? ""} "
                      "${address["buildingName"] ?? ""}, "
                      "${address["streetArea"] ?? ""}, "
                      "${address["city"] ?? ""}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating Delete Button
        Positioned(
          top: 7,
          right: 10,
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 22,
              icon: const Icon(Icons.delete, color: Colors.orange),
              onPressed: onDelete,
            ),
          ),
        ),
      ],
    );
  }
}
