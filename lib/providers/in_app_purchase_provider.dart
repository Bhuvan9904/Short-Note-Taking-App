import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

// TODO: Add these dependencies to pubspec.yaml:
// dependencies:
//   in_app_purchase: ^3.1.11
//   in_app_purchase_storekit: ^0.3.6
//   shared_preferences: ^2.2.2

/// test ids
const nonConsumableId = kDebugMode ? "com.test.bet" : "";
const trophiesId = kDebugMode ? "com.zapp.testbuild.10006" : "";

/// nonConsumable  is non consumable
/// trophies  is consumable
enum ConsumItemName { nonConsumable, trophies }

Map<ConsumItemName, String> idsEnumToNameMap = {
  ConsumItemName.nonConsumable: nonConsumableId,
  ConsumItemName.trophies: trophiesId,
};

Map<String, ConsumItemName> nameToIdsMap = {
  nonConsumableId: ConsumItemName.nonConsumable,
  trophiesId: ConsumItemName.trophies,
};

List<ConsumItemName> consumableItems = [
  ConsumItemName.trophies,
];
List<ConsumItemName> nonConsumableItems = [
  ConsumItemName.nonConsumable,
];

class InAppPurchaseProvider extends ChangeNotifier {
  bool get serviceActive => _serviceActive;
  List<dynamic> get products => _products;

  // final Set<String> _itemIdentifiers = {
  //   nonConsumableId,
  // };

  bool _serviceActive = true;
  bool isPremiumMember = false;
  List<dynamic> _products = [];
  StreamSubscription<List<dynamic>>? _transactionStream;
  String? errorInfo;
  Set<ConsumItemName> purchasedItems = {};

  void showErrorDialogForPurchase([String? error]) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: const Text("Error"),
              content: Text(
                  "Some error occurred${kDebugMode ? (error ?? errorInfo ?? "") : ""}"),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text("Error"),
              content: Text(
                  "Some error occurred${kDebugMode ? (error ?? errorInfo ?? "") : ""}"),
              actions: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }

  // Add a global navigator key that should be set in your main app
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  InAppPurchaseProvider() {
    setupStoreData();
  }

  updateUI() {
    notifyListeners();
  }

  Future<bool> restorePurchases() async {
    // TODO: Implement with in_app_purchase package
    // For now, simulate restore
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(true);
  }

  // Compatibility method for existing code
  Future<bool> restoreItem() async {
    return await restorePurchases();
  }

  Future<void> setupStoreData() async {
    // TODO: Implement with in_app_purchase package
    // For now, simulate store setup
    _serviceActive = true;
    _products = []; // Empty for now
    
    final prefs = await SharedPreferences.getInstance();
    isPremiumMember = prefs.getBool('is_purchased') ?? false;
  }

  // Compatibility method for existing code
  Future<void> initStoreInfo() async {
    await setupStoreData();
  }


  bool isIdConsumable(String id) {
    int indexOfProductId = _products.indexWhere((e) => e.id == id);
    return indexOfProductId >= 0;
  }

  Future<void> finalizePurchase() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_purchased', true);
    isPremiumMember = true;
    notifyListeners();
  }

  // Compatibility method for existing code
  Future<void> deliverPurchase() async {
    await finalizePurchase();
  }

  Future<void> buyNonConsumableProduct(dynamic productDetails) async {
    // TODO: Implement with in_app_purchase package
    // For now, simulate purchase
    await Future.delayed(const Duration(seconds: 2));
    await finalizePurchase();
    _showPurchaseDialog();
  }

  // Compatibility method for existing code
  Future<void> buyProduct(dynamic product) async {
    await buyNonConsumableProduct(product);
  }

  Future<void> buyConsumableProduct(dynamic productDetails) async {
    // TODO: Implement with in_app_purchase package
    await Future.delayed(const Duration(seconds: 1));
  }

  Future buyItemBasedOnEnum(ConsumItemName item) async {
    String id = idsEnumToNameMap[item]!;

    int indexOfProductId = _products.indexWhere((e) => e.id == id);
    if (indexOfProductId >= 0) {
      if (consumableItems.contains(item)) {
        buyConsumableProduct(_products[indexOfProductId]);
      } else {
        buyNonConsumableProduct(_products[indexOfProductId]);
      }
    } else {
      // Simulate purchase for testing
      await buyNonConsumableProduct(null);
    }
  }

  buyNONConsumableInAppPurchase() {
    buyItemBasedOnEnum(ConsumItemName.nonConsumable);
  }

  @override
  void dispose() {
    _transactionStream?.cancel();
    super.dispose();
  }

  void handleCodeAfterConsumablePurchase(
    ConsumItemName item,
  ) async {
    /// you need to addd your custom consumable purchase logic here
    /// like coin purchased, so add coins in database etc
    /// show dialog that you purchased some coins
  }


  void _showPurchaseDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: const Text("Purchase Successful"),
              content: const Text("You have purchased the premium membership."),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text("Purchase Successful"),
              content: const Text("You have purchased the premium membership."),
              actions: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }
}