import 'package:flutter/material.dart';
import './models/cardlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ScrollController scrollController;
  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;
  var currentColor = Colors.deepOrangeAccent[100];
  var appColors = [
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0)
  ];
  var cardIndex = 0;
  List<CardList> cardList = [
    CardList(
        title: 'Personal',
        icons: Icons.perm_identity,
        taskremaining: 9,
        taskcompletion: 9),
    CardList(
      title: 'Work',
      icons: Icons.work,
      taskcompletion: 50,
      taskremaining: 10,
    ),
    CardList(
      title: 'Home',
      icons: Icons.home,
      taskcompletion: 50,
      taskremaining: 2,
    ),
  ];
  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.clear_all,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          )
        ],
        elevation: 0,
        backgroundColor: currentColor,
      ),
      body: Container(
        width: double.maxFinite,
        color: currentColor,
        child: Padding(
          padding: EdgeInsets.only(left: 40, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.accessibility_new,
                ),
                maxRadius: 50,
                minRadius: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hello, Jane.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Looks like feel good.',
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'You have 3 things to do today.',
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'TODAY: SEPTEMBER 12,2019',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  height: 350,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          child: Container(
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: currentColor,
                                      child: Icon(
                                        cardList[index].icons,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      cardList[index].taskremaining.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    Text(cardList[index].title,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.deepPurpleAccent[300],
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      child: LinearProgressIndicator(
                                        value: cardList[index].taskcompletion,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onHorizontalDragEnd: (details) {
                          animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 1));
                          curvedAnimation = CurvedAnimation(
                              parent: animationController,
                              curve: Curves.fastOutSlowIn);
                          animationController.addListener(() {
                            setState(() {
                              currentColor =
                                  colorTween.evaluate(curvedAnimation);
                            });
                          });

                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            if (cardIndex > 0) {
                              cardIndex--;
                              colorTween = ColorTween(
                                  begin: currentColor,
                                  end: appColors[cardIndex]);
                            }
                          } else {
                            if (cardIndex < 2) {
                              cardIndex++;
                              colorTween = ColorTween(
                                  begin: currentColor,
                                  end: appColors[cardIndex]);
                            }
                          }
                          setState(() {
                            scrollController.animateTo((cardIndex) * 256.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                          });

                          colorTween.animate(curvedAnimation);

                          animationController.forward();
                        },
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    controller: scrollController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
