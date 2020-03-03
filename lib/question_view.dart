import "dart:io";
import 'package:flutter/cupertino.dart';
import "package:dart_amqp/dart_amqp.dart";
import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  final String team;
  Question({this.team = 'No Team'});

  @override
  State<StatefulWidget> createState() {
    return QuestionState();
  }
}

class QuestionState extends State<Question> {
  bool isAvailableBtn;
  Consumer subscriber;
  Exchange publisher;


  void _activateBtn() {
    setState(() {
      isAvailableBtn = true;
    });
  }

  void _deactivateBtn() {
    setState(() {
      isAvailableBtn = false;
    });
  }

  void _initSubscribe() async {
    print('🌎Subscriber from cellphone to questions🌎');

    ConnectionSettings settings = new ConnectionSettings(
      host: 'buck.rmq.cloudamqp.com',
      port: 5672,
      virtualHost: 'kojrbtpc',
      authProvider:
      new PlainAuthenticator('kojrbtpc', 'cJ_G2rN4qgXEre76ru8qFOGxuy_nl44Z'),
    );
    Client client = new Client(settings: settings);

    // Setup a signal handler to cleanly exit if CTRL+C is pressed
    ProcessSignal.sigint.watch().listen((_) async {
      await client.close();
      exit(0);
    });

    Channel channel = await client.channel();
    Exchange exchange = await channel.exchange("questions", ExchangeType.FANOUT);

    subscriber = await exchange.bindPrivateQueueConsumer(null);

    print(
        " [*] Waiting for logs on private queue ${subscriber.queue
            .name}. To exit, press CTRL+C");

    subscriber.listen((message) {
      print(" [x] ${message.payloadAsString}");
//    client.close();
      _activateBtn();
      _startSleep();
    });
  }

  void _initPublisher() async{
    print("🔥Publisher from cellphone to answers🔥");
    ConnectionSettings settings = new ConnectionSettings(
      host: 'buck.rmq.cloudamqp.com',
      port: 5672,
      virtualHost: 'kojrbtpc',
      authProvider: new PlainAuthenticator(
          'kojrbtpc', 'cJ_G2rN4qgXEre76ru8qFOGxuy_nl44Z'),
    );
    Client client = new Client(settings: settings);
    Channel channel = await client.channel();
    publisher = await channel.exchange("answers", ExchangeType.FANOUT);
  }

  @override
  void initState() {
    isAvailableBtn = false; //Change to false when sub is correctly implemented
    _initSubscribe();
    _initPublisher();
    super.initState();
  }

  void _onPressed() {
    // We dont care about the routing key as our exchange type is FANOUT
    publisher.publish((widget.team+ (new DateTime.now().millisecondsSinceEpoch).toString()  + (new DateTime.now()).toString()), null);
    print("message : " + widget.team);
    print(" [x] Sent ${widget.team}");

    _deactivateBtn();
  }

  void _startSleep(){
    Future.delayed(const Duration(seconds: 15), () {
      if(isAvailableBtn){
        print("Button deactivated");
        _deactivateBtn();
      }else {
        print('button was disabled');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: (MediaQuery.of(context).size.height / 2),
      width: double.infinity,
      child: FloatingActionButton(
        onPressed: isAvailableBtn ? _onPressed : null,
        child: Icon(Icons.block),
      ),

    );
  }

}