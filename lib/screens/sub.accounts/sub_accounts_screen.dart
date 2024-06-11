import 'package:ai_kampo_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/models/family_request.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/register_account_controller.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'package:ai_kampo_app/widgets/common/dynamic_listview.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';

import '../../common/config.dart';


class SubAccountsScreen extends StatefulWidget {
  const SubAccountsScreen({super.key});

  @override
  State<SubAccountsScreen> createState() => _SubAccountsScreenState();
}

class _SubAccountsScreenState extends State<SubAccountsScreen> {
  final AccountController _accountController = Get.find<AccountController>();
  final SubAccountController _subAccountController = SubAccountController();

  final List<Widget> _tabs = [
    const Tab(text: "家庭成員"),
    const Tab(text: "家庭邀請紀錄"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: const Text("家庭管理"),
        actions: [
          IconButton(
            onPressed: () {
              if (_accountController.isFamilyHolder.value) {
                Get.toNamed(
                  "/add.sub.account",
                  arguments: {"subAccountController": _subAccountController},
                );
              }
              else {
                KampoDialog.confirmToPop(context, "請先建立家庭", "請在「家庭成員」頁面點擊「建立家庭」!");
              }
            },
            icon: const Icon(CupertinoIcons.person_add),
          )
        ],
      ),
      body: Obx(
        () => _accountController.isLoading.value?
          const Center(
            child: CircularProgressIndicator(),
          ):
          DefaultTabController(
            length: _tabs.length,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.blue,
                  tabs: _tabs,
                  labelStyle: const TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const FamilyMemberContent(),
                      FamilyRequestContent(
                        subAccountController: _subAccountController
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class FamilyRequestContent extends StatefulWidget {
  final SubAccountController subAccountController;
  const FamilyRequestContent({super.key, required this.subAccountController});

  @override
  State<FamilyRequestContent> createState() => _FamilyRequestContentState();
}

class _FamilyRequestContentState extends State<FamilyRequestContent>
    with DynamicListView {
  final AccountController _accountController = Get.find<AccountController>();
  final loadingRequestId = <String>[].obs;
  late SubAccountController subAccountController;
  final ScrollController _scrollController = ScrollController();
  bool _scrollInit = false;

  @override
  void initState() {
    super.initState();
    subAccountController = widget.subAccountController;
    _onSearch();
  }

  void reverseShowPending() {
    subAccountController.reverseShowPendingOnly();
    _onSearch();
  }

  Future<void> _onSearch() async {
    print("_onSearch");
    // init DynamicLoadListView
    allDataFetched.value = false;
    if (false == _scrollInit) {
      initScroll(controller: _scrollController, onScrollEnd: _onScrollEnd);
      _scrollInit = true;
    }
    await subAccountController.refreshFamilyRequests();
    checkInitialExtent();
  }

  Future<void> _onScrollEnd() async {
    print("_onScrollEnd");
    int previousNumResults = subAccountController.familyRequests.length;
    await subAccountController.moreFamilyRequests();
    if (previousNumResults == subAccountController.familyRequests.length) {
      allDataFetched.value = true;
    }
  }

  Future<void> _onRequestAccept(String requestId) async {
    loadingRequestId.add(requestId);
    String? errMessage = await subAccountController.updateRequest(
      requestId, RegisterState.accepted);
    if (errMessage != null) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法更新邀請紀錄", errMessage);
      }
    }
    loadingRequestId.remove(requestId);
  }

  Future<void> _onRequestReject(String requestId) async {
    loadingRequestId.add(requestId);
    String? errMessage = await subAccountController.updateRequest(
      requestId, RegisterState.rejected);
    if (errMessage != null) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法更新邀請紀錄", errMessage);
      }
    }
    loadingRequestId.remove(requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(subAccountController.searching.value) {
        return const Center(child: CircularProgressIndicator());
      }
      Widget filterButton = TextButton(
        onPressed: reverseShowPending,
        child: Row(
          children: [
            Obx(() {
              return Icon(
                  subAccountController.showPendingOnly.value?
                  Icons.check_box: Icons.check_box_outline_blank
              );
            }),
            const Text("僅顯示尚未確認或拒絕的紀錄"),
          ],
        ),
      );
      if(subAccountController.familyRequests.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            filterButton,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("目前沒有家庭邀請紀錄", style: TextStyle(fontSize: 22)),
                  const Divider(color: Colors.transparent),
                  TextButton(
                    onPressed: subAccountController.refreshFamilyRequests,
                    child: const Text(
                      "重新整理", style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }
      else {
        return Column(
          children: [
            filterButton,
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onSearch,
                child: Obx(() {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    itemBuilder: (BuildContext context, int i) {
                      FamilyRequest request = subAccountController.familyRequests[i];
                      return Card(
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            const VerticalDivider(color: Colors.transparent),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    height: 16,
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    request.familyMemberPhone,
                                    style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(
                                    height: 5,
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    request.registerDate != null?
                                    dateTimeToYearUntilMinute(request.registerDate!): "-"
                                  ),
                                  const Divider(
                                    height: 16,
                                    color: Colors.transparent,
                                  ),
                                ]
                              ),
                            ),
                            const VerticalDivider(color: Colors.transparent),
                            if (
                              request.state == RegisterState.pending &&
                              false == _accountController.isFamilyHolder.value
                            )
                              Obx(() {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                                  onPressed: loadingRequestId.contains(request.requestId)?
                                    null: () => _onRequestAccept(request.requestId),
                                  child: const Text("確認"),
                                );
                              }),
                            if (
                              request.state == RegisterState.pending &&
                              false == _accountController.isFamilyHolder.value
                            )
                              const VerticalDivider(color: Colors.transparent),
                            if (request.state == RegisterState.pending)
                              Obx(() {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                                  onPressed: loadingRequestId.contains(request.requestId)?
                                    null: () => _onRequestReject(request.requestId),
                                  child: const Text("拒絕"),
                                );
                              }),
                            if (request.state == RegisterState.accepted)
                              Text(
                                "已確認",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            if (request.state == RegisterState.rejected)
                              Text(
                                "已拒絕",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800],
                                ),
                              ),
                            const VerticalDivider(color: Colors.transparent),
                          ],
                        )
                      );
                    },
                    itemCount: subAccountController.familyRequests.length,
                  );
                }),
              ),
            ),
          ],
        );
      }
    });
  }
}


