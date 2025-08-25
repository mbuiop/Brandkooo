import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ClothingStoreScreen extends StatefulWidget {
  @override
  _ClothingStoreScreenState createState() => _ClothingStoreScreenState();
}

class _ClothingStoreScreenState extends State<ClothingStoreScreen> {
  final TextEditingController _broadcastMessageController = TextEditingController();
  List<File> _uploadedImages = [];
  List<String> _broadcastMessages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _uploadedImages.add(File(image.path));
      });
      
      // نمایش پیام موفقیت
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('عکس با موفقیت آپلود شد'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _sendBroadcastMessage() {
    if (_broadcastMessageController.text.isNotEmpty) {
      setState(() {
        _broadcastMessages.add(_broadcastMessageController.text);
        _broadcastMessageController.clear();
      });
      
      // نمایش پیام موفقیت
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('پیام همگانی ارسال شد'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToSecretPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecretAdminPage(
          uploadedImages: _uploadedImages,
          broadcastMessages: _broadcastMessages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فروشگاه لباس'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: _navigateToSecretPage,
            tooltip: 'صفحه مدیریت',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فروشگاه لباس',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'به فروشگاه لباس ما خوش آمدید. در اینجا می‌توانید جدیدترین محصولات ما را مشاهده کنید.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Text(
              'آخرین پیام‌های همگانی:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _broadcastMessages.isEmpty
                ? Text('هیچ پیامی وجود ندارد')
                : Column(
                    children: _broadcastMessages
                        .map((message) => Card(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(message),
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class SecretAdminPage extends StatelessWidget {
  final List<File> uploadedImages;
  final List<String> broadcastMessages;

  const SecretAdminPage({
    required this.uploadedImages,
    required this.broadcastMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه مدیریت'),
        backgroundColor: Colors.purple,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'آپلود عکس'),
                Tab(text: 'پیام همگانی'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ImageUploadTab(uploadedImages: uploadedImages),
                  _BroadcastTab(broadcastMessages: broadcastMessages),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageUploadTab extends StatelessWidget {
  final List<File> uploadedImages;

  const _ImageUploadTab({required this.uploadedImages});

  @override
  Widget build(BuildContext context) {
    return uploadedImages.isEmpty
        ? Center(child: Text('هیچ عکسی آپلود نشده است'))
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: uploadedImages.length,
            itemBuilder: (context, index) {
              return Image.file(uploadedImages[index], fit: BoxFit.cover);
            },
          );
  }
}

class _BroadcastTab extends StatelessWidget {
  final List<String> broadcastMessages;

  const _BroadcastTab({required this.broadcastMessages});

  @override
  Widget build(BuildContext context) {
    return broadcastMessages.isEmpty
        ? Center(child: Text('هیچ پیامی وجود ندارد'))
        : ListView.builder(
            itemCount: broadcastMessages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(broadcastMessages[index]),
                leading: Icon(Icons.message),
              );
            },
          );
  }
}
