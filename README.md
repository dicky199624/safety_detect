# safety_detect

firebase flow:

There are two methods for sending notifications: `sendNotification` and `sendNotification2`.

The first method, `sendNotification`, is used to send warning notifications to users. It is called when the detection personnel swipes the image to the right in the `safety_detect` function. The method requires the image URL and the mobile token as parameters.

The second method, `sendNotification2`, is used to send apology notifications to users. It is called when the detection personnel swipes the image to the right and then clicks the return button in the `safety_detect` function. (The previous image must be swiped to the right to invoke this method, and a parameter value is changed to true when the image is swiped to the right. This method will not be called if the parameter value is false, even if the return button is clicked.)

The agent's mobile receives images:
The program directly retrieves all images from Firebase storage and displays them on the agent's mobile.

Determining if the image is swiped to the right, indicating danger:
When the image is swiped to the right, the current image name is obtained. Then, it checks if the current image name contains "a" or "b". (In Firebase storage, "a" corresponds to the first user's uploaded image, and "b" corresponds to the second user's uploaded image.) If the image is identified as "a", the current image URL is obtained, and the current image URL and the mobile token of the first user's mobile (the mobile token is obtained using the "fcm_notification" software and manually copied to the `safety_detect` function) are passed to the `sendNotification` method to send a notification to the user's mobile. (Firebase's messaging service identifies the receiving mobile for broadcast notifications based on the mobile token of the user's mobile, so the mobile token needs to be obtained.)

Return button:
The return button only sends an apology notification if the previous image is swiped to the right. Otherwise, it simply switches back to the previous image. When the previous image is swiped to the right and the detection personnel click the return button, the `sendNotification2` method is called, and the image (which is manually copied into Firebase storage) and the mobile token (obtained manually using the "fcm_notification" software) are passed as parameters to the method.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
