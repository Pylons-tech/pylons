import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Model3dViewer extends StatefulWidget {
  final bool isFile;
  final String? path;

  const Model3dViewer({Key? key, required this.isFile, required this.path}) : super(key: key);

  @override
  Model3dViewerState createState() => Model3dViewerState();
}

class Model3dViewerState extends State<Model3dViewer> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return Stack(
            children: [
              Container(
                child: modelViewer,
              ),
              if (value == true)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: EaselAppTheme.kBlack,
                )
              else
                const SizedBox()
            ],
          );
        });
  }

  ModelViewer? modelViewer;

  @override
  void initState() {
    super.initState();
    modelViewer = ModelViewer(
      src: widget.isFile ? 'file://${widget.path!}' : widget.path!,
      autoRotate: false,
      backgroundColor: EaselAppTheme.kBlack,
      relatedJs: "",
      onProgress: (status) {
        if (status == 1) {
          Future.delayed(const Duration(seconds: 1), () {
            isLoading.value = false;
          });
        }
      },
    );
  }
}
