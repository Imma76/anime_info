import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/model_data.dart';

final search = TextEditingController();
var data = AnimeData();
Future getData(ProviderReference ref) async {
  final result = await data.getAnimeData(animeName: search.text);

  return result;
}

final futureNotifier = FutureProvider((ref) => getData(ref));

class SecondHomePage extends ConsumerWidget {
//  const SecondHomePage({ Key? key }) : super(key: key);
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context, watch) {
    //  final wait = context.refresh(futureNotifier);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final provider = watch(futureNotifier);

    return SafeArea(
      child: Scaffold(
          body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Container(
            child: SizedBox(
              child: Column(
                children: [
                  SearchField(
                    hintText: 'search anime....',
                    controller: search,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () async {
                        if (connected) {
                          await data.getAnimeData(animeName: search.text);
                          context.refresh(futureNotifier);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('connect to the internet.'),
                              backgroundColor: Color(0xff2a166f),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // print(post);
                  Expanded(
                      child: provider.when(
                    data: (data) {
                      final post = data as List;
                      return ListView.builder(
                          itemCount: post.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FlipAnimation(
                                  curve: Curves.easeInCirc,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // color: Colors.red,
                                        ),
                                        width: width / 10,
                                        height: height / 2.3,
                                        child: Card(
                                          elevation: 3.0,
                                          child: Wrap(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: height / 4,
                                                      width: double.infinity,
                                                      // color: Colors.blue,
                                                      child: CachedNetworkImage(
                                                        fadeInCurve:
                                                            Curves.linear,
                                                        imageUrl: post[index]
                                                            ['image_url'],
                                                        width: double.infinity,
                                                        fit: BoxFit.fill,
                                                      )),
                                                  Text(
                                                    post[index]['synopsis'],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _launchInBrowser(
                                                            post[index]['url']),
                                                    child: Text('Read More',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        )),
                                                  ),
                                                  Text(
                                                    'score:${post[index]['score'].toString()}',
                                                  ),
                                                  Text(
                                                    post[index]['title'],
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    error: (e, stack) {
                      return Center(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: ScaleAnimation(
                                child: Center(
                              child: Text(
                                'please connect to the internet',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            )),
                          ),
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      )),
    );
  }
}

class SearchField extends StatelessWidget {
  final controller, hintText, suffixIcon, onChanged, validator;
  SearchField({
    this.controller,
    this.hintText,
    this.onChanged,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        //color: Colors.blue,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 60.0,
      width: 350.0,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: BorderSide(color: Color(0xfff6f6f6), width: 1.7)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: BorderSide(color: Color(0xfff6f6f6), width: 1.7)),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xffD4D8DC)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfff6f6f6), width: 1.7),
            borderRadius: BorderRadius.circular(11.0),
          ),
        ),
      ),
    );
  }
}
