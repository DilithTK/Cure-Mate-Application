class Order {
  final String id;
  final String date;
  final String status;
  final List<String> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
  });
}