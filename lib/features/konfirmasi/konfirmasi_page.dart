
import 'package:flutter/material.dart';
import '../detail/detail_page.dart';

class KonfirmasiPage extends StatefulWidget {
  const KonfirmasiPage({super.key});

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  final Color brand = const Color(0xFF7D0A0F);
  final Color bg = const Color(0xFFFDF0F0);
  final Color line = const Color(0xFFEFDCDC);

  final TextEditingController catatanController =
      TextEditingController();

  final List<String> statuses = [
    'Dikonfirmasi',
    'Diproses',
    'Siap Diambil',
    'Selesai',
    'Dibatalkan',
  ];

  String statusTerpilih = 'Dikonfirmasi';
  bool tersimpan = false;

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 412),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: brand),
                      ),
                      Text(
                        'Konfirmasi Pesanan',
                        style: TextStyle(
                          color: brand,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: brand, size: 24),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INV-20261004-001',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3A1418),
                            ),
                          ),
                          const Text(
                            'Siti Maisyaroh',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            '04 Okt 2026 • 14:32',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9A8A8C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(height: 30, color: line),

                  const Text(
                    'Ubah Status Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: statuses.map((status) {
                        final selected = statusTerpilih == status;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              statusTerpilih = status;
                              tersimpan = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFFDE3E6)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFFE8A0AA)
                                    : line,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: selected ? brand : Colors.grey,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  status,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Catatan (opsional)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: catatanController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tulis catatan jika ada...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: line),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        debugPrint({
                          'status': statusTerpilih,
                          'catatan': catatanController.text.trim(),
                        }.toString());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}