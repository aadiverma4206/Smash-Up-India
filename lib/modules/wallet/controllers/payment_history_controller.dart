import 'package:get/get.dart';
import '../repositories/wallet_repository.dart';
import '../../../data/models/wallet_models.dart';

class PlayerPaymentHistoryController extends GetxController {
  final WalletRepository repository = Get.find<WalletRepository>();

  final RxList<WalletTransactionModel> allTransactions =
      <WalletTransactionModel>[].obs;
  final RxList<WalletTransactionModel> filteredTransactions =
      <WalletTransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString selectedTypeFilter = 'ALL'.obs; // ALL, TOPUP, DEBIT, REFUND

  final typeFilters = ['ALL', 'TOPUP', 'DEBIT', 'REFUND'];

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final list = await repository.getTransactions(page: 1, limit: 50);
      allTransactions.value = list;
      applyFilter();
    } catch (e) {
      allTransactions.clear();
      filteredTransactions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    if (selectedTypeFilter.value == 'ALL') {
      filteredTransactions.value = List.from(allTransactions);
    } else {
      filteredTransactions.value = allTransactions
          .where((t) =>
              t.transactionType.toUpperCase() ==
              selectedTypeFilter.value.toUpperCase())
          .toList();
    }
  }

  void setTypeFilter(String type) {
    selectedTypeFilter.value = type;
    applyFilter();
  }
}
