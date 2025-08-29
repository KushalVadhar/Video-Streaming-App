import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_streaming_app/pages/boardcast_screen.dart';
import 'package:video_streaming_app/resources/firestore_methods.dart';
import 'package:video_streaming_app/utils/utils.dart';
import 'package:video_streaming_app/widgets/custom_button.dart';
import 'package:video_streaming_app/widgets/custom_textfield.dart';

class GoLive extends StatefulWidget {
  const GoLive({super.key});

  @override
  State<GoLive> createState() => _GoLiveState();
}

class _GoLiveState extends State<GoLive> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    String channelId = await FirestoreMethods()
        .startLiveStream(context, _titleController.text, image);

    if (channelId.isNotEmpty) {
      showSnackBar(context, 'Live Stream is Started Successfully ');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BroadcastScreen(
                isBroadcaster: true,
                channelId: channelId,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uint8List? pickedImage = await pickImage();
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: image != null
                          ? SizedBox(
                              height: 300,
                              child: Image.memory(image!),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              dashPattern: [10, 4],
                              strokeCap: StrokeCap.round,
                              color: Colors.purpleAccent,
                              child: Container(
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open_outlined,
                                      color: Colors.purpleAccent,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Your Thumbnail',
                                      style: GoogleFonts.pacifico(
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: GoogleFonts.pacifico(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CustomTextField(
                          hintText: 'Enter title here',
                          controller: _titleController,
                          hintStyle: GoogleFonts.pacifico(
                            color: Colors.black,
                          ),
                          icon: null,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CustomButton(
                    onTap: goLiveStream,
                    text: 'Go Live',
                    textColor: Colors.white,
                    buttonColor: Colors.purpleAccent,
                    fontsize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
