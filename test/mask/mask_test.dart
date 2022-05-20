import 'package:mocktail/mocktail.dart';
import 'package:oxygen/oxygen.dart';
import 'package:oxygen/src/mask/mask_delegate.dart';

import 'package:test/test.dart';

class MockWorld extends Mock implements World {}

class MockFilter extends Mock implements Filter {}

void main() {
  group('Mask', () {
    late World world;
    late Filter filter;

    setUp(() {
      world = MockWorld();
      filter = MockFilter();

      when(() => world.getPool<_Component1>()).thenReturn(
        ComponentPool(world, _Component1.new, 0, 10),
      );
      when(() => world.getPool<_Component2>()).thenReturn(
        ComponentPool(world, _Component2.new, 1, 10),
      );
      when(() => world.getPool<_Component3>()).thenReturn(
        ComponentPool(world, _Component3.new, 2, 10),
      );
      when(() => world.getPool<_Component4>()).thenReturn(
        ComponentPool(world, _Component4.new, 3, 10),
      );
      when(() => world.getPool<_Component5>()).thenReturn(
        ComponentPool(world, _Component5.new, 4, 10),
      );
      when(() => world.getPool<_Component6>()).thenReturn(
        ComponentPool(world, _Component6.new, 5, 10),
      );
      when(() => world.getPool<_Component7>()).thenReturn(
        ComponentPool(world, _Component7.new, 6, 10),
      );
      when(() => world.getPool<_Component8>()).thenReturn(
        ComponentPool(world, _Component8.new, 7, 10),
      );
      when(() => world.getPool<_Component9>()).thenReturn(
        ComponentPool(world, _Component9.new, 8, 10),
      );
      when(() => world.getPool<_Component10>()).thenReturn(
        ComponentPool(world, _Component10.new, 9, 10),
      );
    });

    group('include', () {
      test(
        'should be thrown assertation error when include list already has '
        'component',
        () {
          final mask = Mask(world)..include<_Component1>();

          expect(
            () => mask.include<_Component1>(),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'should be thrown assertation error when exclude list already has '
        'component',
        () {
          final mask = Mask(world)..exclude<_Component1>();

          expect(
            () => mask.include<_Component1>(),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test('should be added component id to include list', () {
        final mask = Mask(world)
          ..include<_Component1>()
          ..include<_Component5>();

        expect(mask.includeList[0], equals(0));
        expect(mask.includeList[1], equals(4));
        expect(mask.includeCount, equals(2));
      });

      test('should be resize when include list is fool', () {
        final mask = Mask(world)
          ..include<_Component1>()
          ..include<_Component2>()
          ..include<_Component3>()
          ..include<_Component4>()
          ..include<_Component5>()
          ..include<_Component6>()
          ..include<_Component7>()
          ..include<_Component8>()
          ..include<_Component9>();

        expect(mask.includeCount, equals(9));
        expect(mask.includeList.length, equals(16));
      });
    });

    group('exclude', () {
      test(
        'should be thrown assertation error when include list already has '
        'component',
        () {
          final mask = Mask(world)..include<_Component1>();

          expect(
            () => mask.exclude<_Component1>(),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'should be thrown assertation error when exclude list already has '
        'component',
        () {
          final mask = Mask(world)..exclude<_Component1>();

          expect(
            () => mask.exclude<_Component1>(),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test('should be added component id to include list', () {
        final mask = Mask(world)
          ..exclude<_Component1>()
          ..exclude<_Component5>();

        expect(mask.excludeList[0], equals(0));
        expect(mask.excludeList[1], equals(4));
        expect(mask.excludeCount, equals(2));
      });

      test('should be resize when exclude list is fool', () {
        final mask = Mask(world)
          ..exclude<_Component1>()
          ..exclude<_Component2>()
          ..exclude<_Component3>()
          ..exclude<_Component4>()
          ..exclude<_Component5>();

        expect(mask.excludeCount, equals(5));
        expect(mask.excludeList.length, equals(8));
      });
    });

    group('end', () {
      test('should be called world.getFilterInternal method', () {
        final mask = Mask(world);
        when(() => world.checkFilter(mask)).thenReturn(
          FilterCheckResult(filter, true),
        );

        mask
          ..include<_Component1>()
          ..end();

        verify(() => world.checkFilter(mask)).called(1);
      });

      test('should calculate hash', () {
        final mask = Mask(world);
        when(() => world.checkFilter(mask)).thenReturn(
          FilterCheckResult(filter, true),
        );

        mask
          ..include<_Component1>()
          ..exclude<_Component2>()
          ..end();

        expect(mask.hash, equals(197191));
      });

      test(
        'should reset the data and release to the pool when the filter already '
        'exists',
        () {
          final mask = Mask(world);
          when(() => world.checkFilter(mask)).thenReturn(
            FilterCheckResult(filter, false),
          );

          mask
            ..include<_Component1>()
            ..exclude<_Component2>()
            ..end();

          expect(mask.includeCount, equals(0));
          expect(mask.excludeCount, equals(0));
          expect(mask.hash, equals(0));
          verify(() => world.onMaskRecycle(mask)).called(1);
        },
      );
    });
  });
}

class _Component1 extends Component {}

class _Component2 extends Component {}

class _Component3 extends Component {}

class _Component4 extends Component {}

class _Component5 extends Component {}

class _Component6 extends Component {}

class _Component7 extends Component {}

class _Component8 extends Component {}

class _Component9 extends Component {}

class _Component10 extends Component {}
