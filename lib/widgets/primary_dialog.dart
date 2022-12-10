import 'package:ad/utils/globals.dart';
import 'package:flutter/material.dart';

class PrimaryDialog {
  final BuildContext context;
  final String title;
  final String? description;
  final Widget? body;
  final bool barrierDismissible;
  final PrimaryDialogButton? yesButton, noButton;

  const PrimaryDialog(
    this.context,
    this.title, {
    this.description,
    this.body,
    this.yesButton,
    this.noButton,
    this.barrierDismissible = true,
  }) : assert(description != null || body != null, "Either provide description or a custom dialog body");

  Future show<T>() async {
    final Size size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(2.0),
              child: Container(
                width: (isPortrait ? size.width : size.height) * 0.85,
                color: null,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description != null)
                          Container(
                            padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                            child: Text(
                              description!,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        if (body != null) body!,
                        const SizedBox(height: 20.0),
                        Container(
                          padding: const EdgeInsets.only(bottom: 10.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (noButton != null)
                                InkWell(
                                  borderRadius: BorderRadius.circular(2.0),
                                  splashColor: Colors.transparent,
                                  onTap: noButton?.onTap ?? () => Navigator.pop(context, false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    child: Text(
                                      noButton!.text,
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              if (yesButton != null && noButton != null)
                                const SizedBox(
                                  width: 10.0,
                                ),
                              if (yesButton != null)
                                InkWell(
                                  borderRadius: BorderRadius.circular(2.0),
                                  splashColor: Colors.transparent,
                                  onTap: yesButton?.onTap ?? () => Navigator.pop(context, true),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      color: primaryColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    child: Text(
                                      yesButton!.text,
                                      style: const TextStyle(color: Colors.white, fontSize: 14.0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class PrimaryDialogButton {
  final String text;
  final Function()? onTap;

  const PrimaryDialogButton(this.text, {this.onTap});
}
