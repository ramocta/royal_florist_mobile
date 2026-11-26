
import 'package:flutter/material.dart';
import '../pesanan/pesanan_berhasil_page.dart';

class DetailPage extends StatefulWidget {
  final String status;
  final String catatan;

  const DetailPage({
    super.key,
    this.status = 'Menunggu Konfirmasi',
    this.catatan = '',
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Color brand = const Color(0xFF7D0A0F);
  final Color bg = const Color(0xFFFDF0F0);
  final Color line = const Color(0xFFEFDCDC);

  final List<Map<String, dynamic>> items = [
    {'nama': 'Bunga Mawar', 'qty': 5, 'unit': 'tangkai', 'harga': 10000},
    {'nama': 'Bunga Lily', 'qty': 2, 'unit': 'tangkai', 'harga': 8000},
    {'nama': 'Kartu Ucapan', 'qty': 1, 'unit': 'pcs', 'harga': 9000},
  ];

  int get total => items.fold(
        0,
        (sum, item) => sum + (item['qty'] as int) * (item['harga'] as int),
      );

  String rupiah(int angka) =>
      'Rp${angka.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      )}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 412),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 20),
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: brand),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Detail Pesanan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: brand,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'INV-20261004-001',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          _pill(widget.status, Colors.pink),
                        ],
                      ),

                      const Divider(height: 25),

                      _sectionTitle('Informasi Pelanggan'),

                      _infoRow(
                        Icons.person,
                        'Siti Maisyaroh',
                        '0812 3456 7890',
                      ),
                      _infoRow(
                        Icons.location_on_outlined,
                        'Alamat',
                        'Jl. Melati No. 12, Nganjuk',
                      ),

                      _divider(),

                      _sectionTitle('Detail Produk'),

                      Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor:
                                const WidgetStatePropertyAll(Color(0xFFF8E6E8)),
                            columnSpacing: 17,
                            columns: const [
                              DataColumn(label: Text('Produk')),
                              DataColumn(label: Text('Jumlah')),
                              DataColumn(label: Text('Harga')),
                              DataColumn(label: Text('Subtotal')),
                            ],
                            rows: items.map((item) {
                              final subtotal =
                                  item['qty'] * item['harga'];

                              return DataRow(cells: [
                                DataCell(Text(item['nama'])),
                                DataCell(Text(
                                    '${item['qty']} ${item['unit']}')),
                                DataCell(Text(rupiah(item['harga']))),
                                DataCell(Text(rupiah(subtotal))),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _note(),

                      if (widget.catatan.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _catatanAdmin(widget.catatan),
                      ],

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              rupiah(total),
                              style: TextStyle(
                                color: brand,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PesananBerhasilPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Selesaikan Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 10),
        child: Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600)),
      );

  Widget _infoRow(IconData icon, String title, String subtitle) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: brand, size: 23),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8A7A7C), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );

  Widget _divider() => Divider(color: line, height: 25);

  Widget _note() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.notes, color: Color(0xFF7D0A0F)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Catatan Pelanggan',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    'Untuk tanggal 5 Oktober, pukul 15.00.',
                    style: TextStyle(
                        color: Color(0xFF8A7A7C), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _catatanAdmin(String catatan) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.edit_note, color: Color(0xFF7D0A0F)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Admin',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    catatan,
                    style: const TextStyle(
                      color: Color(0xFF8A7A7C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

