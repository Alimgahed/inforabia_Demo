// import 'package:binna/Reuseable_Component/mywidget.dart';
// import 'package:binna/agent_scrren/hr/fingerprint/fingerprint_controller.dart';
// import 'package:binna/agent_scrren/hr/hr_request/all_hr_request.dart';
// import 'package:binna/agent_scrren/hr/hr_request/hr_request.dart';
// import 'package:binna/notfiaction/local_notafications.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Fingerprint extends StatelessWidget {
//   Fingerprint({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: GetBuilder<UserAttendanceConntroller>(
//         init: UserAttendanceConntroller(),
//         builder: (controller) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               custom_appbar("Check In & Check Out".tr, back: true),
//               SizedBox(
//                 height: 80,
//               ),
//               Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Background Circle
//                     Container(
//                       height: 140,
//                       width: 140,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: const Color.fromARGB(255, 242, 242, 242),
//                       ),
//                     ),
//                     // Progress Indicator
//                     Obx(() {
//                       return SizedBox(
//                         height: 140,
//                         width: 140,
//                         child: LateCheckInProgress(
//                           lateProgress: controller
//                               .lateprogress.value, // Late progress (red)
//                           remainingProgress: controller
//                               .progress.value, // Remaining progress (green)
//                         ),
//                       );
//                     }),

//                     // Centered Text
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "You have spent".tr,
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         Obx(() {
//                           return Text(
//                             "${controller.spent.value}",
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           );
//                         }),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Use Obx to bind reactive variables here

//               Obx(() {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${'Remaining hours'.tr}: ${controller.remainingTime}', // Bind remaining time here
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 );
//               }),
//               // Remaining time - use Obx to update

//               const SizedBox(height: 20),
//               if (controller.attendance?.loginTime == null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () async {
//                       await controller.getCurrentPosition();
//                       controller.check_in(
//                           lat: controller.currentPosition.value?.latitude ?? -1,
//                           lng: controller.currentPosition.value?.longitude ??
//                               -1);
//                       LocalNotification.showDailyNotification();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Color(0xFFE7C498)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.fingerprint),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text('Check-in'.tr),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               if (controller.attendance?.logoutTime == null &&
//                   controller.attendance?.loginTime != null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () async {
//                       await controller.getCurrentPosition();
//                       controller.check_out(
//                           lat: controller.currentPosition.value?.latitude ?? -1,
//                           lng: controller.currentPosition.value?.longitude ??
//                               -1);
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Color(0xFFE7C498)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.fingerprint),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text('Check-out'.tr),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: () {
//                         Get.to(() => excuse());
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                                 color:
//                                     const Color.fromARGB(255, 197, 197, 197))),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Color(0xffF8EDE0),
//                                 child: Icon(
//                                   Icons.file_copy_outlined,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text('Leave Req'.tr,
//                                   style: TextStyle(
//                                     color: Color(0xFF191919),
//                                     fontSize: 16,
//                                     fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.40,
//                                     letterSpacing: -0.50,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: () {
//                         Get.to(() => vacation_req());
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                                 color:
//                                     const Color.fromARGB(255, 197, 197, 197))),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Color(0xffF8EDE0),
//                                 child: Icon(
//                                   Icons.telegram_outlined,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text("Vacation Req.".tr,
//                                   style: TextStyle(
//                                     color: Color(0xFF191919),
//                                     fontSize: 16,
//                                     fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.40,
//                                     letterSpacing: -0.50,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               customButton(
//                   text: 'My Requests'.tr,
//                   onPressed: () {
//                     Get.to(
//                       () => AllHrRequest(),
//                     );
//                   })
//             ],
//           );
//         },
//       ),
//     );
//   }

// }

// class LateCheckInProgress extends StatelessWidget {
//   final double lateProgress; // Progress for the late time (red)
//   final double remainingProgress; // Progress for the remaining time (green)

//   const LateCheckInProgress({
//     Key? key,
//     required this.lateProgress,
//     required this.remainingProgress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(140, 140), // Set the size of the circle
//       painter: LateProgressPainter(lateProgress, remainingProgress),
//     );
//   }
// }

// class LateProgressPainter extends CustomPainter {
//   final double lateProgress; // Late progress (red)
//   final double remainingProgress; // Remaining progress (green)

//   LateProgressPainter(this.lateProgress, this.remainingProgress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 12; // Width of the stroke

//     // Start drawing from the top of the circle (12 o'clock position)
//     double startAngle = -3.14159 / 2; // Start at 12 o'clock (top of the circle)

//     // Draw the red part (late) - based on late progress
//     paint.color = Colors.red;
//     canvas.drawArc(
//       Rect.fromCircle(
//         center: Offset(size.width / 2, size.height / 2),
//         radius: size.width / 2,
//       ),
//       startAngle, // Start at the top (12 o'clock)
//       2 * 3.14159 * lateProgress, // Sweep based on late progress (in radians)
//       false,
//       paint,
//     );

//     // Draw the green part (remaining) - after the red arc
//     paint.color = Color(0xFFE7C498);
//     canvas.drawArc(
//       Rect.fromCircle(
//         center: Offset(size.width / 2, size.height / 2),
//         radius: size.width / 2,
//       ),
//       startAngle + 2 * 3.14159 * lateProgress, // Start where the red arc ends
//       2 *
//           3.14159 *
//           remainingProgress, // Sweep based on remaining progress (in radians)
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // Repaint when progress changes
//   }
// }
