import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store/controllers/category_controller.dart';
import 'package:mac_store/controllers/subcategory_controller.dart';
import 'package:mac_store/models/category.dart';
import 'package:mac_store/provider/category_provider.dart';
import 'package:mac_store/provider/subcategory_provider.dart';
import 'package:mac_store/views/screens/detail/screens/subcategory_product_screen.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/header_widget.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchcategories();
  }
  Category? _selectedCategory;

  Future<void> _fetchcategories()async{
    final categories= await CategoryController().loadCategories();
    ref.read(categoryProvider.notifier).setCategories(categories);
    //Set the default category
    for(var category in categories){
      if(category.name=='Fashion'){
        setState(() {
          _selectedCategory=category;
        });
        //load subcategory
        _fetchSubcategories(category.name);
      }
    }
  }


Future<void> _fetchSubcategories(String categoryName)async{
  final subcategories=await SubCategoryController().getSubCategoriesByCategoryName(categoryName);
  ref.read(subcategoryProvider.notifier).setSubcategories(subcategories);
}



  //A future that will hold the list of categories once loaded from the api
  // late Future<List<Category>> futureCategories;
  // List<SubCategory> _subcategories = [];
  // final SubCategoryController _subcategoryController = SubCategoryController();

  // @override
  // void initState() {
  //   super.initState();
  //   futureCategories = CategoryController().loadCategories();
  //   //Once the category loadded then proceed
  //   futureCategories.then((categories) {
  //     //Itreate over the categories to find the 'Fashion' Category
  //     for (var category in categories) {
  //       if (category.name == 'Fashion') {
  //         //if fashion is found
  //         setState(() {
  //           _selectedCategory = category;
  //         });
  //         _loadSubCategories(category.name);
  //       }
  //     }
  //   });
  // }

  //This will load the subcategory based on category name
  // Future<void> _loadSubCategories(String categoryName) async {
  //   final subcategories = await _subcategoryController
  //       .getSubCategoriesByCategoryName(categoryName);
  //   setState(() {
  //     _subcategories = subcategories;
  //   });
  // }




  @override
  Widget build(BuildContext context) {
    final categories=ref.watch(categoryProvider);
    final _subcategories=ref.watch(subcategoryProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const HeaderWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _fetchSubcategories(category.name);
                              },
                              title: Text(
                                category.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == category
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            );
                          },),
            ),
          ),

          //Right Side display selected category details
          Expanded(
              flex: 5,
              child: _selectedCategory != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectedCategory!.name,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          _selectedCategory!.banner),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          _subcategories.isNotEmpty
                              ? GridView.builder(
                                physics:const NeverScrollableScrollPhysics(),
                                  itemCount: _subcategories.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 2 / 3,
                                  ),
                                  itemBuilder: (context, index) {
                                    final subcategories = _subcategories[index];
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return SubcategoryProductScreen(subCategory: subcategories);
                                        }
                                        ));
                                        
                                      },
                                      child: SubcategoryTileWidget(
                                          image: subcategories.image,
                                          title: subcategories.subCategoryName),
                                    );
                                  })
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'No subcategories',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  : Container()),
        ],
      ),
    );
  }
}
