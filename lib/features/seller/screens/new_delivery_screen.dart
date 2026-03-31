import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewDeliverySheet extends StatefulWidget {
  const NewDeliverySheet({super.key});

  @override
  State<NewDeliverySheet> createState() => _NewDeliverySheetState();
}

class _NewDeliverySheetState extends State<NewDeliverySheet> {
  // Mock data for selections
  String selectedCategory = 'Crustaceans';
  String selectedVehicle = 'Motorbike (Cold Box)';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Handles keyboard
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),

            Text("New Delivery", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
            Text("Assign a new shipment to your fleet", style: GoogleFonts.urbanist(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w600)),

            const SizedBox(height: 30),

            // --- SECTION 1: ITEM DETAILS ---
            _sectionHeader("Item Details", Icons.shopping_basket_outlined),
            const SizedBox(height: 16),
            _buildTextField("Product Name", "e.g. King Prawns"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField("Weight (kg)", "40", isNumber: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("Target Temp (°C)", "2.0", isNumber: true)),
              ],
            ),

            const SizedBox(height: 24),

            // --- SECTION 2: LOGISTICS ---
            _sectionHeader("Logistics & Fleet", Icons.local_shipping_outlined),
            const SizedBox(height: 16),
            _buildDropdown("Select Vehicle Type", ["Motorbike (Cold Box)", "Small Van (Refrigerated)", "Heavy Truck"], selectedVehicle, (val) => setState(() => selectedVehicle = val!)),
            const SizedBox(height: 12),
            _buildTextField("Pickup Location", "Old Port Station", icon: Icons.location_on_outlined),
            const SizedBox(height: 12),
            _buildTextField("Destination", "City Market Wholesaler", icon: Icons.flag_outlined),

            const SizedBox(height: 32),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text("CREATE SHIPMENT", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1A237E)),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {bool isNumber = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F8FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              suffixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String current, Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F8FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: current,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
              items: items.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: onChange,
            ),
          ),
        ),
      ],
    );
  }
}