import 'package:palestine_connection/palestine_connection.dart';
import 'package:test/test.dart';

void main() {
  group('PalConnection', () {
    const String testInitValues = 'if variables has start type';
    const String testGetRandomDomain = 'if getRandomDomain return String';
    const String testInit = 'if init working and timer assigned';
    const String testMultiInit = 'if init working and timers assigned';
    const String testCheckConnection = 'if checkConnection is working';
    const String testDispose = 'if dispose is working';

    final PalConnection _connection = PalConnection();
    test(testInitValues, () async {
      expect(_connection.prevConnectionStates[0].runtimeType, bool);
      expect(_connection.prevConnectionStates[0], anyOf([true, false]));
      expect(_connection.timers[0], null);
    });

    test(testGetRandomDomain, () {
      expect(_connection.getRandomDomain().runtimeType, String);
    });

    test(testInit, () async {
      await _connection.initialize(
        periodicInSeconds: 3,
        onConnectionLost: () {},
        onConnectionRestored: () {},
      );

      expect(_connection.timers[0], isNot(null));
      expect(_connection.timers[0]!.isActive, true);

      expect(_connection.prevConnectionStates[0], anyOf([true, false]));

      // waits for timer to complete
      await Future.delayed(const Duration(seconds: 3 * 3), () {});
    });

    test(testCheckConnection, () async {
      expect(
        _connection.getDomainOrRandom(PalDomain.google).runtimeType,
        String,
      );
      expect(
        await _connection.checkConnection(PalDomain.google),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection(''),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection('4'),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection('4.y'),
        anyOf([true, false]),
      );
    });

    test(testDispose, () async {
      // TODO : Change to true
      expect(_connection.dispose(), true);
    });

    tearDown(() {
      _connection.dispose();
    });

    test(testMultiInit, () async {
      await _connection.initializeMulti(
        domains: [PalDomain.random, PalDomain.random, 'bad.do.main'],
        periodicInSeconds: 3,
        onConnectionLost: (domain) {
          expect(domain, 'bad.do.main');
        },
        onConnectionRestored: (domain) {},
      );
      _connection.prevConnectionStates.last = true;
      expect(_connection.timers.first, isNot(null));
      expect(_connection.timers.first!.isActive, true);

      expect(_connection.prevConnectionStates.first, anyOf([true, false]));

      expect(_connection.timers.last, isNot(null));
      expect(_connection.timers.last!.isActive, true);

      expect(_connection.prevConnectionStates.last, anyOf([true, false]));

      // waits for timer to complete
      await Future.delayed(const Duration(seconds: 3 * 3), () {});
    });

    test(testDispose, () async {
      expect(_connection.dispose(), true);
    });
  });
}
