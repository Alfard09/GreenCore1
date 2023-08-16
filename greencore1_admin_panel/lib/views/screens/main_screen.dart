import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/categories_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/dashboard_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/orders_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/products_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/upload_banner_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/vendors_screen.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/withdraw_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case VendorScreen.routeName:
        setState(() {
          _selectedItem = VendorScreen();
        });
        break;
      case CategoryScreen.routeName:
        setState(() {
          _selectedItem = CategoryScreen();
        });
        break;
      case OrderScreen.routeName:
        setState(() {
          _selectedItem = OrderScreen();
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          _selectedItem = ProductScreen();
        });
        break;
      case UploadBannerScreen.routeName:
        setState(() {
          _selectedItem = UploadBannerScreen();
        });
        break;
      case WithdrawScreen.routeName:
        setState(() {
          _selectedItem = WithdrawScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "GREEN CORE PANEL",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      sideBar: SideBar(
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: DashboardScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Vendors',
            icon: CupertinoIcons.person_3,
            route: VendorScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Withdraw',
            icon: CupertinoIcons.money_dollar,
            route: WithdrawScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Orders',
            icon: CupertinoIcons.shopping_cart,
            route: OrderScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: CategoryScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Product',
            icon: Icons.shop,
            route: ProductScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            icon: CupertinoIcons.add,
            route: UploadBannerScreen.routeName,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        // header: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: Colors.green,
        //   chil
        // ),
        footer: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text("Logout"),
          ),
          // Column(
          //   children: [
          //     Text("Logout")
          //     ListTile(
          //       title: Text("Logout"),
          //       trailing: Icon(Icons.logout),
          //       tileColor: Colors.grey,
          //     ),
          //   ],
          // ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
