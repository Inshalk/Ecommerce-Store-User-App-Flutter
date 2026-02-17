import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store/controllers/product_controller.dart';
import 'package:mac_store/models/vendor_model.dart';
import 'package:mac_store/provider/vendor_product_provider.dart';
import 'package:mac_store/views/screens/nav_screens/widget/product_item_widget.dart';

class VendorsProductScreen extends ConsumerStatefulWidget {
  final Vendor vendor;

  const VendorsProductScreen({super.key, required this.vendor});

  @override
  ConsumerState<VendorsProductScreen> createState() =>
      _VendorsProductScreenState();
}

class _VendorsProductScreenState extends ConsumerState<VendorsProductScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
   //Deffer products fetching until the widget tree is build
   WidgetsBinding.instance.addPostFrameCallback((_){
    _fetchProductsIfNeeded();
   });
  }

  void _fetchProductsIfNeeded() {
  final products = ref.read(vendorProductProvider);
  //check if product are empty or if the vendor has changed
  if (products.isEmpty || products.first.vendorId != widget.vendor.id) {
    //clear old products and fetch new once
    ref.read(vendorProductProvider.notifier).setProducts([]);
    _fetchProduct();
  } else {
    setState(() {
      isLoading = false;
    });
  }
}

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadVendorProducts(
        widget.vendor.id,
      );
      ref.read(vendorProductProvider.notifier).setProducts(products);
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset('assets/icons/not.png', width: 25, height: 25),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            products.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  widget.vendor.fullName.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.vendor.storeImage!.isEmpty
                  ? CircleAvatar(
                      radius: 50,
                      child: Text(
                        widget.vendor.fullName[0].toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.vendor.storeImage!),
                    ),

              const SizedBox(height: 10),

              widget.vendor.storeDescription!.isEmpty
                  ? Text('')
                  : Text(
                      widget.vendor.storeDescription!,
                      style: GoogleFonts.montserrat(
                        letterSpacing: 1.7,
                        color: Colors.blueGrey,
                      ),
                    ),

              const SizedBox(height: 10),

              const Divider(thickness: 1, color: Colors.grey),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : products.isEmpty? Text('No products found 404',style: GoogleFonts.montserrat(),): Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductItemWidget(product: product);
                        },
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
