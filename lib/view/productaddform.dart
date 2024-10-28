import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProductEntryForm extends StatefulWidget {
  const ProductEntryForm({super.key});

  @override
  _ProductEntryFormState createState() => _ProductEntryFormState();
}

class _ProductEntryFormState extends State<ProductEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _category;
  String? _measurementType;
  String? _productType;
  bool _notifyUsers = false;
  bool _whatsAppAlert = false;
  DateTime? _validFrom;
  DateTime? _validTo;

  @override
  void dispose() {
    _productNameController.dispose();
    _productIdController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _quantityController.dispose();
    _storeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _validFrom = picked;
        } else {
          _validTo = picked;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Save form data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('productName', _productNameController.text);
      prefs.setString('productId', _productIdController.text);
      prefs.setString('category', _category ?? '');
      prefs.setString('brand', _brandController.text);
      prefs.setString('price', _priceController.text);
      prefs.setString('discountPrice', _discountPriceController.text);
      prefs.setString('quantity', _quantityController.text);
      prefs.setString('measurementType', _measurementType ?? '');
      prefs.setString('store', _storeController.text);
      prefs.setString('imageUrl', _imageUrlController.text);
      prefs.setString('productType', _productType ?? '');
      prefs.setBool('notifyUsers', _notifyUsers);
      prefs.setBool('whatsAppAlert', _whatsAppAlert);
      if (_validFrom != null) {
        prefs.setString('validFrom', _validFrom!.toIso8601String());
      }
      if (_validTo != null) {
        prefs.setString('validTo', _validTo!.toIso8601String());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product details saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...........PRODAUCT NAME SECTION AND VALIDATION...............
                const Text(
                  'Product Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Product Name',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT ID SECTION AND VALIDATION...............
                const Text(
                  'Product ID',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productIdController,
                  decoration: InputDecoration(
                    hintText: 'Use Alphanumeric Id',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Product ID is required';
                    } else if (value.length > 10) {
                      return 'Product ID should not exceed 10 characters';
                    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Only alphanumeric characters are allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT NAME CATEGORY AND VALIDATION...............
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                  ),
                  hint: const Text('Select Category'),
                  items: ['Grocery', 'Electronics', 'Fashion', 'Toys']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT BRAND SECTION AND VALIDATION...............
                const Text(
                  'Brand (Optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    hintText: 'Enter Brand',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT PRICE SECTION AND VALIDATION...............
                const Text(
                  'Price (in \$)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Enter Price',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: (value) {
                    if (value == null ||
                        double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT NAME SECTION AND VALIDATION...............
                const Text(
                  'Discount Price (in \$) Optional',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _discountPriceController,
                  decoration: InputDecoration(
                    hintText: 'Enter Discount Price',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        double.tryParse(value) != null) {
                      final discount = double.parse(value);
                      final price = double.parse(_priceController.text);
                      if (discount > price) {
                        return 'Discount price must be less than or equal to the price';
                      }

                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT QUANTITY SECTION AND VALIDATION...............
                const Text(
                  'Quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    hintText: 'Enter Quantity',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null ||
                        int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT Measurement Type SECTION AND VALIDATION...............
                const Text(
                  'Measurement Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _measurementType,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                  ),
                  hint: const Text('Select Category'),
                  items: ['kg', 'liters', 'units']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _measurementType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a measurement type' : null,
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT STORE SECTION AND VALIDATION...............
                const Text(
                  'Store',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _storeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Store name',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the store name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT DATE VALIDATION Type SECTION AND VALIDATION...............
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Valid From',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: _validFrom != null
                                  ? ' ${DateFormat('yyyy-MM-dd').format(_validFrom!)}'
                                  : 'Valid From',
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 12.0,
                              ),
                            ),
                            onTap: () => _selectDate(context, true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Valid To',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: _validTo != null
                                  ? ' ${DateFormat('yyyy-MM-dd').format(_validTo!)}'
                                  : 'Valid To',
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 12.0,
                              ),
                            ),
                            onTap: () => _selectDate(context, false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT PRODUCT Type SECTION AND VALIDATION...............
                const Text(
                  'Product Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _productType,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                  ),
                  hint: const Text('Select Category'),
                  items: ['Regular', 'Combo']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _productType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a product type' : null,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Image URL',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                //...........PRODAUCT IMAGE SECTION AND VALIDATION...............
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    hintText: 'https://example.com/images/product.jpg ',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    //USE URLS IN https://example.com/images/product.jpg <--THIS FORMAT

                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    final uri = Uri.tryParse(value);
                    if (uri == null ||
                        !uri.isAbsolute ||
                        (uri.scheme != 'http' && uri.scheme != 'https')) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                //...........PRODAUCT NOTIFICATION Type SECTION AND VALIDATION...............
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Notify Users',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Checkbox(
                      value: _notifyUsers,
                      onChanged: (value) =>
                          setState(() => _notifyUsers = value!),
                      activeColor:
                          Colors.blue, // Change this to your desired color
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'WhatsApp Alert',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Checkbox(
                      value: _whatsAppAlert,
                      onChanged: (value) =>
                          setState(() => _whatsAppAlert = value!),
                      activeColor:
                          Colors.blue, // Change this to your desired color
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0), // Adjust height
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero, // Removes border radius
                      ),
                    ),
                    child: const Text(
                      'Save Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
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
}
