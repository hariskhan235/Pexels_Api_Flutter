import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:photos_app/data/memory_repository.dart';
import 'package:photos_app/data/repository.dart';
import 'package:photos_app/screens/favorite_photos.dart';
import 'package:photos_app/screens/full_screen_image.dart';
import 'package:photos_app/services/pexels_api_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  final repository = MemoryRepository();
  await repository.init();
  runApp(
    MyApp(
      repository: repository,
    ),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (rec) {
      log(
        int.parse('${rec.level.name}: ${rec.time}: ${rec.message}'),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final Repository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          lazy: false,
          create: (_) => repository,
          dispose: (_, Repository repository) => repository.close(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> images = [];

  Future fetchPhotos() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
          headers: {
            'Authorization':
                '563492ad6f917000010000018b31ba9eabe941bdb522ae8c4742c12e'
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseResult = jsonDecode(response.body);
        setState(() {
          images = responseResult['photos'];
        });
        // print(images);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    PixelsApiService pixelsApiService = PixelsApiService();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photos',
          style: TextStyle(color: Colors.white),
        ),
        //centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritePhotosScreen(),
                ),
              );
            },
            child: const Text(
              'Go To Favorites',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchPhotos(),
        builder: (context, snapshot) {
          // final PhotoModel images = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    //childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10.0),
                itemBuilder: (context, index) {
                  //final photoModel = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      //print(images[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            title: images[index]['alt'],
                            image: images[index]['src']['large2x'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(
                              images[index]['src']['tiny'],
                            ),
                            fit: BoxFit.cover),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: SizedBox(
                              width: 50,
                              child: Text(
                                images[index]['alt'],
                                maxLines: 3,
                                style: const TextStyle(color: Colors.amber),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
