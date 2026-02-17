import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/controllers/order_controller.dart';
import 'package:mac_store/services/manage_http_response.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  //Method to fetch delivered order count
  Future<void> fetchDeliveredOrderCount(String buyerId, context) async {
    try {
      OrderController orderController = OrderController();
      int count =
          await orderController.getDeliveredOrderCount(buyerId: buyerId);
      state = count; //Update the state with count
    } catch (e) {
      showSnackBar(context, 'Error fetching delivered order: $e');
    }
  }

  //Method to reset the state
  void resetCount() {
    state = 0;
  }
}

final deliveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
 return DeliveredOrderCountProvider();
});
