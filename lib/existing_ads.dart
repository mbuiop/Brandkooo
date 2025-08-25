import 'package:flutter/material.dart';
import 'models.dart';

class ExistingAdsScreen extends StatefulWidget {
  @override
  _ExistingAdsScreenState createState() => _ExistingAdsScreenState();
}

class _ExistingAdsScreenState extends State<ExistingAdsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilterCategory;

  final List<String> _categories = [
    'همه',
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

  // لیست نمونه آگهی‌ها (در عمل باید از دیتابیس یا state management استفاده کنید)
  List<Advertisement> _ads = [
    Advertisement(
      title: 'فروش لباس زمستانی',
      category: 'فروشگاهی',
      description: 'لباس زمستانی اورجینال با قیمت مناسب',
      price: 250000,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Advertisement(
      title: 'نیازمند منشی',
      category: 'استخدام',
      description: 'دفتر وکالت نیازمند منشی مسلط به کامپیوتر',
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Advertisement(
      title: 'آپارتمان در شمال تهران',
      category: 'املاک',
      description: 'آپارتمان ۱۰۰ متری در شمال تهران، fully furnished',
      price: 3500000000,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  List<Advertisement> get _filteredAds {
    return _ads.where((ad) {
      final matchesSearch = ad.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ad.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedFilterCategory == null ||
          _selectedFilterCategory == 'همه' ||
          ad.category == _selectedFilterCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('آگهی های موجود'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'جستجوی آگهی‌ها',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilterCategory ?? 'همه',
              decoration: InputDecoration(
                labelText: 'فیلتر بر اساس دسته',
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
                  _selectedFilterCategory = newValue;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _filteredAds.isEmpty
                ? Center(
                    child: Text('هیچ آگهی یافت نشد'),
                  )
                : ListView.builder(
                    itemCount: _filteredAds.length,
                    itemBuilder: (context, index) {
                      final ad = _filteredAds[index];
                      return _AdCard(advertisement: ad);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final Advertisement advertisement;

  const _AdCard({required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              advertisement.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(advertisement.category),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 8),
                if (advertisement.price != null)
                  Text(
                    '${advertisement.price!.toStringAsFixed(0)} تومان',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(advertisement.description),
            SizedBox(height: 8),
            Text(
              'تاریخ: ${advertisement.date.day}/${advertisement.date.month}/${advertisement.date.year}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
