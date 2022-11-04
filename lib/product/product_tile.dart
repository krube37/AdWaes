import 'package:ad/product/product_data.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final ProductData productData;
  final Function()? onClick;
  final bool isTileSelected;

  const ProductTile({
    Key? key,
    required this.productData,
    this.onClick,
    this.isTileSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          onClick?.call();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isTileSelected) ? Colors.purple.shade200 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: productData.profilePhotoImageProvider,
                  child: productData.profilePhotoImageProvider == null
                      ? const Icon(
                          Icons.person_sharp,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    productData.name,
                    overflow: TextOverflow.ellipsis,
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
