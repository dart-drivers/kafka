import 'dart:async';
import 'package:test/test.dart';
import 'package:kafka/ng.dart';

void main() {
  group('Kafka.NG Consumer Metadata API: ', () {
    KSession session;

    setUpAll(() async {
      try {
        session =
            new KSession(contactPoints: [new ContactPoint('127.0.0.1:9092')]);
        var request = new GroupCoordinatorRequestV0('testGroup');
        await session.send(request, '127.0.0.1', 9092);
      } catch (error) {
        await new Future.delayed(new Duration(milliseconds: 1000));
      }
    });

    tearDownAll(() async {
      await session.close();
    });

    test('we can send group coordinator requests to Kafka broker', () async {
      var request = new GroupCoordinatorRequestV0('testGroup');
      var response = await session.send(request, '127.0.0.1', 9092);
      expect(response, new isInstanceOf<GroupCoordinatorResponseV0>());
      expect(response.coordinatorId, greaterThanOrEqualTo(0));
      expect(response.coordinatorHost, '127.0.0.1');
      expect(response.coordinatorPort, isIn([9092, 9093]));
    });

    test('group coordinator response throws server error if present', () {
      expect(() {
        new GroupCoordinatorResponseV0(
            KafkaServerError.ConsumerCoordinatorNotAvailable, null, null, null);
      }, throwsA(new isInstanceOf<KafkaServerError>()));
    });
  });
}
