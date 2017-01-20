@TestOn('dartium')
import 'package:test/test.dart';

import 'package:angular2/angular2.dart';
import 'package:angular2/reflection.dart';

class InjectableService {
  bool someMethod() {
    return false;
  }
}

@Injectable()
class SomeComponent {
  final InjectableService _injectableService;

  SomeComponent(this._injectableService);
}

class MockInjectableService implements InjectableService {
  bool someMethod() {
    return true;
  }
}

main() {
  allowRuntimeReflection();

  group('test group', () {
    Injector inj;

    setUp(() {
      inj = ReflectiveInjector.resolveAndCreate([
        SomeComponent,
        provide(InjectableService, useClass: MockInjectableService)
      ]);
    });

    test('some test', () {
      SomeComponent testSubject = inj.get(SomeComponent);
      expect(testSubject._injectableService.someMethod(), true);
    });
  });
}
