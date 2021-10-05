import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/edit_profile/image_source_bottom_sheet.dart';
import 'package:pylons_wallet/pages/edit_profile/social_media_screen.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _userIDController =
      TextEditingController(text: "cosmos1xfkoi9863893j90387jwksmsk0w");

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 44,
        leading: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/icons/close.png",
              fit: BoxFit.contain,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pylons Account",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done,
              color: kBlue,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenSize.width(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  _ProfileImageWidget(
                    onEditTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          isDismissible: true,
                          builder: (_) => const ImageSourceBottomSheet());
                    },
                  ),
                  const VerticalSpace(20),
                  const _UserNameWidget(username: "Linda"),
                  const VerticalSpace(20),
                  _TextInputWidget(
                    title: 'Bio',
                    hint: 'Add Bio',
                    controller: _bioController,
                    noOfLines: 3,
                  ),
                  const VerticalSpace(20),
                  _TextInputWidget(
                    title: 'Website',
                    hint: 'Add Website',
                    controller: _websiteController,
                  ),
                  const VerticalSpace(20),
                  _WalletAddressTextInputWidget(
                    title: 'User ID',
                    hint: 'User ID',
                    controller: _userIDController,
                    enabled: false,
                  ),
                  const VerticalSpace(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SocialMediaScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/circled_link.png',
                            width: 20,
                          ),
                          const HorizontalSpace(10),
                          const Text(
                            "Link to Social Media",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffF1F1F2),
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/gcloud.png',
                            width: 20,
                          ),
                          const HorizontalSpace(10),
                          const Text(
                            "Export account to Google Cloud",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffF1F1F2),
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/log_out.png',
                            width: 20,
                          ),
                          const HorizontalSpace(10),
                          const Text(
                            "Log out",
                            style: TextStyle(color: kBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileImageWidget extends StatelessWidget {
  const _ProfileImageWidget({
    Key? key,
    required this.onEditTap,
    this.imageUrl = kImage,
  }) : super(key: key);

  final String imageUrl;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          shape: BoxShape.circle),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(3000),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/pylons_logo.png',
              image: imageUrl,
              width: screenSize.width(percent: 0.30),
              height: screenSize.width(percent: 0.30),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            // alignment: Alignment.bottomRight,
            bottom: 0,
            right: 10,
            child: InkWell(
              onTap: onEditTap,
              child: Container(
                // margin: EdgeInsets.only(right: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: kPeach,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  "assets/icons/edit.png",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _UserNameWidget extends StatelessWidget {
  final String username;

  const _UserNameWidget({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          username,
          style: const TextStyle(fontSize: 16),
        ),
        const HorizontalSpace(4),
        InkWell(
          onTap: () {},
          child: Image.asset(
            "assets/icons/edit.png",
            width: 30,
            height: 30,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

class _TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final int noOfLines;
  final bool enabled;

  const _TextInputWidget(
      {Key? key,
      required this.title,
      required this.hint,
      required this.controller,
      this.noOfLines = 1,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(title),
        ),
        const VerticalSpace(4),
        TextFormField(
          minLines: noOfLines,
          maxLines: noOfLines,
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xffC4C4C4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xffC4C4C4)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xffC4C4C4)),
              ),
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Color(0xffC4C4C4), fontWeight: FontWeight.w500),
              fillColor: const Color(0xffFBFBFB)),
        ),
      ],
    );
  }
}

class _WalletAddressTextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final int noOfLines;
  final bool enabled;

  const _WalletAddressTextInputWidget(
      {Key? key,
      required this.title,
      required this.hint,
      required this.controller,
      this.noOfLines = 1,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(title),
        ),
        const VerticalSpace(4),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            debugPrint("main");
          },
          child: TextFormField(
            minLines: noOfLines,
            maxLines: noOfLines,
            controller: controller,
            enabled: false,
            style: const TextStyle(color: Color(0xffC4C4C4)),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xffC4C4C4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xffC4C4C4)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xffC4C4C4)),
                ),
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                filled: true,
                hintText: hint,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                      border:  Border(
                          right: BorderSide(color: Color(0xffC4C4C4)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/link.png',
                        width: 24,
                      ),
                    ],
                  ),
                ),
                suffixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                       Text("Copy", style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),

                hintStyle: const TextStyle(
                    color: Color(0xffC4C4C4), fontWeight: FontWeight.w500),
                fillColor: const Color(0xffFBFBFB)),
          ),
        ),
      ],
    );
  }
}
