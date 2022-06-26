import 'package:flutter/material.dart';
import 'package:snake_king/utils/db_helper.dart';

import '../models/high_score.dart';

class DeviceScores extends StatefulWidget {
  const DeviceScores({Key? key}) : super(key: key);

  @override
  State<DeviceScores> createState() => _DeviceScoresState();
}

class _DeviceScoresState extends State<DeviceScores> {
  bool isLoading = false;
  late List<Score> _scores;
  @override
  void initState() {
    super.initState();
    refreshScores();
  }

  refreshScores() async {
    setState(() {
      isLoading = true;
    });
    _scores = await DatabaseHelper.instance.getScores();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: const Text('Scores'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _scores.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            '${index + 1}.   ${_scores[index].score.toString()}',
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                                fontFamily: 'Girassol', color: Colors.white),
                          ),
                          subtitle: Text(
                            _scores[index].date,
                            style: const TextStyle(
                                fontFamily: 'Girassol', color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _deleteScore(_scores[index].id ?? 0);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white60,
                        )
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  _deleteScore(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are your sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () async {
              DatabaseHelper.instance.delete(id);
              Navigator.pop(context);
              await refreshScores();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          )
        ],
      ),
    );
  }
}
