import "package:dart_amqp/dart_amqp.dart";

void PublishAnswer(String team) async{
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
  Exchange exchange = await channel.exchange("answers", ExchangeType.FANOUT);

  String message = team;

  // We dont care about the routing key as our exchange type is FANOUT
  exchange.publish((message + (new DateTime.now().millisecondsSinceEpoch).toString()  + (new DateTime.now()).toString()), null);
  print("message : " + message);
  print(" [x] Sent ${message}");
  await client.close();
}