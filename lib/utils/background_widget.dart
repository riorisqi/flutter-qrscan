import 'package:flutter/material.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

Widget backgroundWidget(BuildContext context, Widget widget){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    alignment: Alignment.topCenter,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          constants.BACKGROUND_IMG
        ),
        fit: BoxFit.cover
      )
    ),
    child: widget,
  );
}