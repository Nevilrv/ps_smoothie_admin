String formattedDate(String data) {
  DateTime date = DateTime.parse(data);

  String dateTime = "${date.day}/${date.month}/${date.year}";

  return dateTime;
}
