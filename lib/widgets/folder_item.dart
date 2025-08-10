//
// // import 'package:flutter/material.dart';
// // import '../models/folder_model.dart';
// //
// // class FolderItem extends StatelessWidget {
// //   final FolderModel folder;
// //   const FolderItem({super.key, required this.folder});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.blue.shade100,
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       padding: const EdgeInsets.all(10),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.folder, size: 50, color: Colors.blue),
// //           const SizedBox(height: 10),
// //           Text(folder.name, style: const TextStyle(fontSize: 16)),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import '../models/folder_model.dart';
//
// class FolderItem extends StatelessWidget {
//   final FolderModel folder;
//   final bool locked;  // new parameter
//
//   const FolderItem({super.key, required this.folder, this.locked = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.blue.shade100,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.folder, size: 50, color: Colors.blue),
//               const SizedBox(height: 10),
//               Text(folder.name, style: const TextStyle(fontSize: 16)),
//             ],
//           ),
//         ),
//         if (locked)
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Icon(
//               Icons.lock,
//               color: Colors.redAccent,
//               size: 20,
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/folder_model.dart';

class FolderItem extends StatelessWidget {
  final FolderModel folder;
  final bool locked;

  const FolderItem({super.key, required this.folder, this.locked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (locked)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade100.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.lock,
                  color: Colors.redAccent.shade700,
                  size: 20,
                ),
              ),
            ),
          Icon(
            Icons.folder,
            size: 60,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 12),
          Text(
            folder.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

