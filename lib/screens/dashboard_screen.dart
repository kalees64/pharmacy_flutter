import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/screens/add_medition_screen.dart';
import 'package:pharmacy_flutter/screens/login_screen.dart';
import 'package:pharmacy_flutter/screens/view_medicine_screen.dart';
import 'package:pharmacy_flutter/services/medicine_service.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.token, this.user});

  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MedicineService medicineService = MedicineService();

  List<dynamic> _medicines = [];

  @override
  void initState() {
    fetchMedicines();
    // TODO: implement initState
    super.initState();
  }

  void fetchMedicines() async {
    try {
      final resData = await medicineService.getAllMedicines(widget.token!);
      print('Medicines: $resData');
      setState(() {
        _medicines = resData;
      });
    } catch (e) {
      print("--Error fetching medicines: $e");
    }
  }

  void _navigateToAddMedicinePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => AddMeditionScreen(
                  user: widget.user,
                  token: widget.token,
                )));
  }

  void _logout() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    await localStorage.remove('token');
    await localStorage.remove('user');
    await localStorage.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/pharmacy_logo.png'),
        title: navBarTitle("Medicines"),
        actions: [
          Tooltip(
            message: "Add Medicine",
            child: IconButton(
              icon: Icon(Icons.local_pharmacy_outlined),
              onPressed: () {
                _navigateToAddMedicinePage();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          )
        ],
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h2("Medicines (${_medicines.length.toString()})"),
                  if (_medicines.isEmpty)
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  if (_medicines.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                          itemCount: _medicines.length,
                          itemBuilder: (ctx, index) {
                            final medicine = _medicines[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        ViewMedicineScreen(medicine: medicine),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    medicine['medicineName'] ??
                                        'Unknown Medicine',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      'Manufacturer: ${medicine['manufacturerName'] ?? 0}'),
                                ),
                              ),
                            );
                          }),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
