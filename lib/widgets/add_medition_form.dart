import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pharmacy_flutter/constants/environment.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';
import 'package:http/http.dart' as http;

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({super.key, this.token, this.user, this.userRole});

  final dynamic userRole;
  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taxTypeController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();

  final TextEditingController _activeIngredientController =
      TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  String _selectedStrengthScale = 'mg';

  List<Map<String, dynamic>> _compositions = [];
  List<Map<String, dynamic>> _taxes = [];
  final Map<String, dynamic> _formData = {
    'prescriptionRequired': false,
  };
  final List<String> dosageForms = [
    'Tablet',
    'Capsule',
    'Caplet',
    'Pill',
    'Lozenge',
    'Powder',
    'Granules',
    'Solution',
    'Suspension',
    'Syrup',
    'Elixir',
    'Tincture',
    'Cream',
    'Ointment',
    'Gel',
    'Paste',
    'Injection',
    'IV Infusion',
    'Inhaler',
    'Nebulizer Solution',
    'Nasal Spray',
    'Nasal Drops',
    'Patch',
    'Lotion',
    'Suppository',
    'Enema',
    'Eye Drops',
    'Ear Drops',
    'Buccal Tablet',
    'Sublingual Tablet',
  ];
  final List<String> unitMeasurements = [
    'mcg', // Micrograms
    'mg', // Milligrams
    'g', // Grams
    'kg', // Kilograms
    'IU', // International Units
    'ml', // Milliliters
    'L', // Liters
    'mEq', // Milliequivalents
    'mmol', // Millimoles
    '%', // Percentage (for creams, ointments, solutions)
    'units', // Standard units (e.g., insulin)
    'puffs', // For inhalers
    'drops', // For eye/ear/nasal drops
    'tablets', // Number of tablets
    'capsules', // Number of capsules
    'suppositories', // Rectal/Vaginal dosage forms
    'sprays', // Number of sprays (nasal/oral)
    'ampoules', // Injectable dosage forms
    'vials', // Injectable dosage containers
    'patches', // For transdermal patches
    'hours', // For infusion rates (e.g., mg/hour)
    'ml/hour', // Infusion rates
    'mg/kg', // Weight-based dosing (e.g., per kg of body weight)
    'mcg/kg', // Microgram per kilogram
  ];

  bool isLoading = false;

  @override
  void initState() {
    print("User Token : ${widget.token}");
    // TODO: implement initState
    super.initState();
  }

  void _calculateTotalCost() {
    final receivedQuantity =
        int.tryParse(_formData['receivedQuantity'] ?? '0') ?? 0;
    final purchasePrice =
        double.tryParse(_formData['purchasePricePerUnit'] ?? '0.0') ?? 0.0;
    final totalCost = receivedQuantity * purchasePrice;
    setState(() {
      _formData['totalPurchaseCost'] = totalCost.toString();
    });
  }

  void _addTax() {
    final taxType = _taxTypeController.text.trim();
    final taxRate = _taxRateController.text.trim();

    if (taxType.isEmpty || taxRate.isEmpty) {
      _showAlert('Please fill out both Tax Type and Tax Rate.');
      return;
    }

    final parsedTaxRate = num.tryParse(taxRate);
    if (parsedTaxRate == null) {
      _showAlert('Tax Rate must be a valid number.');
      return;
    }

    setState(() {
      _taxes.add({"taxType": taxType, "taxRate": parsedTaxRate});
      _taxTypeController.clear();
      _taxRateController.clear();
    });
  }

  void _addComposition() {
    final activeIngredient = _activeIngredientController.text.trim();
    final strength = _strengthController.text.trim();

    if (activeIngredient.isEmpty || strength.isEmpty) {
      _showAlert('Please fill out both Active Ingredient and Strength.');
      return;
    }

    final parsedStrength = num.tryParse(strength);
    if (parsedStrength == null) {
      _showAlert('Strength must be a valid number.');
      return;
    }

    setState(() {
      _compositions.add({
        "activeIngredient": activeIngredient,
        "strength": parsedStrength,
        "strengthScale": _selectedStrengthScale
      });

      _activeIngredientController.clear();
      _strengthController.clear();
      _selectedStrengthScale = unitMeasurements.first;
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> payload() {
    return {
      "medicineName": _formData['medicineName'],
      "manufacturerName": _formData['manufacturer'],
      "batchNumber": _formData['batchNo'],
      "qrCodeUrl": "",
      "usageIndications": _formData['usageIndications'],
      "dosageForm": _formData['dosageForm'],
      "unitOfMeasurement": _formData['unitOfMeasurement'],

      // Compositions
      "compositions": _compositions,

      // Supply and purchase
      "supplierName": _formData['supplierName'],
      "invoiceNumber": _formData['invoiceNo'],
      "purchaseDate": _formData['purchaseDate'],
      "receivedQuantity": int.tryParse(_formData['receivedQuantity'] ?? '0'),
      "purchasePricePerUnit":
          double.tryParse(_formData['purchasePricePerUnit'] ?? '0.0'),
      "totalPurchaseCost":
          (double.tryParse(_formData['purchasePricePerUnit'] ?? '0.0') ?? 0.0) *
              (int.tryParse(_formData['receivedQuantity'] ?? '0') ?? 0),

      // Stock and inventory details
      "stockLocation": _formData['stockLocation'],
      "currentStockQuantity":
          int.tryParse(_formData['currentStockQuantity'] ?? '0'),
      "minimumStockLevel": int.tryParse(_formData['minStockLevel'] ?? '0'),
      "maximumStockLevel": int.tryParse(_formData['maxStockLevel'] ?? '0'),

      // Expiry and storage information
      "manufacturedDate": _formData['manufactureDate'],
      "expiryDate": _formData['expiryDate'],
      "storageConditions": _formData['storageConditions'],

      // Sales and pricing details
      "sellingPricePerUnit":
          double.tryParse(_formData['sellingPricePerUnit'] ?? '0.0'),
      "discount": double.tryParse(_formData['discount'] ?? '0.0'),

      // Tax details
      "taxDetails": _taxes,

      // Regulatory information
      "drugLicenseNumber": _formData['drugLicenceNumber'],
      "scheduleCategory": _formData['scheduleCategory'],
      "prescriptionRequired": _formData['prescriptionRequired'] ?? false,
    };
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    if (_compositions.isEmpty || _taxes.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return _showAlert('Please fill out both Composition and Tax fields.');
    }

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return _showAlert('Please fill all mandatory fields.');
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newMedicine = payload();
      final jsonData = jsonEncode(newMedicine);

      try {
        // Generate QR code image
        final qrPainter = QrPainter(
          data: jsonData,
          version: QrVersions.auto,
          gapless: true,
        );

        final ui.Image qrImage = await qrPainter.toImage(200);

        // Convert QR code image to bytes
        final ByteData? byteData =
            await qrImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) {
          throw Exception('Failed to convert QR image to bytes');
        }

        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Encode QR code image as a base64 data URL
        final qrCodeDataUrl = "data:image/png;base64,${base64Encode(pngBytes)}";

        print('QR Code Data URL: $qrCodeDataUrl');

        newMedicine['qrCodeUrl'] = qrCodeDataUrl;

        print('--Medicine data: $newMedicine');

        final url = Uri.parse('$apiUrl/medicines');

        final jsonEncodedMedicineData = json.encode(newMedicine);

        try {
          final res = await http.post(url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${widget.token}',
              },
              body: jsonEncodedMedicineData);

          final resData = jsonDecode(res.body);

          print('Response Data: $resData');

          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print('Error add medicine : $e');
        }

        setState(() {
          isLoading = false;
        });

        setState(() {
          _formData.clear();
          _compositions = [];
          _taxes = [];
        });
        _formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medicine data added')),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate QR code: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              h2("1. Basic Details"),
              _buildTextField('Medicine Name', 'medicineName', true,
                  keyBoardType: TextInputType.text),
              _buildTextField('Manufacturer', 'manufacturer', true,
                  keyBoardType: TextInputType.text),
              _buildTextField('Batch No', 'batchNo', true,
                  keyBoardType: TextInputType.text),
              _buildTextField('Usage Indications', 'usageIndications', true,
                  keyBoardType: TextInputType.text),
              _buildDropdown('Dosage Form', 'dosageForm', dosageForms, true),
              _buildDropdown('Unit of Measurement', 'unitOfMeasurement',
                  unitMeasurements, true),
              const SizedBox(height: 20),

              h2(("2. Compositions")),
              TextFormField(
                controller: _activeIngredientController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Active Ingredient',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _strengthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Strength',
                  border: OutlineInputBorder(),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStrengthScale.isNotEmpty
                    ? _selectedStrengthScale
                    : null,
                items: unitMeasurements.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStrengthScale = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Strength Scale',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: _addComposition,
                child: const Text('Add Composition'),
              ),
              _buildCompositionTable(),
              const SizedBox(height: 20),

              h2(("3. Supply And Purchase Details")),
              _buildTextField('Supplier Name', 'supplierName', true,
                  keyBoardType: TextInputType.text),
              _buildTextField('Invoice No', 'invoiceNo', true,
                  keyBoardType: TextInputType.text),
              _buildDatePicker('Purchase Date', 'purchaseDate', true),
              _buildTextField('Received Quantity', 'receivedQuantity', true,
                  onChanged: (value) => _calculateTotalCost(),
                  keyBoardType: TextInputType.number),
              _buildTextField(
                  'Purchase Price per Unit', 'purchasePricePerUnit', true,
                  onChanged: (value) => _calculateTotalCost(),
                  keyBoardType: TextInputType.number),
              // _buildTextField('Total Purchase Cost', 'totalPurchaseCost', true,
              //     enabled: false),
              const SizedBox(height: 20),

              h2(("4. Stock And Invertory Details")),
              _buildTextField('Stock Location', 'stockLocation', true,
                  keyBoardType: TextInputType.text),
              _buildTextField(
                  'Current Stock Quantity', 'currentStockQuantity', true,
                  keyBoardType: TextInputType.number),
              _buildTextField('Min Stock Level', 'minStockLevel', true,
                  keyBoardType: TextInputType.number),
              _buildTextField('Max Stock Level', 'maxStockLevel', true,
                  keyBoardType: TextInputType.number),
              const SizedBox(height: 20),

              h2(("5. Regulatory Information")),
              _buildTextField('Drug Licence Number', 'drugLicenceNumber', true,
                  keyBoardType: TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField('Schedule Category', 'scheduleCategory', true,
                  keyBoardType: TextInputType.text),
              const SizedBox(height: 10),
              _buildCheckbox('Prescription Required', 'prescriptionRequired'),
              const SizedBox(height: 20),

              h2(("6. Expiry And Storage Information")),
              _buildDatePicker('Manufacture Date', 'manufactureDate', true),
              _buildDatePicker('Expiry Date', 'expiryDate', true),
              _buildTextField('Storage Conditions', 'storageConditions', true,
                  keyBoardType: TextInputType.text),
              const SizedBox(height: 20),

              h2(("7. Sales And Pricing Details")),
              _buildTextField(
                  'Selling Price Per Unit', 'sellingPricePerUnit', true,
                  keyBoardType: TextInputType.number),
              _buildTextField('Discount', 'discount', true,
                  keyBoardType: TextInputType.number),
              const SizedBox(height: 20),

              h2(("8. Tax Details")),
              TextFormField(
                controller: _taxTypeController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Tax Type',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _taxRateController,
                decoration: const InputDecoration(
                  labelText: 'Tax Rate (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _addTax,
                child: const Text('Add Tax'),
              ),
              // Table header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('S.No', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Tax Type',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Tax Rate',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              // Table rows
              Column(
                children: _taxes.asMap().entries.map((entry) {
                  final index = entry.key + 1; // S.No starts from 1
                  final tax = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(index.toString()),
                        Text(tax['taxType']),
                        Text('${tax['taxRate'].toString()}%'),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _taxes.removeAt(entry.key);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              if (!isLoading)
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: const Text('Submit'),
                ),
              if (isLoading) CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key, bool required,
      {String initialValue = '',
      bool enabled = true,
      Function(String)? onChanged,
      required TextInputType keyBoardType}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyBoardType,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      enabled: enabled,
      validator: (value) => (required && (value == null || value.isEmpty))
          ? 'This field is required'
          : null,
      onChanged: onChanged,
      onSaved: (value) => _formData[key] = value ?? '',
    );
  }

  Widget _buildDropdown(
      String label, String key, List<String> items, bool required) {
    return DropdownButtonFormField<String>(
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: _formData[key] ?? items.first,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) => setState(() => _formData[key] = value),
      validator: (value) => (required && (value == null || value.isEmpty))
          ? 'Please select a $label'
          : null,
      onSaved: (value) => _formData[key] = value ?? items.first,
    );
  }

  Widget _buildDatePicker(String label, String key, bool required) {
    final controller = TextEditingController(text: _formData[key] ?? '');

    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                _formData[key] = picked.toIso8601String().split('T')[0];
                controller.text = _formData[key]!;
              });
            }
          },
        ),
      ),
      validator: (value) => (required && (value == null || value.isEmpty))
          ? 'Please select a $label'
          : null,
      onSaved: (value) => _formData[key] = value ?? '',
    );
  }

  Widget _buildCheckbox(String label, String key) {
    // Ensure the field is initialized with false if it doesn't exist
    _formData[key] ??= false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: _formData[key],
          onChanged: (bool? value) {
            setState(() {
              _formData[key] = value ?? false;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  // Composition table
  Widget _buildCompositionTable() {
    if (_compositions.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Column(
      children: [
        // Table headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('S.No', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Ingredient', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Strength', style: TextStyle(fontWeight: FontWeight.bold)),
            // Text('Scale', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
        // Table rows
        Column(
          children: _compositions.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final composition = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(index.toString()),
                  Text(composition['activeIngredient']),
                  Text(
                      '${composition['strength'].toString()} ${composition['strengthScale']}'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _compositions.removeAt(entry.key);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
