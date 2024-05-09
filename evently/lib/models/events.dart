class Event {
  Event({
    required this.eventName,
    required this.hostName,
    required this.url,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.description,
    required this.isFreeDrop,
    required this.numberOfTickets,
    required this.price,
    required this.listOfPerks,
  });

  final String eventName;

  final String hostName;

  final String url;

  final String startDate;

  final String endDate;

  final String startTime;

  final String endTime;

  final String location;

  final String description;

  final String isFreeDrop;

  final String numberOfTickets;

  final String price;

  final List<String> listOfPerks;
}
