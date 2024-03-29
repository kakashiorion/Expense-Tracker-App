import 'package:expense_tracker_app/transactionSummaryPage.dart';
import 'package:flutter/material.dart';

const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

enum Weekdays { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

enum Months {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December
}

enum TransactionType { Food, Travel, Shopping, Utility, Income }

const addedStyle =
    TextStyle(color: Color(0xff939393), fontSize: 12, fontFamily: 'Lato');
const addedLeftStyle = TextStyle(
    color: Color(
      0xff939393,
    ),
    fontSize: 10);
const double _kMyLinearProgressIndicatorHeight = 0.5;

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    required this.minHeight,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  final preferredSize =
      Size(double.infinity, _kMyLinearProgressIndicatorHeight);

  final double minHeight;
  final double value;
  final Color backgroundColor;
  final Animation<Color> valueColor;
}

class IconListTile extends StatelessWidget {
  IconListTile({required this.name, required this.icon, required this.onTap});

  final String name;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                disabledColor: Colors.white,
                color: Colors.white,
                icon: Icon(icon),
                onPressed: onTap,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailTile extends StatefulWidget {
  TransactionDetailTile(
      {required this.title,
      required this.icon,
      required this.details,
      required this.type});
  final String title;
  final Widget icon;
  final String details;
  final String type;

  @override
  _TransactionDetailTileState createState() => _TransactionDetailTileState();
}

class _TransactionDetailTileState extends State<TransactionDetailTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              child: widget.icon,
              radius: 18,
              backgroundColor:
                  widget.type == TransactionType.Income.toString().substring(16)
                      ? Colors.green
                      : Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: titleTextStyle,
                  ),
                  Text(
                    widget.details,
                    style: displayTextStyle,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  TransactionCard(
      {required this.type,
      required this.title,
      required this.time,
      required this.value,
      required this.tId});
  final String type;
  final String title;
  final String time;
  final String value;
  final String tId;

  Icon getIcon(String type) {
    if (type == TransactionType.Food.toString().substring(16)) {
      return Icon(
        Icons.fastfood_outlined,
        color: Colors.black,
      );
    } else if (type == TransactionType.Shopping.toString().substring(16)) {
      return Icon(
        Icons.shopping_basket_outlined,
        color: Colors.black,
      );
    } else if (type == TransactionType.Travel.toString().substring(16)) {
      return Icon(
        Icons.flight_outlined,
        color: Colors.black,
      );
    } else if (type == TransactionType.Utility.toString().substring(16)) {
      return Icon(
        Icons.wb_incandescent_outlined,
        color: Colors.black,
      );
    } else {
      return Icon(
        Icons.attach_money_outlined,
        color: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        enableFeedback: false,
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    TransactionSummaryPage(transactionId: tId)));
      },
      child: Card(
        margin: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: new BorderRadius.circular(5.0)),
                height: 40,
                width: 40,
                child: getIcon(type),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        title,
                        style: dayText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        time,
                        style: weekdayText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: type == "Income" ? greenText : dayText,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionInputTile extends StatelessWidget {
  TransactionInputTile(
      {required this.title,
      required this.inputWidget,
      required this.actionWidget});
  final String title;
  final Widget inputWidget;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.grey)
        ],
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      title,
                      style: titleTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: inputWidget,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: actionWidget,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTypeTile extends StatelessWidget {
  TransactionTypeTile(
      {required this.type, required this.circleAvatar, required this.onTap});

  final TransactionType type;
  final CircleAvatar circleAvatar;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0),
            ),
            backgroundColor: type == TransactionType.Income
                ? Colors.green
                : Colors.lightBlue,
            elevation: 8,
            shadowColor: Colors.grey,
          ),
          onPressed: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  child: getImage(type),
                  radius: 12,
                  backgroundColor: type == TransactionType.Income
                      ? Colors.green
                      : Colors.lightBlue,
                  foregroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  type.toString().substring(16),
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Icon getImage(type) {
  if (type == TransactionType.Food) {
    return Icon(
      Icons.restaurant_outlined,
      size: 20,
    );
  } else if (type == TransactionType.Travel) {
    return Icon(Icons.flight_outlined, size: 20);
  } else if (type == TransactionType.Shopping) {
    return Icon(Icons.shopping_basket_outlined, size: 20);
  } else if (type == TransactionType.Utility) {
    return Icon(Icons.wb_incandescent_outlined, size: 20);
  } else {
    return Icon(Icons.attach_money_outlined, size: 20);
  }
}

const budgetText =
    TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Lato');

const inputTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Colors.black);

const displayTextStyle = TextStyle(
    fontSize: 18,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Colors.black);

TextStyle titleTextStyle =
    TextStyle(fontSize: 10, fontFamily: 'Lato', color: Colors.grey[600]);

const weekdayText =
    TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'Lato');

const titleText =
    TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Lato');

const labelText =
    TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Lato');
const valueText =
    TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Lato');

const dayText = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold);

const greenText = TextStyle(
    color: Colors.green,
    fontSize: 12,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold);

const appBarTitleText = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold);
