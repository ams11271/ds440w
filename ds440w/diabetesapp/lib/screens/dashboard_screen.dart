import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth_service.dart';
import '../api_service.dart';
import '../models/prediction_record.dart';
import '../widgets/prediction_form.dart';
import '../widgets/prediction_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<PredictionRecord> history = [];
  Map<String, dynamic>? lastResult;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => loading = true);
    try {
      final raw = await getWithAuth('/predictions/history');
      history = raw.map((j) => PredictionRecord.fromJson(j)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Load error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  void _onNewResult(Map<String, dynamic> res) {
    lastResult = res;
    _loadHistory();
    setState(() {});
  }

  void _logout() async {
    await AuthService.logout();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel: form + history
                  Expanded(
                    flex: 2,
                    child: ListView(
                      children: [
                        // Prediction form
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: PredictionForm(onResult: _onNewResult),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Latest result callout
                        if (lastResult != null)
                          Card(
                            color: Colors.green.shade50,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${lastResult!['risk_level']} — ${lastResult!['message']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...List<Widget>.from(
                                    (lastResult!['recommendations'] as List)
                                        .map((tip) => Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.check,
                                                    size: 20,
                                                    color:
                                                        Colors.green.shade700),
                                                const SizedBox(width: 8),
                                                Expanded(child: Text(tip)),
                                              ],
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // History panel
                        Text('History',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        ExpansionPanelList.radio(
                          children: history.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final rec = entry.value;
                            return ExpansionPanelRadio(
                              value: idx,
                              headerBuilder: (_, __) => ListTile(
                                dense: true,
                                title: Text(
                                  '${DateFormat.yMd().format(rec.createdAt)} → ${rec.result == 1 ? 'Diabetic' : 'Not Diabetic'}',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              body: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rec.recommendations
                                      .map((tip) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Row(
                                              children: [
                                                Icon(Icons.arrow_right,
                                                    size: 18,
                                                    color: Colors.blueGrey),
                                                const SizedBox(width: 6),
                                                Expanded(child: Text(tip)),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right panel: chart
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: PredictionChart(data: history),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
