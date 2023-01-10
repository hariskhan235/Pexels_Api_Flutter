import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photos_app/data/repository.dart';
import 'package:photos_app/databse/photo_db.dart';
import 'package:photos_app/models/photo_model.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/wallpaper.dart';

class FullScreenImage extends StatefulWidget {
  //final PhotoModel photoModel;
  final String title;
  final String image;

  const FullScreenImage({Key? key, required this.title,required this.image}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  DBHelper? dbHelper;
  late List<PhotoModel> photosList;

  String home = "Home Screen",
      lock = 'Lock Screen',
      both = 'Both',
      system = 'System';
  Stream<String>? progressString;
  String? res;
  bool downloading = false;

  var result = 'Waiting to set Wallpaper';

  String? image;

  setWallpaper() async {
    try {
      await Wallpaper.homeScreen(
          imageName: widget.image ?? '',
          options: RequestSizeOptions.RESIZE_FIT,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  saveImage() async {
    GallerySaver.saveImage(widget.image ?? '',
            albumName: 'MyPhotoAppMedia')
        .then((value) {
      if (value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image Saved'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image Saved Error'),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    image = widget.image;
    dbHelper = DBHelper();
  }

  Future<void> downloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(
      image.toString(),
    );
    progressString!.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print('Data Received:$data');
    }, onDone: () async {
      setState(() {
        downloading = false;
      });
    }, onError: (error) async {
      downloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context);
    GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      //appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  widget.image ?? ''),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.02,
              //alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.03,
                backgroundColor: Colors.black,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              //alignment: Alignment.topCenter,
              top: 30,
              left: 50,
              right: 50,
              child: IconButton(
                onPressed: () async {
                  //var id = const Uuid().v1();
                  //String id = DateTime.now().toIso8601String();
                  // var photoModel =
                  //     PhotoModel(title: 'title', image: widget.imageUrl,id:1);
                  // dbHelper!.addToFavorites(photoModel).then((value) {
                  //   print('Data Added Successfully');
                  //   print(value.image);
                  //   print(value.image.runtimeType);
                  //   setState(() {
                  //     //photosList.
                  //     photosList?.add(photoModel);
                  //     //photosList.add()
                  //     //print(value.toMap());
                  //   });
                  // });
                  var photoModel = PhotoModel(title: widget.title, image: widget.image);
                  // repository
                  //     .addToFavorites(photoModel);
                  dbHelper?.insert(photoModel).then((value) {
                    print('Data added Successfully');
                    setState(() {
                      // dbHelper!.getAllPhotos();
                      //photosList.add(value);
                    });
                  });

                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: MediaQuery.of(context).size.height * 0.03,
                child: IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2,
                            bottom: MediaQuery.of(context).size.height * 0.3),
                        decoration: const BoxDecoration(),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: AlertDialog(
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: saveImage,
                                child: const Text('Save To Gallery'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  return await downloadImage(context)
                                      .then((value) async {
                                    await Wallpaper.homeScreen(
                                      options: RequestSizeOptions.RESIZE_FIT,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    );
                                  }).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text('Set as wallpaper'),
                              ),
                              const ElevatedButton(
                                onPressed: null,
                                child: Text('Share'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Positioned(
            //   left: MediaQuery.of(context).size.width * 0.05,
            //   right: MediaQuery.of(context).size.width * 0.05,
            //   bottom: MediaQuery.of(context).size.height * 0.05,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CircleAvatar(
            //         backgroundColor: Colors.black,
            //       ),
            //       CircleAvatar(
            //         backgroundColor: Colors.black,
            //       ),
            //       CircleAvatar(
            //         backgroundColor: Colors.black,
            //       ),
            //       CircleAvatar(
            //         backgroundColor: Colors.black,
            //       ),
            //     ],
            //   ),
            // ),

            downloading == true
                ? const Positioned(
                    child: Text('Setting WallPaper'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget imageDownloadDialog() {
    return Container(
      decoration: const BoxDecoration(),
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 20.0),
            Text(
              "Setting Wallpaper: $res",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
