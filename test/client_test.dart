library kafka.test.client;

import 'package:test/test.dart';
import 'package:kafka/kafka.dart';
import 'setup.dart';

void main() {
  group('Client', () {
    KafkaClient _client;

    tearDown(() async {
      await _client.close();
    });

    test('it can fetch topic metadata', () async {
      var host = await getDefaultHost();
      _client = new KafkaClient([new KafkaHost(host, 9092)]);
      var response = await _client.getMetadata();
      expect(response, new isInstanceOf<MetadataResponse>());
      expect(response.brokers, isNotEmpty);
    });
  });
}
