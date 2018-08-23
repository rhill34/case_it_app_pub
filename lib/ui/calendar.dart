import 'dart:async' show Future;
import 'dart:convert';
import "package:googleapis_auth/auth_io.dart";
import 'package:flutter/material.dart';

Future<List<Event>> loadEvent() async {
  var client = clientViaApiKey('AIzaSyBVyzYbA6oSCUb0hF_xefqEpgzLzDE4Oc8');

  var response = await client.get(
      "https://www.googleapis.com/calendar/v3/calendars/highlinecase%40gmail.com/events");

  final jsonResponse = json.decode(response.body);

  return (jsonResponse["items"] as List)
      .map<Event>((json) => new Event.fromJson(json))
      .toList();

//  Event event = new Event.fromJson(jsonResponse);
//  print(event.eventSum);
//  return event;
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

class EventDate {
  String eventDate;

  EventDate({this.eventDate});

  factory EventDate.fromJson(Map<String, dynamic> parsedJson) {
    return EventDate(
      eventDate: parsedJson['date'],
    );
  }
}

class Event {
  String eventSum;
  String eventDescription;

  //List<EventDate> startDate;

  Event({
    this.eventSum,
    this.eventDescription,
    //this.startDate,
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
//    var list = parsedJson['start'] as List;
//    print(list.runtimeType);
//    List<EventDate> dateList = list.map((i) => EventDate.fromJson(i)).toList();

    return Event(
      eventSum: parsedJson['summary'],
      eventDescription: parsedJson['description'],
      //startDate : dateList,
    );
  }
}

class EventList extends StatelessWidget {
  final List<Event> events;

  //final List<EventDate> eventDates;

  EventList({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: events.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd)
            return new Divider(
              color: Colors.green,
            );
          return new ListTile(
              //leading: new CircleAvatar(backgroundColor: highlineBlue,),
              title: new Text(
                "${events[position].eventSum}",
              ),
//              subtitle: new Text(
//                events[position].eventDescription == null
//                    ? ""
//                    : events[position].eventDescription + "\n" +
//                    //events[position].startDate.toString() +
//                        ".....",
//              ),
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
  @override
  Widget build(BuildContext context) {
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
                        onPressed: () => debugPrint("Pressed"),
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