enum UploadStep { overView, detail, perks, price, none }

extension ToUploadStepPar on String {
  UploadStep toUploadStepEnum() {
    return UploadStep.values.firstWhere((e) {
      return e.toString().toLowerCase() == toLowerCase();
    }, orElse: () => UploadStep.none); //return null if not found
  }
}

enum FreeDrop { yes, no, unselected }

extension ToFreeDrop on String {
  FreeDrop toFreeDrop() {
    return FreeDrop.values.firstWhere((e) {
      return e.toString().toLowerCase() == toLowerCase();
    }, orElse: () => FreeDrop.unselected); //return null if not found
  }
}
