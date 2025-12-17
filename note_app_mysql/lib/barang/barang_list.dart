// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'barang_model.dart';
import 'barang_add.dart';
import 'barang_edit.dart';

class BarangList extends StatefulWidget {
  @override
  BarangListState createState() => BarangListState();
}

class BarangListState extends State<BarangList> {
  // List untuk menampung data barang dari database
  List<Barang> _barangList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Ambil data saat pertama kali dibuka
    _getData();
  }

  Future _getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/barang/list.php"),
      );

      // Jika response berhasil
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _barangList = data.map((json) => Barang.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _barangList.isEmpty
              ? Center(
                  child: Text(
                    "Tidak Ada Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _barangList.length,
                  itemBuilder: (context, index) {
                    final barang = _barangList[index];
                    return Card(
                      color: Colors.blue.shade100,
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarangEdit(
                                kdBrg: barang.kdBrg,
                              ),
                            ),
                          ).then((_) => _getData());
                        },
                        title: Text(
                          barang.nmBrg,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('Kode: ${barang.kdBrg}'),
                            Text('Harga Beli: Rp ${barang.hrgBeli}'),
                            Text('Harga Jual: Rp ${barang.hrgJual}'),
                            Text('Stok: ${barang.stok}'),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BarangAdd()),
          ).then((_) => _getData());
        },
      ),
    );
  }
}
