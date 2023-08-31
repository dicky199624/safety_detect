import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'onboarding_page.dart';

void main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Create a reference to the Firebase Realtime Database
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // Listen for changes in the the value of "Phone A" in the real-time database
  // "Phone A" refers to the first mobile phone and is the location in the real-time database where the pictures of the first mobile phone are stored.
  databaseReference.child('Phone A').onValue.listen((event) {
    // The phone token here uses the phone token obtained when the code in the user's phone is run.
    String deviceToken = 'd3OobwZbS8qEOuSLDWp1uQ:APA91bF_8YEw9m3gJDEGrbj3qz4rb97p8qNcNGr_lE0-aNgDmBoIr1vbw0XlTz9J7EY3uBmV4YT6xl41f-4PZiAcltCPFPIv9cbmBzwarPs6XmYLkGFl8ZYuTde8D5Y2RFqqVldEPMwj';
    // Get image url from real-time database
    String image = event.snapshot.value as String;
    // Insert the picture url and the phone token into the method of sending the notification
    //Firebase Cloud Messaging need token to identify the recipient of notifications
    sendNotification(deviceToken,image);
  });

  // Listen for changes in the the value of "Phone B" in the real-time database
  // "Phone B" refers to the second mobile phone and is the location in the real-time database where the pictures of the first mobile phone are stored.
  databaseReference.child('Phone B').onValue.listen((event) {
    // The phone token here uses the phone token obtained when the code in the user's phone is run.
    String deviceToken = 'fxmp4ZbNTIutNK3oTD9nbE:APA91bFJ2tBnNOfLOAcXg-TzExJiwfLPywHQ06qYZpj3byDWMXxas7DzgTrOfgTFWcvNIFLnjv8cPgxwT797-5r69CqHMWvLF4QqIdCLPG5TDqgggXorRv1aNK7C1NDB7ljc4Coe2-XI';
    // Get image url from real-time database
    String image = event.snapshot.value as String;
    // Insert the picture url and the phone token into the method of sending the notification
    //Firebase Cloud Messaging need token to identify the recipient of notifications
    sendNotification(deviceToken,image);
  });

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the app using the CupertinoApp widget
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: DetectPage(),
    );
  }
}

class DetectPage extends StatefulWidget {
  const DetectPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DetectPage> createState() => _DetectPage();
}

// A method to send hint notifications using Firebase Cloud Messaging service
void sendNotification(String deviceToken, String image) async {
  // Create the hint notification message
  var notification = {
    'title': 'Please check on Jason!',
    'body': 'Our AI suggests that he might be in danger~',
    'image':image,
  };

  // Create the message payload
  var message = {
    'notification': notification,
    'to': deviceToken,
  };

  // Send the notification message
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAKTjV25c:APA91bGJRFuc70VDSve2lloMJ-xYEnoKBGLQ2NJ-RuIJD51we_mlSvznVm3GrXqDNf1QEWhmlOMVz80pNxBT6w3xG7orLrOh3dt-2MoEpiaNMuYUfrG_DUa5ju5MHQlzi11E12Qr7yFX',
  };

  var response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(message),
  );
}

// A method to send apologize notifications using Firebase Cloud Messaging service
void sendNotification2(String deviceToken, String image) async {
  // Create the apologize notification message
  var notification = {
    'title': 'Sorry is our mistake!',
    'body': 'You baby is safety~',
    'image':image,
  };

  // Create the message payload
  var message = {
    'notification': notification,
    'to': deviceToken,
  };

  // Send the notification message
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAKTjV25c:APA91bGJRFuc70VDSve2lloMJ-xYEnoKBGLQ2NJ-RuIJD51we_mlSvznVm3GrXqDNf1QEWhmlOMVz80pNxBT6w3xG7orLrOh3dt-2MoEpiaNMuYUfrG_DUa5ju5MHQlzi11E12Qr7yFX',
  };

  var response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(message),
  );
}

