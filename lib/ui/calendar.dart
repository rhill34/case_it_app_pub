import 'dart:async' show Future;
import 'dart:convert';
import "package:googleapis_auth/auth_io.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<Event>> loadEvent() async {
  var client = clientViaApiKey('AIzaSyBVyzYbA6oSCUb0hF_xefqEpgzLzDE4Oc8');

  var response = await client.get(
      //"https://www.googleapis.com/calendar/v3/calendars/highlinecase%40gmail.com/events");
      "https://www.googleapis.com/calendar/v3/calendars/highlinecase%40gmail.com/events?maxResults=10&orderBy=updated&timeMax=2018-08-26T00%3A20%3A46%2B00%3A00&timeMin=2018-07-26T00%3A20%3A46%2B00%3A00&fields=items(description%2Cstart(date%2CdateTime)%2Csummary)");

  final jsonResponse = json.decode(response.body);

  return (jsonResponse["items"] as List)
      .map<Event>((json) => new Event.fromJson(json))
      .toList();
}

class KalPage extends StatelessWidget {
  final String title;

  KalPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: loadEvent(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? EventList(
                  events: snapshot.data,
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Event {
  String eventSum;
  String eventDescription;
  EventDat eventDat;
  //List<EventDat> eventDat;
  //List<EventDate> startDate;

  Event({
    this.eventSum,
    this.eventDescription,
    this.eventDat
  });

  factory Event.fromJson(Map<String,dynamic> parsedJson) {
    return Event(
      eventSum: parsedJson['summary'],
      eventDescription: parsedJson['description'],
      eventDat: EventDat.fromJson(parsedJson['start'])
    );
  }
}

//Event Date Class
class EventDat{
  //DateTime eventDat;
  String eventDat;

  EventDat({
    this.eventDat
  });

  factory EventDat.fromJson(Map<String, dynamic> json) {
    return EventDat(
      eventDat: json['dateTime'].toString(),
    );
  }
}

class EventList extends StatelessWidget {
  final List<Event> events;
  //final List<EventDate> eventDates;
  //final List<Event> dates;
  final List<EventDat> eventsDate;
  EventList({Key key, this.events, this.eventsDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: events.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, int position) {
          // if (position.isOdd)
          //   return new Divider(
          //     color: Colors.green,
          //   );
          return new ListTile(
              //leading: new CircleAvatar(backgroundColor: highlineBlue,),
              title: new Text(
                "${events[position].eventSum}",
              ),
             subtitle: new Text(
              //  events[position].eventDescription == null
              //      ? ""
              //      : events[position].eventDescription + "\n" +
                   
                   "${events[position].eventDat}" + "\n" +
                       ".....",
             ),
              onTap: () {
                var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new CalendarDetails(
                    summary: events[position].eventSum != null
                        ? events[position].eventSum
                        : "N/A",
                    description: events[position].eventDescription != null
                        ? events[position].eventDescription
                        : "N/A",
                  );
                });
                Navigator.of(context).push(router);
              });
        });
  }
}

// Show the job details
class CalendarDetails extends StatefulWidget {
  final String summary;
  final String description;

  // Constructor so we can pass information from previous page
  CalendarDetails({Key key, this.summary, this.description}) : super(key: key);

  @override
  _CalendarDetailsState createState() => new _CalendarDetailsState();
}

class _CalendarDetailsState extends State<CalendarDetails> {
  //To Launch the Form URL
  Future<Null> _launched;

    Future<Null> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://docs.google.com/forms/d/e/1FAIpQLScD_NTITFEGwJ-wyIg8_NMkbd9k_u0MGvwAB4VeDqREYcHE_Q/viewform?';
    return new Scaffold(
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
              titleContainer("Event:"),
              detailsContainer(widget.summary),
              titleContainer("Details:"),
              detailsContainer(widget.description),
              widget.description != "N/A"
                  ? new Center(
                      child: new FlatButton(
                        onPressed: () => setState(() {
                    _launched = _launchInWebViewOrVC(toLaunch);
                  }),
                        child: new Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 15.0),
                            padding: const EdgeInsets.all(15.0),
                            width: 300.0,
                            decoration: new BoxDecoration(color: highlineGreen),
                            child: new Text(
                              "SIGN UP",
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            )),
                      ),
                    )
                  : new Container(),
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
// import 'dart:async' show Future;
// import 'dart:convert';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:flutter/material.dart';

// //Load the Calendar Response
// Future<List<Evt>> loadEvent() async {
// //Auth Key to access Calendar API
//   var client = clientViaApiKey('AIzaSyBVyzYbA6oSCUb0hF_xefqEpgzLzDE4Oc8');
// //http API Call with Key to Load the Google Calendar JSON response
//   var response = await client.get(
//       //"https://www.googleapis.com/calendar/v3/calendars/highlinecase%40gmail.com/events");
//       "https://www.googleapis.com/calendar/v3/calendars/highlinecase%40gmail.com/events?maxResults=10&orderBy=updated&timeMax=2018-08-26T00%3A20%3A46%2B00%3A00&timeMin=2018-07-26T00%3A20%3A46%2B00%3A00&fields=items(description%2Cstart(date%2CdateTime)%2Csummary)");
//   final jsonResponse = json.decode(response.body);

//   print(jsonResponse);
//   return (jsonResponse["items"] as List).map<Evt>((json)=> new Evt.fromJson(json)).toList();
// }

// //Event Date Class
// class EventDat{
//   DateTime eventDat;

//   EventDat({
//     this.eventDat
//   });

//   factory EventDat.fromJson(Map<DateTime, dynamic> parsedJson) {
//     return EventDat(eventDat: parsedJson['start'],
//     );
//   }
// }
// //Class for Event
// class Evt{
//   final String ventSum;
//   final String ventDesc;
//   //final List<EventDat> ventDat;

//   Evt({
//     this.ventSum,
//     this.ventDesc,
//     //this.ventDat
//   });
//   factory Evt.fromJson(Map<String, dynamic> parsedJson) {
//     return Evt(
//       ventSum: parsedJson['summary'],
//       ventDesc: parsedJson['description'],
//       //ventDat: parsedJson['start']
//     );
//   }
// }
