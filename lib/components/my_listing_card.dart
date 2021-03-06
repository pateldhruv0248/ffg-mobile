import 'package:FoodForGood/components/icon_button.dart';
import 'package:flutter/material.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/helper_service.dart';
import 'package:FoodForGood/models/listing_model.dart';

class MyListingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Listing listing;
  final List<Widget> requestCards;
  final List<CustomIconButton> customIconButtons;
  final String requestState;

  MyListingCard(
      {@required this.title,
      @required this.subtitle,
      @required this.listing,
      this.requestCards = const [],
      this.customIconButtons = const [],
      this.requestState = ''});

  Widget build(BuildContext context) {
    String message = 'Message for user';
    if (listing.listingState == listingStateOpen) {
      message = 'Requests for your listing';
    }
    if (listing.listingState == listingStateProgress) {
      message = 'Food taken by requester?';
    }
    if (listing.listingState == listingStateCompleted) {
      message = 'Food was succesfully given :)';
    }
    if (listing.listingState == listingStateDeleted) {
      message = 'Listing was deleted or expired!';
    }
    if (requestState == requestStateAccepted) {
      message = 'Food taken from donor?';
    }
    if (requestState == requestStatePending) {
      message = 'Delete your request?';
    }
    if (requestState == requestStateCompleted) {
      message = 'Food taken by donor succefully :)';
    }
    return ExpansionTile(
      title: Text(this.title,
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(this.subtitle, style: kTextStyle.copyWith(fontSize: 13.0)),
      backgroundColor: kBackgroundColor,
      children: [
        Column(
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
                        'Sharing ${listing.title}',
                        style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        listing.description,
                        style: kTextStyle.copyWith(
                          fontSize: 14.0,
                          color: kSecondaryColor.withAlpha(950),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        listing.address,
                        style: kTextStyle.copyWith(
                          fontSize: 14.0,
                          color: kSecondaryColor.withAlpha(950),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
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
                            listing.expiryTime),
                        softWrap: true,
                        style: kTextStyle.copyWith(
                            fontSize: 14.5, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // if (requestState == requestStatePending)
            //   Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Text(message,
            //         style: kTextStyle.copyWith(
            //             fontSize: 18.0, fontWeight: FontWeight.bold)),
            //   ),
            if (customIconButtons != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: customIconButtons,
              ),
            SizedBox(
              height: 15.0,
            ),
            Text(message,
                style: kTextStyle.copyWith(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10.0,
            ),
            if (requestCards != null) ...requestCards
          ],
        ),
      ],
    );
  }
}
