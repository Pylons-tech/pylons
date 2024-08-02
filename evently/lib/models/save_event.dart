class SaveEvent {
  final int? id;
  final String? nftName;
  final String? hostName;
  final String? thumbnail;

  final String? step;

  SaveEvent(
    this.id,
    this.nftName,
    this.hostName,
    this.thumbnail,
    this.step,
  );
}
