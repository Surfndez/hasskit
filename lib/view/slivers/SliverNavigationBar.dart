import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hasskit/helper/GeneralData.dart';
import 'package:hasskit/helper/MaterialDesignIcons.dart';
import 'package:hasskit/helper/ThemeInfo.dart';
import 'package:provider/provider.dart';

import '../CustomPopupMenu.dart';

class SliverNavigationBar extends StatelessWidget {
  final int roomIndex;
  const SliverNavigationBar({@required this.roomIndex});

  @override
  Widget build(BuildContext context) {
//    log.w("Widget build SliverNavigationBar");

    Widget temperatureWidget = Container();
    Color backgroundColor;
    Color iconColor;

    IconData topIcon;
    if (gd.viewMode == ViewMode.edit || gd.viewMode == ViewMode.sort) {
      topIcon = MaterialDesignIcons.getIconDataFromIconName("mdi:content-save");
    } else {
      topIcon = Icons.menu;
    }

    return Selector<GeneralData, String>(
      selector: (_, generalData) => "${generalData.roomList.length} "
          "${generalData.roomList[roomIndex].imageIndex} "
          "${generalData.roomList[roomIndex].tempEntityId} "
          "${generalData.roomList[roomIndex].entities.length} "
          "${generalData.eventsEntity} "
          "${generalData.entitiesStatusShow} "
          "${generalData.entitiesStatusRunning.length} "
          "${generalData.viewMode} ",
      builder: (context, data, child) {
        //        if (roomIndex != null &&
//            gd.roomList[roomIndex] != null &&
//            gd.roomList[roomIndex].tempEntityId != null &&
//            gd.roomList[roomIndex].tempEntityId.length > 0 &&
//            gd.entities[gd.roomList[roomIndex].tempEntityId].state != null &&
//            gd.entities[gd.roomList[roomIndex].tempEntityId].state.length > 0) {

        double tempState;
        try {
          tempState = double.tryParse(
              gd.entities[gd.roomList[roomIndex].tempEntityId].state);
        } catch (e) {
//          log.w("tempState $e");
        }

        if (tempState != null) {
//          log.d("tempState $tempState");

          if (tempState > 35) {
            backgroundColor = ThemeInfo.colorTemp05.withOpacity(0.5);
            iconColor = ThemeInfo.colorTemp05;
          } else if (tempState > 30) {
            backgroundColor = ThemeInfo.colorTemp04.withOpacity(0.5);
            iconColor = ThemeInfo.colorTemp04;
          } else if (tempState > 20) {
            backgroundColor = ThemeInfo.colorTemp03.withOpacity(0.5);
            iconColor = ThemeInfo.colorTemp03;
          } else if (tempState > 15) {
            backgroundColor = ThemeInfo.colorTemp02.withOpacity(0.5);
            iconColor = ThemeInfo.colorTemp02;
          } else {
            backgroundColor = ThemeInfo.colorTemp01.withOpacity(0.5);
            iconColor = ThemeInfo.colorTemp01;
          }
          temperatureWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(3, 0, 12, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: ThemeInfo.colorBottomSheet.withOpacity(0.5),
                ),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Icon(
                          MaterialDesignIcons.getIconDataFromIconName(
                              "mdi:thermometer"),
                          size: 24,
                          color: iconColor,
                        ),
                      ],
                      alignment: Alignment.center,
                    ),
//                    SizedBox(width: 2),
                    Text("${tempState.toStringAsFixed(1)}°",
                        textScaleFactor: gd.textScaleFactor),
                  ],
                ),
              ),
            ],
          );
        }

        return CupertinoSliverNavigationBar(
          leading: temperatureWidget,
          backgroundColor: backgroundColor,
          largeTitle: Text(
            gd.getRoomName(roomIndex),
            textScaleFactor: gd.textScaleFactor,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                gd.entitiesStatusRunning.length > 0
                    ? InkWell(
                        onTap: () {
                          gd.entitiesStatusShow = !gd.entitiesStatusShow;
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Icon(Icons.notifications,
                                color: Theme.of(context).textTheme.title.color),
                            Container(
                              width: 15,
                              height: 15,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                child: Text(
                                  "${gd.entitiesStatusRunning.length}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                gd.roomList.length > 0
                    ? InkWell(
                        onTap: () {
                          if (gd.viewMode != ViewMode.sort &&
                              gd.viewMode != ViewMode.edit) {
                            bottomSheetMenu.mainBottomSheet(roomIndex, context);
                          } else {
                            gd.viewMode = ViewMode.normal;
                          }
                        },
                        child: Container(
//                          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(4),
//                              color: Colors.black.withOpacity(0.5)),
                          child: Icon(
                            topIcon,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
