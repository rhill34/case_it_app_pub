import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../ui/login_screen.dart';

class Jobs extends StatefulWidget {
  final String dep;

  // Constructor so we can pass information from previous page
  Jobs({Key key, this.dep}) : super(key: key);

  @override
  _JobsState createState() => new _JobsState();
}

class _JobsState extends State<Jobs> {
  @override
  Widget build(BuildContext context) {
    // Our future builder that handles our data we're getting
    Widget futureBuilder([String department]) {
      return new FutureBuilder(
          future:
              _getData(department == null ? department = "jobs" : department),
          //_getData("jobs"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Center(
                  child: new Text(
                    'Oops! We\'re sorry! Please try again!',
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: highlineBlue),
                  ),
                );
              case ConnectionState.waiting:
                return new Center(
                  child: new Text(
                    'Loading...',
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: highlineBlue),
                  ),
                );
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  print(department);
                return createJobListView(context, snapshot);
            }
          });
    }

    return new Scaffold(
      endDrawer: new AppDrawer(),
      appBar: new AppBar(
        title: new Text(
          "CASE IT",
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: highlineBlue,
        automaticallyImplyLeading: false,
      ),
      body: futureBuilder(widget.dep),
    );
  }

  // ListView for the jobs we're pulling
  Widget createJobListView(BuildContext context, AsyncSnapshot snapshot) {
    List _data = snapshot.data;
    return new ListView.builder(
        itemCount: _data.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, int position) {
          if (position == 0)
            return new Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${_data[0]['id']}".toUpperCase(),
                style: jobTitleStyle(),
                textAlign: TextAlign.center,
              ),
            );
          if (position.isOdd)
            return new Divider(
              color: highlineGreen,
            );
          return new ListTile(
              title: new Text(
                "${_data[position]['position_title']}",
                style: jobTitleStyle(),
              ),
              subtitle: new Text(
                "${_data[position]['organization_name']}",
                style: descriptionStyle(),
              ),
              onTap: () {
                var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new JobDetails(
                      position: _data[position]['position_title'],
                      organization: _data[position]['organization_name'],
                      start: _data[position]['start_date'],
                      end: _data[position]['end_date']);
                });
                Navigator.of(context).push(router);
              });
        });
  }
}

// Get the jobs from a JSON object
Future<List> _getData([String job]) async {
  String apiUrl = "https://jobs.search.gov/jobs/search.json?query=$job";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

// Show the job details
class JobDetails extends StatefulWidget {
  final String position;
  final String organization;
  final String start;
  final String end;

  // Constructor so we can pass information from previous page
  JobDetails({Key key, this.position, this.organization, this.start, this.end})
      : super(key: key);

  @override
  _JobDetailsState createState() => new _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      endDrawer: new AppDrawer(),
      appBar: new AppBar(
        title: new Text(
          "CASE IT",
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: highlineBlue,
      ),
      body: new ListView(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleContainer("Job Title:"),
              detailsContainer(widget.position),
              titleContainer("Organization:"),
              detailsContainer(widget.organization),
              titleContainer("Start Date:"),
              detailsContainer(widget.start),
              titleContainer("End Date:"),
              detailsContainer(widget.end),
            ],
          ),
        ],
      ),
    );
  }

  // Show title for parts of job: job title, description, start date, etc.
  Widget titleContainer(String title) {
    return new Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(top: 10.0, left: 10.0),
      child: new Text(
        title,
        style: jobTitleStyle(),
      ),
    );
  }

  // Show the actual details regarding the job
  Widget detailsContainer(String data) {
    return new Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(left: 10.0),
      child: new Text(
        data,
        style: descriptionStyle(),
      ),
    );
  }
}

// Make an App Drawer
class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _drawerList = ["nursing", "part-time jobs", "full-time jobs", "logout"];

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Container(
        color: highlineBlue,
        child: new ListView(
          children: _displayDrawerItems(),
        ),
      ),
    );
  }

  // Display the items in the drawer
  List<Widget> _displayDrawerItems() {
    List<Widget> widgetList = new List();
    for (int i = 0; i < _drawerList.length; i++) {
      widgetList.add(new ListTile(
        title: new Text(
          "${_drawerList[i]}".toUpperCase(),
          style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: highlineGreen,
          ),
        ),
        onTap: () {
          var router = new MaterialPageRoute(builder: (BuildContext context) {
            String fetchData;
            switch (i) {
              case 0:
                fetchData = "nursing+jobs+in+ny";
                break;
              case 1:
                fetchData = "part-time+jobs";
                break;
              case 2:
                fetchData = "full-time+jobs";
                break;
            }
            //print(fetchData);
              return new Jobs(dep: fetchData,);

          });
//          if (googleSignIn.currentUser == null) {
//            Navigator.push(
//                context, new MaterialPageRoute(builder: (BuildContext context) {
//              return new Login();
//
//            }));
//            Navigator.pop(context);
//          }
          if (i == 3) {
            handleSignOut();
            Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
          }
          else {
            Navigator.of(context).push(router);
          }
        },
      ));

      widgetList.add(new Divider(
        color: highlineGreen,
      ));
    }
    return widgetList;
  }
}

// The blue color on Highline website
var highlineBlue = const Color(0xFF35556D);

// The green color on Highline website
var highlineGreen = const Color(0xFF67BB5B);

TextStyle jobTitleStyle() {
  return new TextStyle(
      color: highlineBlue, fontSize: 18.0, fontWeight: FontWeight.bold);
}

TextStyle descriptionStyle() {
  return new TextStyle(
      color: highlineBlue, fontSize: 18.0, fontWeight: FontWeight.w300);
}
