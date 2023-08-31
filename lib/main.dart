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
    'title': 'Please check on Dicky!',
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
              //swipe animation control
              child: AppinioSwiper(
                backgroundCardsCount: 3,
                swipeOptions:
                //make the swipe just only can slide to right or left
                    const AppinioSwipeOptions.only(right: true, left: true),
                unlimitedUnswipe: true,
                //make the animation look like pan slide
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
                  //load the picture form firebase storage to swiper
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
      String deviceToken = 'd3OobwZbS8qEOuSLDWp1uQ:APA91bF_8YEw9m3gJDEGrbj3qz4rb97p8qNcNGr_lE0-aNgDmBoIr1vbw0XlTz9J7EY3uBmV4YT6xl41f-4PZiAcltCPFPIv9cbmBzwarPs6XmYLkGFl8ZYuTde8D5Y2RFqqVldEPMwj';
      sendNotification2(deviceToken,'https://firebasestorage.googleapis.com/v0/b/message-test-push-futter.appspot.com/o/sorry.jpg?alt=media&token=f8030c57-c345-445f-8803-da21527c8114');
    } else if (lastSwiped.startsWith('b')) {
      childNode = "returnB";
      String deviceToken = 'fxmp4ZbNTIutNK3oTD9nbE:APA91bFJ2tBnNOfLOAcXg-TzExJiwfLPywHQ06qYZpj3byDWMXxas7DzgTrOfgTFWcvNIFLnjv8cPgxwT797-5r69CqHMWvLF4QqIdCLPG5TDqgggXorRv1aNK7C1NDB7ljc4Coe2-XI';
      sendNotification2(deviceToken,'https://firebasestorage.googleapis.com/v0/b/message-test-push-futter.appspot.com/o/sorry.jpg?alt=media&token=f8030c57-c345-445f-8803-da21527c8114');
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

  // This function handles swipe actions. It takes two parameters: an index and a direction.
void _swipe(int index, AppinioSwiperDirection direction) {
    // If the swipe is to the right, then set the lastSwipeRight variable to true.
    // Otherwise, set it to false.
    if (direction == AppinioSwiperDirection.right) {
      lastSwipeRight = true;
    } else {
      lastSwipeRight = false;
    }

    // Adjust the index by subtracting 1.
    int adjustedIndex = index - 1;

    // Perform operations based on the swipe direction.
    if (direction == AppinioSwiperDirection.right) {
      // Determine the child node to use based on the image name.
      // Split the URL of the image at the adjustedIndex and take the last part (the image name).
      String imageName = imageUrls[adjustedIndex]
          .split('/')
          .last; 
      
      String childNode;
      // If the image name starts with 'a', set the childNode to "Parent Phone A".
      // Then, set the value at childNode in the database to the image URL.
      if (imageName.startsWith('a')) {
        childNode = "Parent Phone A";
        _database.ref().child(childNode).set(imageUrls[adjustedIndex]);
      } 
      // If the image name starts with 'b', set the childNode to "Parent Phone B".
      // Then, set the value at childNode in the database to the image URL.
      else if (imageName.startsWith('b')) {
        childNode = "Parent Phone B";
        _database.ref().child(childNode).set(imageUrls[adjustedIndex]);
      } 
      // If the image name does not start with 'a' or 'b', return from the function without doing anything.
      else {
        return;
      }

      // Remember the last image that was swiped.
      lastSwiped = imageName;
  }
 }
}

// This is a custom widget extending the StatelessWidget class in Flutter. 
// StatelessWidget is a widget that describes part of the user interface which can depend on configuration but doesn't need to maintain state.
class ReturnButton extends StatelessWidget {
  // This is a callback function to be called when the button is tapped.
  final VoidCallback onTap;
  // This is a widget to be displayed as a child of this widget.
  final Widget child;

  // This is a constructor for the ReturnButton widget. 
  // It takes two required parameters: a callback function and a child widget. 
  // It also takes an optional key parameter, which is used by Flutter to efficiently update widgets.
  const ReturnButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  // The build method describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // GestureDetector is a non-visual widget that provides gesture recognition. 
    // Here it is used to detect a tap gesture and call the provided onTap callback when the gesture is recognized.
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

// unswipeButton is a function that returns a ReturnButton widget.
// It takes a callback function as a parameter, which will be executed when the button is pressed.
Widget unswipeButton(VoidCallback onBackButtonPressed) {
  return ReturnButton(
    onTap: onBackButtonPressed,
    // The child of the ReturnButton is a Container widget, which is a convenient way to create a visual element with padding, margins, borders, and background color.
    // Here, the Container is given a height, width, and alignment, and is decorated as a circular shape with a semi-opaque red color.
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
