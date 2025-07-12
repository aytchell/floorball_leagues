import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';

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
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _seasonsText = '';
    });

    final uri = Uri.parse('https://www.saisonmanager.de/api/v2/init.json');

    try {
      log.info('Fetching "$uri"');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        log.info('Got response 200');
        final jsonData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        
        setState(() {
          // _seasonsText = apiResponse.seasons.map((season) => season.name as String).toList().join('\n');
           _seasonsText = apiResponse.gameOperations.map((gameOp) => gameOp.name as String).toList().join('\n');
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data. Status: ${response.statusCode}';
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

// Data model for the API response
class ApiSeasonInfo {
  int? id;
  String? name;
  bool current = false;

  ApiSeasonInfo({this.id, this.name, this.current = false});

  factory ApiSeasonInfo.fromJson(Map<String, dynamic> json) {
    return ApiSeasonInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      current: json['current'] as bool? ?? false,
    );
  }
}

class GameOperation {
  int? id;
  String? name;
  String? shortName;
  String? path;
  String? logoUrl;
  String? logoQuadUrl;

  GameOperation({
    this.id,
    this.name,
    this.shortName,
    this.path,
    this.logoUrl,
    this.logoQuadUrl,
  });

  factory GameOperation.fromJson(Map<String, dynamic> json) {
    return GameOperation(
      id: json['id'] as int?,
      name: json['name'] as String?,
      shortName: json['short_name'] as String?,
      path: json['path'] as String?,
      logoUrl: json['logo_url'] as String?,
      logoQuadUrl: json['logo_quad_url'] as String?,
    );
  }
}

class ApiResponse {
  final List<ApiSeasonInfo> seasons;
  final int? currentSeasonId;
  final List<GameOperation> gameOperations;

  ApiResponse({required this.seasons, this.currentSeasonId, required this.gameOperations});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var seasonsJson = json['seasons'] as List? ?? [];
    var operationsJson = json['game_operations'] as List? ?? [];
    return ApiResponse(
      seasons: seasonsJson
          .map((seasonJson) => ApiSeasonInfo.fromJson(seasonJson))
          .toList(),
      currentSeasonId: json['current_season_id'] as int?,
      gameOperations: operationsJson
          .map((operationJson) => GameOperation.fromJson(operationJson))
          .toList(),
    );
  }
}
