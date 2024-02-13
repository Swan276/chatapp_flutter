enum Status {
  online,
  offline;

  factory Status.fromName(String type) {
    return Status.values.firstWhere(
      (element) => element.name == type.toLowerCase(),
      orElse: () => Status.offline,
    );
  }

  String getName() => name.toUpperCase();
}
