import 'package:flutter/material.dart';
import 'package:goal_habit_tracker_app/timer_screen/timer_screen_page.dart';

void main() {
  runApp(FrontPage());
}

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit tracker',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: SimpleAnimatedList(),
    );
  }
}

class SimpleAnimatedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Habit tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                background: Image.asset(
                  'images/tree.jpeg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: SliceAnimatedList(),
        ),
      ),
    );
  }
}

//

class SliceAnimatedList extends StatefulWidget {
  @override
  _SliceAnimatedListState createState() => _SliceAnimatedListState();
}

class _SliceAnimatedListState extends State<SliceAnimatedList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<int> _items = [];
  int counter = 0;

  Widget slideIt(BuildContext context, int index, animation) {
    int item = _items[index];
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Item $item', style: textStyle),
              Spacer(),
              RaisedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(
                      title: 'timer',
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            height: double.infinity,
            child: AnimatedList(
              key: listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return slideIt(context, index, animation);
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    listKey.currentState.insertItem(0,
                        duration: const Duration(milliseconds: 500));
                    _items = []
                      ..add(counter++)
                      ..addAll(_items);
                  });
                },
                child: Text(
                  "Add item to first",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              FlatButton(
                onPressed: () {
                  if (_items.length <= 1) return;
                  listKey.currentState.removeItem(
                      0, (_, animation) => slideIt(context, 0, animation),
                      duration: const Duration(milliseconds: 500));
                  setState(() {
                    _items.removeAt(0);
                  });
                },
                child: Text(
                  "Remove first item",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
