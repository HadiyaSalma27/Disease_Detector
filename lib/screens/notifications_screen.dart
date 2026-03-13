import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';

class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String lang =
        Provider.of<LanguageProvider>(context)
            .languageCode;

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(

        backgroundColor: Colors.green,

        elevation: 0,

        title: Text(
          AppStrings.text("notification", lang),
        ),

      ),

      body: Column(

        children: [

          SizedBox(height: 20),

          Text(

            AppStrings.text("notification", lang),

            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),

          ),

          SizedBox(height: 20),

          Expanded(

            child: ListView(

              padding: EdgeInsets.all(15),

              children: [

                notificationCard(

                  title: AppStrings.text(
                      "update_available", lang),

                  message: AppStrings.text(
                      "update_message", lang),

                  time: "2h ago",

                ),

                notificationCard(

                  title: AppStrings.text(
                      "disease_not_detected", lang),

                  message: AppStrings.text(
                      "healthy_message", lang),

                  time: AppStrings.text(
                      "yesterday", lang),

                ),

                notificationCard(

                  title: AppStrings.text(
                      "disease_identified", lang),

                  message: AppStrings.text(
                      "late_blight_message", lang),

                  time: "",

                ),

                notificationCard(

                  title: AppStrings.text(
                      "weekly_report", lang),

                  message: AppStrings.text(
                      "report_message", lang),

                  time: "April 21",

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }



  Widget notificationCard({

    required String title,

    required String message,

    required String time,

  }) {

    return Card(

      margin: EdgeInsets.only(bottom: 15),

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(15),

      ),

      elevation: 3,

      child: Padding(

        padding: EdgeInsets.all(15),

        child: Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            CircleAvatar(

              backgroundColor: Colors.red,

              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),

            ),

            SizedBox(width: 15),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Expanded(

                        child: Text(

                          title,

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      ),

                      Text(

                        time,

                        style: TextStyle(

                          color: Colors.grey,

                        ),

                      ),

                    ],

                  ),

                  SizedBox(height: 5),

                  Text(

                    message,

                    style: TextStyle(

                      color: Colors.grey[700],

                      fontSize: 15,

                    ),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}