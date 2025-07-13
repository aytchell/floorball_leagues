import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'restClient.dart';
import 'entryInfo.dart';

final log = Logger('Main');

void main() {
  setupLogging();
  runApp(MyApp());
}

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JsonFetcherPage(),
    );
  }
}

class JsonFetcherPage extends StatefulWidget {
  @override
  _JsonFetcherPageState createState() => _JsonFetcherPageState();
}

class _JsonFetcherPageState extends State<JsonFetcherPage> {
  String _seasonsText = '';
  bool _isLoading = false;
  String _errorMessage = '';


  Future<void> _fetchSeasons() async {
    final restClient = await RestClient.create();

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _seasonsText = '';
    });


    try {
      final entryInfo = await EntryInfo.fetchFromServer(restClient);
      if (entryInfo != null) {
        setState(() {
          // _seasonsText = entryInfo.seasons.map((season) => season.name as String).toList().join('\n');
           _seasonsText = entryInfo.gameOperations.map((gameOp) => gameOp.name as String).toList().join('\n');
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Fetcher'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchSeasons,
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
                  : Text('Fetch Seasons'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            if (_errorMessage.isNotEmpty) SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: TextEditingController(text: _seasonsText),
                  maxLines: null,
                  expands: true,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Seasons will appear here...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

