import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class InfoFoodScreen extends StatefulWidget {
  final String imagePath;

  const InfoFoodScreen(this.imagePath);

  @override
  // ignore: library_private_types_in_public_api
  _InfoFoodScreenState createState() => _InfoFoodScreenState();
}

class _InfoFoodScreenState extends State<InfoFoodScreen> {
  bool _isPublic = false;
  String _foodName = ''; 
  double _sugar = 0.0;
  double _fiber = 0.0;
  double _fat = 0.0;
  double _cholesterol = 0.0;
  double _protein = 0.0;
  double _carbohydrates = 0.0;

  @override
  void initState() {
    super.initState();
    fetchFoodInfo();
  }

  Future<void> fetchFoodInfo() async {
    try {
      final response = await http.post(Uri.parse('https://limus-api-nutrion.onrender.com/foodNutrition?haveImage=true&imageFood=${widget.imagePath}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _foodName = data[0]['name'];
            _sugar = data[0]['sugar'] != null ? data[0]['sugar'].toDouble() : 0.0;
            _fiber = data[0]['fiber'] != null ? data[0]['fiber'].toDouble() : 0.0;
            _fat = data[0]['fat'] != null ? data[0]['fat'].toDouble() : 0.0;
            _cholesterol = data[0]['cholesterol'] != null ? data[0]['cholesterol'].toDouble() : 0.0;
            _protein = data[0]['protein'] != null ? data[0]['protein'].toDouble() : 0.0;
            _carbohydrates = data[0]['carbohydrates'] != null ? data[0]['carbohydrates'].toDouble() : 0.0;
          });
        }
      } else {
        throw Exception('Failed to load food information');
      }
    } catch (e) {
      print('Error fetching food information: $e');
    }
  }

  Future<void> sendFormData(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://limus-api-nutrion.onrender.com/upload'));
      request.files.add(http.MultipartFile('file', imageFile.readAsBytes().asStream(), imageFile.lengthSync(), filename: 'image.jpg'));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(_foodName), 
        backgroundColor: const Color(0xFF1B1B1B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      backgroundColor: const Color(0xFF1B1B1B),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _foodName.trim(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB2DE97),
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB2DE97),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visibility:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _isPublic,
                          onChanged: (bool? value) {
                            setState(() {
                              _isPublic = false;
                            });
                          },
                          activeColor: const Color(0xFFB2DE97),
                        ),
                        Text(
                          'Private',
                          style: TextStyle(color: _isPublic ? Colors.white : const Color(0xFFB2DE97)),
                        ),
                        const SizedBox(width: 20),
                        Radio(
                          value: true,
                          groupValue: _isPublic,
                          onChanged: (bool? value) {
                            setState(() {
                              _isPublic = true;
                            });
                          },
                          activeColor: const Color(0xFFB2DE97),
                        ),
                        Text(
                          'Public',
                          style: TextStyle(color: _isPublic ? const Color(0xFFB2DE97) : Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color(0xFFB2DE97),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Food Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sugar: $_sugar',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Fiber: $_fiber',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Fat: $_fat',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Cholesterol: $_cholesterol',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Protein: $_protein',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Carbohydrates: $_carbohydrates',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200, // Aumentando a largura do botão
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementar ação para postar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB2DE97), 
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Color(0xFF2B2B2A)
                        ), 
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
