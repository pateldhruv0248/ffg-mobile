import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/api_path.dart';
import 'package:FoodForGood/services/firestore_service.dart';

class FirestoreDatabase {
  final _service = FirestoreService.instance;

  Stream<List<Listing>> listingStream() => _service.collectionStream(
        path: APIPath.listing(),
        builder: (data) => Listing.fromMap(data),
      );

  Future<void> deleteListing({Listing listing}) async =>
      await _service.deleteData(
        path: APIPath.listing(),
        docId: listing.listId,
      );

  Future<void> createListing(Listing listing) async => await _service.addData(
        path: APIPath.listing(),
        data: listing.toMap(),
      );

  Future<void> editListing(Listing listing) async => await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: listing.toMap(),
      );

  Future<void> editListingState(String listingState, Listing listing) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {'listingState': listingState},
      );
  Future<void> createListingRequest(
          Listing listing, Map<String, dynamic> updatedRequestsList) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {
          'requests': updatedRequestsList,
        },
      );

//On rejecting request,
  //If the request is rejected in OPEN state, update the requests by removing the rejected request.
  //
  //Else If the request is in PROGRESS state, empty the accepted request,
  //and show all the requests, also change the state to OPEN state again.
  Future<void> deleteListingRequest(
      {bool isAlreadyAccepted,
      Listing listing,}) async {
    if (isAlreadyAccepted) {
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {
          'acceptedRequest': {},
          'listingState': listingStateOpen,
        },
      );
    } else {
      Map<String, dynamic> requests = listing.requests;
      requests.remove(listing.email);
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {
          'requests': requests,
        },
      );
    }
  }

  Future<void> acceptListingRequest(
          Listing listing, Map<String, dynamic> accceptedRequest) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {
          'acceptedRequest': accceptedRequest,
          'listingState': listingStateProgress,
        },
      );
}