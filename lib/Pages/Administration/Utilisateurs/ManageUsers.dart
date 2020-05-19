import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Pages/Administration/HomeCompos.dart';
import 'package:mauripress/Pages/Administration/Utilisateurs/ManageUsers_Model.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

class ManageUsers extends StatelessWidget {
  final bool staffOnly;
  final bool isAssignment;
  final OneLine assignedLine;
  ManageUsers(
      {this.staffOnly = false, this.isAssignment = false, this.assignedLine}) {
    if (!locator.isRegistered<ManageUsersModel>())
      locator.registerLazySingleton<ManageUsersModel>(() => ManageUsersModel());
    var daModel = locator.get<ManageUsersModel>();
    daModel.initModel(
        staff: staffOnly,
        isAssignment: isAssignment,
        assignedLine: assignedLine);
  }
  // locator.registerLazySingleton<ManageUsersModel>(() => ManageUsersModel());
  @override
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;
    var daModel = locator.get<ManageUsersModel>();
    return ChangeNotifierProvider<ManageUsersModel>(
      lazy: true,
      create: (context) => locator.get<ManageUsersModel>(),
      child: Scaffold(
        // appBar: barMe(title: "Utilisateurs", context: context, issetting: false),
        appBar: MyAppBar(
            title: isAssignment
                ? "Assigner à"
                : (staffOnly ? "Personnel" : "Utilisateurs"),
            ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GreyInput(
              width: dawidth - 30,
              onSubmitted: (text) {
                daModel.searchUser(text.trim());
              },
              isSearch: true,
              daHint: "Chercher un utilisateur",
            ),
            if (isAssignment)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Suggestions :",
                            style: DaWeights(Colors.cyan).szB.medfont),
                        Text(" le livreur le plus proche",
                            style: greyTxt.szA.regfont),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 80,
                    child: Consumer<ManageUsersModel>(
                      builder: (context, daModel, child) {
                        if (daModel.closestUsers.length == 0) if (daModel
                            .isFetching)
                          return Center(child: CircularProgressIndicator());
                        else
                          return Text("Aucune suggestion disponible !");
                        else
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: daModel.closestUsers.length,
                              itemBuilder: (context, index) {
                                return SuggestedUser(
                                    daUser: daModel.closestUsers[index]);
                              });
                      },
                    ),
                  )
                ],
              ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Résultat de recherche:",
                  style: TextStyle(fontSize: 18, color: Colors.cyan)),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Consumer<ManageUsersModel>(
                builder: (context, myModel, child) => ListView.builder(
                  itemCount: myModel.searchResults.length > 50
                      ? 50
                      : myModel.searchResults.length,
                  itemBuilder: (context, index) {
                    if (daModel.searchResults.length == 0) if (daModel
                        .isFetching)
                      return Center(child: CircularProgressIndicator());
                    else
                      return Text("Aucune livreur disponible !");
                    else
                      return UserTile(
                          daUser: myModel.searchResults[index],
                          context: context,
                          isAssignment: isAssignment);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
