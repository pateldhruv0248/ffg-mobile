import 'package:FoodForGood/components/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/helper_service.dart';

class ListingCardExpanded extends StatelessWidget {
  final String username;
  final String title;
  final String descrtiption;
  final String address;
  final Function onCross;
  final DateTime expiryTime;
  final Function onPressedTickMark;
  final Color tickMarkColor;
  final Function onPressedChat;

  ListingCardExpanded(
      {this.username,
      this.title,
      this.descrtiption,
      this.address,
      this.onCross,
      this.expiryTime,
      this.onPressedTickMark,
      this.tickMarkColor = kPrimaryColor,
      this.onPressedChat});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .56,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Sharing $title',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    descrtiption,
                    style: kTextStyle.copyWith(
                      fontSize: 14.0,
                      color: kSecondaryColor.withAlpha(950),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    address,
                    style: kTextStyle.copyWith(
                      fontSize: 14.0,
                      color: kSecondaryColor.withAlpha(950),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5.0, right: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: kPrimaryColor,
                    ),
                  ),
                  width: 55,
                  height: 55,
                  child: Text(
                    '6.7',
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: 60,
                  child: Text(
                    'EXPIRY TIME',
                    style: kTextStyle.copyWith(
                      color: kSecondaryColor.withAlpha(950),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    HelperService.convertDateTimeToHumanReadable(
                        this.expiryTime),
                    style: kTextStyle.copyWith(
                        fontSize: 14.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CustomIconButton(
              icon: FontAwesomeIcons.check,
              size: 40.0,
              onPressed: this.onPressedTickMark,
            ),
            CustomIconButton(
              icon: Icons.chat,
              size: 40.0,
              onPressed: this.onPressedChat,
            ),
            IconButton(
              onPressed: onCross,
              icon: Icon(
                FontAwesomeIcons.times,
                color: kSecondaryColor,
                size: 40.0,
              ),
            )
          ],
        ),
      ],
    );
  }
}
