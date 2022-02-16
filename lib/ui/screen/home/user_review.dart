import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/ui/widgets/snackbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class UserReview extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final UserData user;
  const UserReview({Key? key, required this.user}) : super(key: key);
  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  FireService fireService = FireService();
  int rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.user.review;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewTextController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(),
            SizedBox(
              height: height * 0.5,

              //Wrapped the iterative review list tiles with StreamBuilder to get realtime data
              child: StreamBuilder<QuerySnapshot>(
                  stream: FireService().reviewsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          if (data["review"] != 0) {
                            return Card(
                              child: ListTile(
                                trailing: RatingBar.builder(
                                  minRating: 1,
                                  itemSize: 20,
                                  unratedColor: Colors.white,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  initialRating:
                                      double.parse(data['review'].toString()),
                                  onRatingUpdate: (double value) {},
                                ),
                                title: Text(data['userName']),
                                subtitle: Text(data['reviewText']),
                              ),
                            );
                          } else {
                            return Card();
                          }
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    minRating: 1,
                    itemSize: 40,
                    unratedColor: Colors.white,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    updateOnDrag: true,
                    initialRating: rating.toDouble(),
                    onRatingUpdate: (rate) => setState(() {
                      rating = rate.toInt();
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: TextField(
                      maxLines: 2,
                      controller: reviewTextController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "Review",
                          hintText: "Type your experience"),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        //update the new reviews to the database
                        fireService
                            .updateReview(widget.user.uid, rating,
                                reviewTextController.text)
                            .then((value) async {
                          showSnackbar(
                              context, "Thank you for giving your feedback.");
                        });
                      },
                      child: const Text("Submit")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
