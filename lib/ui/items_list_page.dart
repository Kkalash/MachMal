import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/ui/sidenav.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/shared/models/item.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/loading_data.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';
import 'package:flutter_to_do_app/repository/item_repository.dart';
import 'package:flutter_to_do_app/widgets/items-list/add_item.dart';
import 'package:flutter_to_do_app/widgets/items-list/search_item.dart';
import 'package:flutter_to_do_app/widgets/items-list/delete_filter.dart';

class ItemsListPage extends StatelessWidget {
  final Category category;
  final ItemRepository itemRepository = ItemRepository();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static String? currentCategoryId;

  ItemsListPage({Key? key, required this.category}) : super(key: key) {
    currentCategoryId = category.id;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: tertiaryColor,
        systemNavigationBarColor: tertiaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));

    const borderSide = BorderSide(color: shadeColor, width: 0.3);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: SafeArea(
            child: Container(
                color: tertiaryColor,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(child: getItemsWidget()))),
        drawer: Sidenav(context: context),
        bottomNavigationBar: BottomAppBar(
          color: tertiaryColor,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              top: borderSide,
              bottom: borderSide,
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: primaryColor,
                      size: 28,
                    ),
                    onPressed: () => scaffoldKey.currentState?.openDrawer()),
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamilyRaleway,
                        fontStyle: FontStyle.italic,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  DeleteFilter(
                      categoryId: category.id!, repository: itemRepository),
                  SearchItem(
                    context: context,
                    categoryId: category.id!,
                    repository: itemRepository,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: AddItem(
            context: context,
            repository: itemRepository,
            categoryId: category.id!,
          ),
        ));
  }

  Widget getItemsWidget() {
    return StreamBuilder(
      stream: itemRepository.items,
      builder: (context, AsyncSnapshot<List<Item>> snapshot) {
        return getItemCardWidget(snapshot);
      },
    );
  }

  Widget getItemCardWidget(AsyncSnapshot<List<Item>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data?.isEmpty == true) {
        return const NoData(text: 'Start adding Item...');
      } else {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            Item item = snapshot.data![index];
            final Widget dismissibleCard = Dismissible(
              background: Container(
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deleting',
                      style: TextStyle(color: tertiaryColor),
                    ),
                  ),
                ),
                color: primaryAccentColor,
              ),
              onDismissed: (direction) =>
                  itemRepository.deleteItem(category.id!, item.id!),
              direction: DismissDirection.horizontal,
              key: UniqueKey(),
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: (shadeColor), width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: tertiaryColor,
                  child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        item.isDone = !item.isDone;

                        itemRepository.updateItem(category.id!, item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: item.isDone
                            ? const Icon(
                                Icons.done,
                                size: 26.0,
                                color: secondaryColor,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank,
                                size: 26.0,
                                color: secondaryColor,
                              ),
                      ),
                    ),
                    title: Text(
                      item.description,
                      style: TextStyle(
                          fontSize: 16.5,
                          fontFamily: fontFamilyRaleway,
                          fontWeight: FontWeight.w500,
                          decoration: item.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  )),
            );
            return dismissibleCard;
          },
        );
      }
    } else {
      itemRepository.getItemsByCategoryId(category.id!);

      return const Center(
        child: LoadingData(),
      );
    }
  }
}
