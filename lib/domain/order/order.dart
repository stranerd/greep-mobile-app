import 'package:equatable/equatable.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/order/response/order_checkout_price_response.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/domain/cart/cart.dart';
import 'package:greep/domain/place/place_search.dart';
import 'package:greep/domain/product/product.dart';

class UserOrder extends Equatable {
  final String id;
  final String dropOffNote;
  final String payment;
  final String userId;
  final String? driverId;
  final num discount;
  final String? currentStatus;
  final bool done;
  final UserOrderData data;
  final bool paid;
  final PlaceSearchModel? pickUpLocation;
  final PlaceSearchModel? deliveryLocation;

  final DateTime deliveryDate;
  final OrderCheckoutPriceResponse fee;
  final DateTime date;
  final List<OrderTimeline> timeline;
  final OrderStatus status;

  bool get isAccepted => status.accepted != null;
  bool get isDriverAssigned => status.driverAssigned != null;

  bool get isPaid => status.paid!= null;
  bool get isCanceled => status.cancelled != null;
  bool get isCompleted => status.completed != null;
  bool get isShipped => status.shipped != null;

  const UserOrder(
      {required this.id,
      required this.data,
        required this.timeline,
      required this.dropOffNote,
      required this.payment,
      required this.userId,
      required this.driverId,
      required this.discount,
      required this.currentStatus,
      required this.done,
      required this.paid,
      required this.pickUpLocation,
        required this.status,
      required this.deliveryLocation,
      required this.deliveryDate,
      required this.fee,
      required this.date,
      });

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    List<OrderTimeline> timelines = [];
    if (map["timeline"]!=null){
    map["timeline"].forEach((e) {
      timelines.add(OrderTimeline.fromMap(e),);
    });
    }
    return UserOrder(
      id: map['id'] ?? "",
      currentStatus: map["currentStatus"] ?? "",
      dropOffNote: map['dropoffNote'] ?? "",
      timeline: timelines,
      status: OrderStatus.fromMap(map["status"]),
      payment: map['payment'] ?? "",
      data: UserOrderData.fromMap(map["data"]),
      discount: map["discount"] ?? 0,
      paid: map["paid"] == true,
      done: map["done"] == true,
      driverId: map["driverId"],
      userId: map['userId'] ?? "",
      deliveryLocation: PlaceSearchModel(
          location: Location(
              longitude: map["to"]?['coords'] == null
                  ? 0
                  : double.parse(map["to"]['coords'].first.toString()),
              latitude: map["to"]?['coords'] == null
                  ? 0
                  : double.parse(map['to']['coords'].last.toString())),
          name: map["to"]?['location'] ?? ""),
      pickUpLocation: PlaceSearchModel(
          location: Location(
              longitude: map["from"]?['coords'] == null
                  ? 0
                  : double.parse(map["from"]['coords'].first.toString()),
              latitude: map["from"]?['coords'] == null
                  ? 0
                  : double.parse(map['from']['coords'].last.toString())),
          name: map["from"]?['location'] ?? ""),
      deliveryDate: DateTime.fromMillisecondsSinceEpoch(map['time']['date']),
      fee: OrderCheckoutPriceResponse.fromMap(map['fee']),
      date: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id];
}

class OrderStatus {
  DateTime? created;
  DateTime? paid;
  DateTime? accepted;
  DateTime? rejected;
  DateTime? driverAssigned;
  DateTime? shipped;
  DateTime? cancelled;
  DateTime? completed;
  DateTime? refunded;

  OrderStatus({
    this.created,
    this.paid,
    this.accepted,
    this.rejected,
    this.driverAssigned,
    this.shipped,
    this.cancelled,
    this.completed,
    this.refunded,
  });

