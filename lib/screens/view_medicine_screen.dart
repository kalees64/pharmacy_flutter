import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class ViewMedicineScreen extends StatefulWidget {
  const ViewMedicineScreen({super.key, required this.medicine});

  final dynamic medicine;

  @override
  State<ViewMedicineScreen> createState() => _ViewMedicineScreenState();
}

class _ViewMedicineScreenState extends State<ViewMedicineScreen> {
  dynamic _medicine;

  @override
  void initState() {
    _medicine = widget.medicine;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle(_medicine["medicineName"]),
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("Brand Name"),
                subtitle: Text(
                  _medicine["medicineName"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Manufacturer Name"),
                subtitle: Text(
                  _medicine["manufacturerName"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Batch No"),
                subtitle: Text(
                  _medicine["batchNumber"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Dosage Form"),
                subtitle: Text(
                  _medicine["dosageForm"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Dose"),
                subtitle: Text(
                  _medicine["unitOfMeasurement"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Usage Indications"),
                subtitle: Text(
                  _medicine["usageIndications"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Compositions"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._medicine['compositions']
                        .map(
                          (item) => Text(
                            (_medicine["compositions"].indexOf(item) + 1)
                                    .toString() +
                                ". " +
                                item["activeIngredient"] +
                                " " +
                                item["strength"].toString() +
                                " " +
                                item["strengthScale"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
              ListTile(
                title: Text("Supplier Name"),
                subtitle: Text(
                  _medicine["supplierName"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Invoice No"),
                subtitle: Text(
                  _medicine["invoiceNumber"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Purchase Date"),
                subtitle: Text(
                  _medicine["purchaseDate"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Received Quantity"),
                subtitle: Text(
                  _medicine["receivedQuantity"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Purchase Price Per Unit"),
                subtitle: Text(
                  _medicine["purchasePricePerUnit"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Total Purchase Cost"),
                subtitle: Text(
                  _medicine["totalPurchaseCost"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Stock Location"),
                subtitle: Text(
                  _medicine["stockLocation"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Current Stack Quantity"),
                subtitle: Text(
                  _medicine["currentStackQuantity"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Minimum Stock Level"),
                subtitle: Text(
                  _medicine["minimumStockLevel"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Maximum Stock Level"),
                subtitle: Text(
                  _medicine["maximumStockLevel"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                title: Text("Drug Licence Number"),
                subtitle: Text(
                  _medicine["drugLicenseNumber"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Schedule Category"),
                subtitle: Text(
                  _medicine["scheduleCategory"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Manufacture Date"),
                subtitle: Text(
                  _medicine["manufacturedDate"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Expiry Date"),
                subtitle: Text(
                  _medicine["expiryDate"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Storage Conditions"),
                subtitle: Text(
                  _medicine["storageConditions"] ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                title: Text("Selling Price Per Unit"),
                subtitle: Text(
                  _medicine["sellingPricePerUnit"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Discount"),
                subtitle: Text(
                  _medicine["discount"].toString() + " %",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                title: Text("Taxes"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._medicine['taxDetails']
                        .map(
                          (item) => Text(
                            (_medicine["taxDetails"].indexOf(item) + 1)
                                    .toString() +
                                ". " +
                                item["taxType"] +
                                " " +
                                item["taxRate"].toString() +
                                " %",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: _medicine.entries.length,
              //     itemBuilder: (context, index) {
              //       final entry = _medicine.entries.elementAt(index);
              //       final key = entry.key;
              //       final value = entry.value ?? 'N/A'; // Show 'N/A' if null
              //       return ListTile(
              //         title: Text(key.toString().toUpperCase()),
              //         subtitle: Text(
              //           value.toString(),
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        )),
      )),
    );
  }
}
