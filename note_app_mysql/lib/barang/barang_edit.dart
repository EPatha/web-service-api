// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarangEdit extends StatefulWidget {
  BarangEdit({required this.kdBrg});

  String kdBrg;

  @override
  State<BarangEdit> createState() => _BarangEditState();
}

class _BarangEditState extends State<BarangEdit> {
  final _formKey = GlobalKey<FormState>();

  // Initialize field controllers
  var nmBrg = TextEditingController();
  var hrgBeli = TextEditingController();
  var hrgJual = TextEditingController();
  var stok = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  // Http to get detail data
  Future _getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
        "http://localhost:8080/barang/detail.php?KdBrg=${widget.kdBrg}",
      ));

      // If response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nmBrg = TextEditingController(text: data['NmBrg']);
          hrgBeli = TextEditingController(text: data['HrgBeli'].toString());
          hrgJual = TextEditingController(text: data['HrgJual'].toString());
          stok = TextEditingController(text: data['Stok'].toString());
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

  Future _onUpdate(context) async {
    try {
      return await http.post(
        Uri.parse("http://localhost:8080/barang/update.php"),
        body: {
          "KdBrg": widget.kdBrg,
          "NmBrg": nmBrg.text,
          "HrgBeli": hrgBeli.text,
          "HrgJual": hrgJual.text,
          "Stok": stok.text,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        print(data["message"]);
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Berhasil'),
            content: Text(data["message"]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke list
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future _onDelete(context) async {
    try {
      return await http.post(
        Uri.parse("http://localhost:8080/barang/delete.php"),
        body: {
          "KdBrg": widget.kdBrg,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        print(data["message"]);
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Berhasil'),
            content: Text(data["message"]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke list
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Barang"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Konfirmasi Hapus'),
                      content: Text('Yakin ingin menghapus data ini?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Batal'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(
                          child: Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                            _onDelete(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kode Barang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.kdBrg,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nama Barang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nmBrg,
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Barang",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Barang harus diisi!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Harga Beli',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: hrgBeli,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Masukkan Harga Beli",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harga Beli harus diisi!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Harga Jual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: hrgJual,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Masukkan Harga Jual",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harga Jual harus diisi!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Stok',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: stok,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Masukkan Jumlah Stok",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Stok harus diisi!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Validate
                          if (_formKey.currentState!.validate()) {
                            // Send data to database
                            _onUpdate(context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
