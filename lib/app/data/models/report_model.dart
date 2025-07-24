class ReportModel {
  final String name;
  final String rt;
  final String rw;
  final String blok;
  final String category;

  ReportModel({
    required this.name,
    required this.rt,
    required this.rw,
    required this.blok,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'rt': rt,
    'rw': rw,
    'blok': blok,
    'category': category,
  };
}
