import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:ad/utils/constants.dart';
import 'package:flutter/material.dart';

import '../product/product_event.dart';
import '../utils/globals.dart';

class ProductProfilePage extends StatelessWidget {
  final String userName;

  const ProductProfilePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const MyAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxScreenWidth),
          child: FutureBuilder(
              future: FirestoreManager().getProductDataById(userName),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error in loading the data'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                ProductData product = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (isDesktopView(context)) const Expanded(child: SizedBox()),
                              Expanded(
                                child: CircleAvatar(
                                  radius: screenSize.width / 8,
                                  backgroundImage: product.profilePhotoImageProvider,
                                  backgroundColor: Colors.grey.shade400,
                                  child: product.profilePhotoImageProvider == null
                                      ? Icon(
                                          Icons.person_sharp,
                                          size: screenSize.width / 8,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Posted Events'),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text('1087')
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Active Events'),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text('480')
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('rating'),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text('4.5')
                                  ],
                                ),
                              ),
                              if (isDesktopView(context)) const Expanded(child: SizedBox())
                            ],
                          ),
                        ),
                        const Divider(
                          height: 40.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Active Events',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        FutureBuilder(
                            future: FirestoreManager().getEventsOfProduct(product.userName),
                            builder: (context, snapshot) {
                              List<ProductEvent> events = [];
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Error loading events '),
                                );
                              }
                              if (snapshot.hasData) {
                                events = snapshot.data!;
                              }
                              return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktopView(context) ? 4 : 3,
                                    childAspectRatio: 3 / 4,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: snapshot.hasData ? events.length : 10,
                                  itemBuilder: (context, index) {
                                    return snapshot.hasData
                                        ? EventTile(
                                            event: events[index],
                                            showProductHeader: false,
                                            productData: product,
                                          )
                                        : const EventTile(
                                            event: null,
                                            showProductHeader: false,
                                            productData: null,
                                            isLoading: true,
                                          );
                                  });
                            })
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