class FamilyMemberContent extends StatefulWidget {
  const FamilyMemberContent({super.key});

  @override
  State<FamilyMemberContent> createState() => _FamilyMemberContentState();
}

class _FamilyMemberContentState extends State<FamilyMemberContent> {
  final _isLoading = false.obs;
  final AccountController _accountController = Get.find<AccountController>();

  Future<void> refreshMemberList() async {
    _isLoading.value = true;
    await _accountController.refreshAll();
    _isLoading.value = false;
  }

  Future<void> _handleCreateFamily() async {
    _isLoading.value = true;
    String? errMessage = await _accountController.createFamily();
    if (errMessage != null) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法建立家庭", errMessage);
      }
    }
    _isLoading.value = false;
  }

  Future<void> _handleDeleteSubAccount(String memberUid) async {
    _isLoading.value = true;
    String? errMessage = await _accountController.removeMember(memberUid);
    if (errMessage == null) {
      if (mounted) KampoDialog.confirmToPop(context, "", "家庭成員已刪除");
    }
    else {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法刪除家庭成員", errMessage);
      }
    }
    _isLoading.value = false;
  }

  Future<void> _handleDismiss() async {
    _isLoading.value = true;
    String? errMessage = await _accountController.dismissFamily();
    if (errMessage != null) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法解散家庭", errMessage);
      }
    }
    _isLoading.value = false;
  }

  void confirmToCreateDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("確定要建立家庭？"),
        content: const Text("您的家庭邀請紀錄將會清空"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('確定'),
            onPressed: () {
              Get.back();
              _handleCreateFamily();
            },
          ),
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  void confirmToDismissDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("確定要解散家庭？"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('確定'),
            onPressed: () {
              Get.back();
              _handleDismiss();
            },
          ),
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  void confirmToRemoveDialog(String subAccountUid) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("確定要刪除？"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('確定'),
            onPressed: () {
              Get.back();
              _handleDeleteSubAccount(subAccountUid);
            },
          ),
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      UserData? holderData = _accountController.holderAccountData.value;
      List<UserData> subAccountsData = _accountController.subAccountsData;
      if (_accountController.familyHolder.isNotEmpty) {
        return Column(
          children: [
            if (holderData != null)
              Card(
                color: Colors.cyan[100],
                child: ListTile(
                  title: const Text("家庭主成員帳號"),
                  subtitle: Text(
                    '${holderData.username}  ${holderData.phoneNumber}',
                  ),
                  trailing: _accountController.isFamilyHolder.value?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[800],
                      ),
                      onPressed: confirmToDismissDialog,
                      child: const Text("解散家庭", style: TextStyle(fontSize: 16)),
                    ):
                    const SizedBox.shrink(),
                ),
              ),
            if (holderData != null)
              const Divider(color: Colors.transparent),
            if (subAccountsData.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("目前沒有家庭成員", style: TextStyle(fontSize: 22)),
                    const Divider(color: Colors.transparent),
                    TextButton(
                      onPressed: refreshMemberList,
                      child: const Text(
                        "重新整理", style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            if (subAccountsData.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshMemberList,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: subAccountsData.length,
                    itemBuilder: (context, index) {
                      final account = subAccountsData[index];
                      return Container(
                        color: _accountController.userId.value == account.uid?
                          Colors.grey[200]: null,
                        child: ListTile(
                          leading: Icon(
                            account.sex == 'M' ? Icons.male : Icons.female,
                            color: account.sex == 'M' ? Colors.blue : Colors.red,
                            size: 48,
                          ),
                          title: Text(account.username),
                          subtitle: account.noPhoneUser?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${account.birthday == null? "": dateTimeToYearUntilDay(account.birthday!)}  "
                                  "${account.sex == "M"? "男": "女"}  "
                                  "${UserProfile.bloodTypeList[int.parse(account.bloodType)]}型",
                                ),
                                const Text("無電話號碼"),
                              ],
                            ):
                            Text(account.phoneNumber),
                          trailing: _accountController.isFamilyHolder.value ||
                            _accountController.userId.value == account.uid?
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () => confirmToRemoveDialog(account.uid),
                            ):
                            const SizedBox.shrink(),
                        ),
                      );
                    }
                  ),
                )
              ),
          ],
        );
      }
      else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: confirmToCreateDialog,
              child: const Text("建立家庭", style: TextStyle(fontSize: 20)),
            ),
            const Divider(color: Colors.transparent),
            const Text(
              "您的帳號類別目前為個人用戶",
              style: TextStyle(fontSize: 22),
            ),
            const Divider(color: Colors.transparent),
            TextButton(
              onPressed: refreshMemberList,
              child: const Text(
                "重新整理", style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      }
    });
  }
}

