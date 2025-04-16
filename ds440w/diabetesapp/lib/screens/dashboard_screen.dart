import 'package:flutter/material.dart';
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
      // Add a drawer with Logout
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
        // Also put a logout icon button on the AppBar
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
          : Row(
              children: [
                // Left panel: form + history
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PredictionForm(onResult: _onNewResult),
                        if (lastResult != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            '${lastResult!['risk_level']} — ${lastResult!['message']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...List<Widget>.from(
                            (lastResult!['recommendations'] as List)
                                .map((tip) => ListTile(
                                      leading: const Icon(Icons.check),
                                      title: Text(tip),
                                    )),
                          ),
                          const Divider(height: 40),
                        ],
                        const Text('History',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        ...history.map((r) => ListTile(
                              title: Text(
                                  '${r.createdAt.toLocal().toString().split(" ")[0]} → ${r.result == 1 ? 'Diabetic' : 'Not Diabetic'}'),
                              subtitle: Text(r.recommendations.join('; ')),
                            )),
                      ],
                    ),
                  ),
                ),

                // Right panel: chart
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PredictionChart(data: history),
                  ),
                ),
              ],
            ),
    );
  }
}
