import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Pages/OrderListPage/LineDetails.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Compos.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Model.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

class TabContent extends StatelessWidget {
  final bool isDelivered;
  final bool isCanceled;
  TabContent({
    Key key,
    this.isDelivered = false,
    this.isCanceled = false,
  }) : super(key: key);
  var daModel = locator.get<OrderListModel>();

  @override
  Widget build(BuildContext context) {
    // print('object');
    return Consumer<OrderListModel>(builder: (context, daModel, child) {
      var searchGroup = daModel.isSearchingByDate
              ? daModel.datedLines
              : daModel.landingLines,
          lineGroup = isCanceled
              ? searchGroup.canceledLines
              : (isDelivered
                  ? searchGroup.deliveredLines
                  : searchGroup.notYetLines);

      return !daModel.hasFetched
          ? Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  backgroundColor: aoi,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: lineGroup.length,
                      itemBuilder: (context, index) {
                        var whichLine = lineGroup[index];
                        var daCard = OrderCard(
                          daLine: whichLine,
                          inList: true,
                        );
                        return GestureDetector(
                          child: daCard,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LineDetails(
                                      daLine: whichLine,
                                      heroTag: "daCard$index",
                                    )));
                          },
                        );
                      }),
                ),
              ],
            );
    });
  }
}
