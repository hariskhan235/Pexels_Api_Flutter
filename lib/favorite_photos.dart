import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:photos_app/data/repository.dart';
import 'databse/photo_db.dart';
import 'models/photo_model.dart';

class FavoritePhotosScreen extends StatefulWidget {
  const FavoritePhotosScreen({Key? key}) : super(key: key);

  @override
  State<FavoritePhotosScreen> createState() => _FavoritePhotosScreenState();
}

class _FavoritePhotosScreenState extends State<FavoritePhotosScreen> {
  DBHelper? dbHelper;
  late Future<List<PhotoModel>> photosList;

  //List<PhotoModel> photoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    photosList = dbHelper!.getAllPhotos();
  }

  @override
  Widget build(BuildContext context) {
    //final repository = Provider.of<Repository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Photos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: photosList,
              builder: (context, AsyncSnapshot<List<PhotoModel>> snapshot) {
                //final photos = snapshot.data ?? [];
                print(snapshot.data ?? []);
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      //final photo = photos[index];
                      //print(snapshot.data![index].image);
                      print(snapshot.data![index].id ?? '');
                      return Column(
                        children: [
                          // Slidable(
                          //   startActionPane: ActionPane(
                          //     motion: const DrawerMotion(),
                          //     extentRatio: 0.25,
                          //     children: [
                          //       SlidableAction(
                          //           label: 'Delete',
                          //           backgroundColor: Colors.transparent,
                          //           foregroundColor: Colors.black,
                          //           icon: Icons.delete,
                          //           onPressed: (context) {
                          //             setState(() {
                          //               dbHelper!.delete(
                          //                   snapshot.data![index].id ?? 0);
                          //               photosList = dbHelper!.getAllPhotos();
                          //               snapshot.data!
                          //                   .remove(snapshot.data![index]);
                          //             });
                          //           }),
                          //     ],
                          //   ),
                          //   endActionPane: ActionPane(
                          //     motion: const DrawerMotion(),
                          //     extentRatio: 0.25,
                          //     children: [
                          //       SlidableAction(
                          //         label: 'Delete',
                          //         backgroundColor: Colors.transparent,
                          //         foregroundColor: Colors.black,
                          //         icon: Icons.delete,
                          //         onPressed: (context) {
                          //           setState(() {
                          //             dbHelper!.delete(
                          //                 snapshot.data![index].id ?? 0);
                          //             photosList = dbHelper!.getAllPhotos();
                          //             snapshot.data!
                          //                 .remove(snapshot.data?[index]);
                          //           });
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          //   key: ValueKey<int>(snapshot.data?[index].id ?? 0),
                          Dismissible(
                            key: ValueKey<int>(snapshot.data![index].id ?? 0),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(snapshot.data![index].id ?? 0);
                                photosList = dbHelper!.getAllPhotos();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                subtitle: Text(
                                  snapshot.data![index].title,
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl: snapshot.data![index].image,
                                  height: 120,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    dbHelper!
                                        .delete(snapshot.data![index].id!);
                                    photosList = dbHelper!.getAllPhotos();
                                    setState(() {
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 5.0,
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
