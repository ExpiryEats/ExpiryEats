.. _barcode-scanner-api:

BarCode Scanner 
=============

Overview
--------

The barCode scanner is used to scan barcodes and QR codes. It uses the `mobile_scanner` package to access the device's camera and scan codes. The scanned data is then used to fetch information from the database.

Fetch Product Data
-----------------

The method finds product data such as name and if possible the expiry date and category of the item. It uses the barcode to search for the product in the database and returns the product data.

``Future<void> _fetchProductInfo(String  barcode) async {}``

* barcode - The barcode of the product to search for.

.. code-block:: console

    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);

        if (productData['status'] == 1) {
          final product = productData['product'];
          setState(() {
            //Autofilling item name
            _nameController.text = product['product_name']?.toString() ?? '';
            
            // Autofills expiry date if avaliable
            if (product['expiration_date'] != null) {
              _selectedExpiryDate = DateFormat('yyyy-MM-dd').parse(
                product['expiration_date'].toString()
              );
              _expiryController.text = DateFormat('dd/MM/yyyy').format(_selectedExpiryDate!);
            }
            
            // Auto selects category if possible
            _autoSelectCategory(product['categories']?.toString());
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product not found in database')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching product info ${e.toString()}')),
          #returns nothing if no image is found
        );
      }
    }
  }

The method uses the Open Food Facts API to fetch product data. It checks if the response is successful and if the product is found in the database. If the product is found, it updates the UI with the product data. If not, it shows a message indicating that the product was not found.
Example:
>>> input = barcode-scanner-api._fetchProductInfo('1234567890123')

>>> output
    {
      "product_name": "Mac and Cheese",
      "expiration_date": "2023-12-31",
      "categories": ["Dairy", "Cheese"] 
      #Expiry and category are optional
    }

