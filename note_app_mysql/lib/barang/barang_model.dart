class Barang {
  final String kdBrg;
  final String nmBrg;
  final int hrgBeli;
  final int hrgJual;
  final int stok;

  Barang({
    required this.kdBrg,
    required this.nmBrg,
    required this.hrgBeli,
    required this.hrgJual,
    required this.stok,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kdBrg: json['KdBrg'],
      nmBrg: json['NmBrg'],
      hrgBeli: int.parse(json['HrgBeli'].toString()),
      hrgJual: int.parse(json['HrgJual'].toString()),
      stok: int.parse(json['Stok'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KdBrg': kdBrg,
      'NmBrg': nmBrg,
      'HrgBeli': hrgBeli.toString(),
      'HrgJual': hrgJual.toString(),
      'Stok': stok.toString(),
    };
  }
}
