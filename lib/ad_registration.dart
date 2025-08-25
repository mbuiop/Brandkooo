import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'models.dart';

class AdRegistrationScreen extends StatefulWidget {
  @override
  _AdRegistrationScreenState createState() => _AdRegistrationScreenState();
}

class _AdRegistrationScreenState extends State<AdRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'فروشگاهی',
    'خدماتی',
    'املاک',
    'وسایل نقلیه',
    'لوازم الکترونیکی',
    'مربوط به خانه',
    'شخصی',
    'استخدام',
    'رویدادها',
    'تفریحات',
    'آموزشی',
    'کسب و کار',
    'کشاورزی',
    'دام و طیور',
    'صنعتی',
    'سلامتی',
    'تور و سفر',
    'غذا و رستوران',
    'هنری',
    'ورزشی'
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitAd() {
    if (_formKey.currentState!.validate()) {
      // ایجاد یک آگهی جدید
      Advertisement newAd = Advertisement(
        title: _titleController.text,
        category: _selectedCategory!,
        description: _descriptionController.text,
        price: _priceController.text.isNotEmpty ? double.parse(_priceController.text) : null,
        image: _selectedImage,
        date: DateTime.now(),
      );

      // ذخیره آگهی (در اینجا می‌توانید آن را به دیتابیس یا لیست全局 اضافه کنید)
      // advertisements.add(newAd);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('آگهی با موفقیت ثبت شد'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // پاک کردن فرم
      _formKey.currentState!.reset();
      setState(() {
        _selectedImage = null;
        _selectedCategory = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت آگهی جدید'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان آگهی',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً عنوان آگهی را وارد کنید';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'دسته‌بندی',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'لطفاً دسته‌بندی را انتخاب کنید';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'توضیحات',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً توضیحات را وارد کنید';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'قیمت (تومان) - اختیاری',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('انتخاب عکس (اختیاری)'),
              ),
              SizedBox(height: 8),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 150),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitAd,
                child: Text('ثبت آگهی'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
