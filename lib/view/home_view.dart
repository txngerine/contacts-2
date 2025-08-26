// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart'; // <-- Added
import 'faq_view.dart';
import 'importcontactvcf.dart';
import 'recycleview.dart';
import 'show_groups_page.dart';
import 'contactsview.dart';
import 'admin_view.dart';
import 'fav_view.dart';
import 'importcontact.dart';
import 'privacypolicy.dart';
import 'profile_view.dart';
import 'termsandconditionpage.dart';

class HomeView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final HomeController homeController = Get.put(HomeController());

  HomeView({Key? key}) : super(key: key);

  Widget buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = authController.userRole.value.isNotEmpty;
      final isAdmin = authController.userRole.value == 'admin';

      final List<Widget> tabs = [
        if (isLoggedIn) ContactsView(),
        FavoriteContactsPage(),
        ShowGroupsPage(),
        if (isAdmin) AdminView(),
        ProfileView(),
        RecycleBinView(), // Added Recycle Bin View
      ];

      final List<FlashyTabBarItem> tabItems = [
        if (isLoggedIn)
          FlashyTabBarItem(
            icon: Icon(Icons.contacts),
            title: Text('All Contacts'),
          ),
        FlashyTabBarItem(
          icon: Icon(Icons.favorite),
          title: Text('Favorites'),
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.group),
          title: Text('Groups'),
        ),
        if (isAdmin)
          FlashyTabBarItem(
            icon: Icon(Icons.admin_panel_settings),
            title: Text('Manage'),
          ),
        FlashyTabBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ];

      return WillPopScope(
        onWillPop: () async => false, // Prevent back navigation
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Obx(() {
              final username = authController.username.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdmin ? 'Admin Management' : 'My Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    '$username',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ],
              );
            }),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'import') {
                    Get.to(ContactImportView());
                  } else if (value == 'profile') {
                    Get.to(ProfileView());
                  } else if (value == 'Privacy and Policy') {
                    Get.to(PrivacyPolicyPage());
                  } else if (value == 'terms and condition') {
                    Get.to(TermsAndConditionsPage());
                  } else if (value == 'vcf') {
                    Get.to(ContactImportFromVcfView());
                  } else if (value == 'faq') {
                    Get.to(FaqView());
                  }else if (value == 'Recycle Bin') {
                    Get.to(RecycleBinView());
                  }else if (value == 'logout') {
                    authController.logout();
                  }
                },
                itemBuilder: (context) => [
                  if (isLoggedIn)
                    PopupMenuItem(
                      value: 'import',
                      child: Text('Import Contacts'),
                    ),
                  PopupMenuItem(
                    value: 'profile',
                    child: Text('Profile Details'),
                  ),
                  PopupMenuItem(
                    value: 'vcf',
                    child: Text('Import VCF Contacts'),
                  ),
                  PopupMenuItem(
                    value: 'terms and condition',
                    child: Text('Terms and Condition'),
                  ),
                  PopupMenuItem(
                    value: 'Privacy and Policy',
                    child: Text('Privacy and Policy Page'),
                  ),
                  PopupMenuItem(
                    value: 'faq',
                    child: Text('F A Q'),
                  ),
                  PopupMenuItem(
                    value: 'Recycle Bin',
                    child: Text('Recycle Bin'),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          body: Obx(() {
            if (homeController.isLoading.value &&
                homeController.selectedIndex.value == 0) {
              return buildShimmerPlaceholder();
            } else {
              return tabs[homeController.selectedIndex.value];
            }
          }),
          bottomNavigationBar: Obx(() {
            return FlashyTabBar(
              selectedIndex: homeController.selectedIndex.value,
              onItemSelected: (index) {
                homeController.loadPage(index);
              },
              items: tabItems,
            );
          }),
        ),
      );
    });
  }
}
