import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
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
          imageName: widget.imageUrl,
          options: RequestSizeOptions.RESIZE_FIT,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  saveImage() async {
    GallerySaver.saveImage(widget.imageUrl, albumName: 'MyPhotoAppMedia')
        .then((value) {
      if (value == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image Saved')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image Saved Error')));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = widget.imageUrl;
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
    GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      //appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.imageUrl), fit: BoxFit.cover),
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
            // Positioned(
            //   top: MediaQuery.of(context).size.height * 0.010,
            //   child: Image(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.5,
            //     image: NetworkImage(widget.imageUrl),
            //     loadingBuilder:
            //         (context, child, ImageChunkEvent? loadingProgress) {
            //       if (loadingProgress == null) return child;
            //       return Center(
            //         child: CircularProgressIndicator(
            //           value: loadingProgress.expectedTotalBytes != null
            //               ? loadingProgress.cumulativeBytesLoaded /
            //                   loadingProgress.expectedTotalBytes!
            //               : null,
            //         ),
            //       );
            //     },
            //   ),
            // ),
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
