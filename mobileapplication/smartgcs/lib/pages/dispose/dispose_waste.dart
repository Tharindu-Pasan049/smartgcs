import 'package:flutter/material.dart';

import '../../models/dispose_offering.dart';
import '../../models/offering.dart';


import '../../widgets/bottom_nav.dart';
import '../../widgets/custom_text.dart' as customText;
import '../../widgets/waste_category.dart';

import '../../utils/responsive.dart';

class DisposeWastePage extends StatelessWidget {
 

  Widget _buildCategoryWidget(
      BuildContext context, String wasteType, String imageUrl,
      [dynamic route]) {
    return WasteCategory(imageUrl, wasteType, OfferingType.dispose);
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getSize(context, 30)),
      child: _buildAllCategories(context),
    );
  }

  Column _buildAllCategories(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCategoryWidget(
                context, DisposeWasteType.householdWaste, 'assets/house.png'),
            _buildCategoryWidget(context, DisposeWasteType.industrialWaste,
                'assets/industrial.png')
          ],
        ),
        SizedBox(
          height: getSize(context, 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCategoryWidget(
                context, DisposeWasteType.agricWaste, 'assets/harvest.png'),
            _buildCategoryWidget(
                context, DisposeWasteType.bulkWaste, 'assets/bulk.png')
          ],
        ),
        SizedBox(
          height: getSize(context, 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCategoryWidget(context, DisposeWasteType.nuclearWaste,
                'assets/nuclear-plant.png'),
            _buildCategoryWidget(context, DisposeWasteType.otherWaste,
                'assets/throw-to-paper-bin.png')
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispose Waste'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: getSize(context, 200),
            color: Theme.of(context).primaryColor,
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: getSize(context, 18)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: getSize(context, 20)),
                    child: Image(
                      height: getSize(context, 50),
                      image: AssetImage('assets/garbage-can.png'),
                    ),
                  ),
                  _buildCategoriesSection(context)
                ],
                // children: _buildCategories(context)
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