  factory OrderStatus.fromMap(Map<String, dynamic> json) {
    return OrderStatus(
      created: _convertToDateTime(json['created']?["at"]),
      paid: _convertToDateTime(json['paid']?["at"]),
      accepted: _convertToDateTime(json['accepted']?["at"]),
      rejected: _convertToDateTime(json['rejected']?["at"]),
      driverAssigned: _convertToDateTime(json['driverAssigned']?["at"]),
      shipped: _convertToDateTime(json['shipped']?["at"]),
      cancelled: _convertToDateTime(json['cancelled']?["at"]),
      completed: _convertToDateTime(json['completed']?["at"]),
      refunded: _convertToDateTime(json['refunded']?["at"]),
    );
  }

  static DateTime? _convertToDateTime(int? millisecondsSinceEpoch) {
    return millisecondsSinceEpoch != null
        ? DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
        : null;
  }
}

class OrderTimeline {
  final String status;
  final String title;
  final DateTime? date;
  final bool done;

  OrderTimeline(
      {required this.status,
      required this.title,
      required this.date,
      required this.done});

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'title': title,
      'date': date,
      'done': done,
    };
  }

  factory OrderTimeline.fromMap(Map<String, dynamic> map) {
    return OrderTimeline(
      status: map['status'] ?? "",
      title: map['title'] ?? "",
      date: map['at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['at']),
      done: map['done'] == true,
    );
  }
}

enum OrderType { cart, dispatch }

enum OrderDeliveryType { standard, perishable, fragile, others }

class UserOrderData {
  final OrderType type;
  final UserOrderDispatchData? dispatchData;
  final UserOrderCartData? cartData;

  UserOrderData(
      {required this.type, required this.dispatchData, required this.cartData});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'dispatchData': dispatchData,
      'cartData': cartData,
    };
  }

  factory UserOrderData.fromMap(Map<String, dynamic> map) {
    var type = Utils.extractEnum(map['type'], OrderType.values);
    return UserOrderData(
      type: type,
      dispatchData: type == OrderType.dispatch
          ? UserOrderDispatchData.fromMap(map)
          : null,
      cartData: type == OrderType.cart
    ? UserOrderCartData.fromMap(map)
        : null,
    );
  }
}

class UserOrderDispatchData {
  final OrderDeliveryType deliveryType;
  final String description;
  final String recipientName;
  final String recipientPhone;
  final String recipientPhoneCode;
  final num size;

  UserOrderDispatchData(
      {required this.deliveryType,
      required this.description,
      required this.recipientName,
      required this.recipientPhone,
      required this.recipientPhoneCode,
      required this.size});

  Map<String, dynamic> toMap() {
    return {
      'deliveryType': deliveryType,
      'description': description,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'recipientPhoneCode': recipientPhoneCode,
      'size': size,
    };
  }

  factory UserOrderDispatchData.fromMap(Map<String, dynamic> map) {
    var type = Utils.extractEnum(map['type'], OrderDeliveryType.values);

    return UserOrderDispatchData(
      deliveryType: type,
      description: map['description'] ?? "",
      recipientName: map['recipientName'] ?? "",
      recipientPhone: map['recipientPhone']?["number"] ?? "",
      recipientPhoneCode: map['recipientPhone']?['code'] ?? "",
      size: map['size'] ?? 0,
    );
  }
}

class UserOrderCartData {
  final String cartId;
  final String vendorId;
  final List<CartItem> products;

  UserOrderCartData(
      {required this.cartId, required this.vendorId, required this.products});

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'vendorId': vendorId,
      'products': products,
    };
  }

  factory UserOrderCartData.fromMap(Map<String, dynamic> map) {
    List<CartItem> products = [];
    if (map["products"] != null) {
      map["products"].forEach((e) {
        products.add(
          CartItem.fromMap(e),
        );
      });
    }
    return UserOrderCartData(
      cartId: map['cartId'] ?? "",
      vendorId: map['vendorId'] ?? "",
      products: products,
    );
  }

  @override
  String toString() {
    return 'UserOrderCartData{cartId: $cartId, vendorId: $vendorId, products: $products}';
  }
}
