import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];

  getBanners() {
    return _firestore
        .collection('banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _bannerImage.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 253, 251),
          //border: Border.all(),
          //borderRadius: BorderRadius.circular(15)
        ),
        child: PageView.builder(
            itemCount: _bannerImage.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                // borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: _bannerImage[index],
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer(
                    duration: Duration(seconds: 3), //Default value
                    interval: Duration(
                        seconds: 5), //Default value: Duration(seconds: 0)
                    color: Colors.white, //Default value
                    colorOpacity: 0, //Default value
                    enabled: true, //Default value
                    direction: ShimmerDirection.fromLTRB(), //Default Value
                    child: Container(
                      color: Color.fromARGB(255, 104, 207, 63),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              );
            }),
      ),
    );
  }
}