class _DetectPage extends State<DetectPage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  List<String> imageUrls = [];
  int currentIndex = 0;
  double initialX = 0.0;
  String lastSwiped = "";
  bool lastSwipeRight = false;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    getImageUrls();
  }

  Future<void> getImageUrls() async {
    // Retrieve image URLs from Firebase Storage
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.ListResult result = await storage.ref().listAll();
    List<String> urls = [];
    for (var ref in result.items) {
      // Get the download URL for each image
      String downloadURL = await ref.getDownloadURL();
      urls.add(downloadURL);
    }
    setState(() {
      // Update the imageUrls list with the retrieved URLs
      imageUrls = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: AppinioSwiper(
                backgroundCardsCount: 3,
                swipeOptions:
                    const AppinioSwipeOptions.only(right: true, left: true),
                unlimitedUnswipe: true,
                maxAngle: 1,
                controller: controller,
                onSwiping: (AppinioSwiperDirection direction) {
                  debugPrint(direction.toString());
                },
                onSwipe: _swipe,
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 0,
                ),
                cardsCount: imageUrls.length,
                cardsBuilder: (BuildContext context, int index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 40,
              right: 40,
              child: unswipeButton(_onBackButtonPressed),
            ),
            Positioned.fill(
              // onboarding page
              child: SplitScreenPage(),
            ),
            // Positioned.fill(
            //   child: SplitScreenPage(),
            // ),
          ],
        ),
      ),
    );
  }

  // Used to switch back to the previous picture
  void _onBackButtonPressed() {
    if (lastSwipeRight) {
    // Unswipe the card
    controller.unswipe();

    String childNode;

    if (lastSwiped.startsWith('a')) {
      childNode = "returnA";
      String image = "https://firebasestorage.googleapis.com/v0/b/message-test-push-futter.appspot.com/o/sorry.jpg?alt=media&token=beb2874c-5872-4980-8497-b77091c7fd4d";
      String deviceToken = 'd3OobwZbS8qEOuSLDWp1uQ:APA91bF_8YEw9m3gJDEGrbj3qz4rb97p8qNcNGr_lE0-aNgDmBoIr1vbw0XlTz9J7EY3uBmV4YT6xl41f-4PZiAcltCPFPIv9cbmBzwarPs6XmYLkGFl8ZYuTde8D5Y2RFqqVldEPMwj';
      sendNotification2(deviceToken,image);
    } else if (lastSwiped.startsWith('b')) {
      childNode = "returnB";
      String image = "https://firebasestorage.googleapis.com/v0/b/message-test-push-futter.appspot.com/o/sorry.jpg?alt=media&token=beb2874c-5872-4980-8497-b77091c7fd4d";
      String deviceToken = 'fxmp4ZbNTIutNK3oTD9nbE:APA91bFJ2tBnNOfLOAcXg-TzExJiwfLPywHQ06qYZpj3byDWMXxas7DzgTrOfgTFWcvNIFLnjv8cPgxwT797-5r69CqHMWvLF4QqIdCLPG5TDqgggXorRv1aNK7C1NDB7ljc4Coe2-XI';
      sendNotification2(deviceToken,image);
    } else {
      return;
    }

    // Repeatedly update Firebase nodes using a for loop
    for (int i = 0; i < 10; i++) {
      _database.ref().child(childNode).set('$i');
    }
  }
    else{
      controller.unswipe();
    }
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    if (direction == AppinioSwiperDirection.right) {
      lastSwipeRight = true;
    } else {
      lastSwipeRight = false;
    }
    // Adjust the index if necessary
    int adjustedIndex = index - 1;

    // Perform operations based on the swipe direction
    if (direction == AppinioSwiperDirection.right) {
      // Determine the child node to use based on the image name
      String imageName = imageUrls[adjustedIndex]
          .split('/')
          .last; // Extract the image name from the URL
      String childNode;
      if (imageName.startsWith('a')) {
        childNode = "Phone A";
        _database.ref().child(childNode).set(imageUrls[adjustedIndex]);
      } else if (imageName.startsWith('b')) {
        childNode = "Phone B";
        _database.ref().child(childNode).set(imageUrls[adjustedIndex]);
      } else {
        return;
      }

      // Remember last swiped image
      lastSwiped = imageName;
    }
  }
}

class ReturnButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const ReturnButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

Widget unswipeButton(VoidCallback onBackButtonPressed) {
  return ReturnButton(
    onTap: onBackButtonPressed,
    child: Container(
      height: 105,
      width: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withOpacity(0.5),
      ),
      child: const Icon(
        Icons.rotate_left_rounded,
        color: Colors.white,
        size: 110,
      ),
),
);
}