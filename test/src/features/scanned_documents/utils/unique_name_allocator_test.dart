import 'package:flutter_test/flutter_test.dart';
import 'package:my_reviewer/src/features/scanned_documents/utils/unique_name_allocator.dart';

const _pageName = 'page';
const _reportName = 'report';

void main() {
  group('UniqueNameAllocator', () {
    test('returns an available base unchanged', () {
      final allocator = UniqueNameAllocator([]);

      expect(allocator.claim('page'), 'page');
    });

    test(
      'returns empty and whitespace-only bases unchanged when available',
      () {
        final allocator = UniqueNameAllocator([]);

        expect(allocator.claim(''), '');
        expect(allocator.claim('  '), '  ');
      },
    );

    test('preserves whitespace and Unicode in names', () {
      final allocator = UniqueNameAllocator([]);

      expect(allocator.claim(' café-العربية-👋 '), ' café-العربية-👋 ');
    });

    test('reserves claimed names and numbers repeated claims', () {
      final allocator = UniqueNameAllocator([]);

      expect(allocator.claim(_pageName), _pageName);
      expect(allocator.claim(_pageName), '${_pageName}_2');
      expect(allocator.claim(_pageName), '${_pageName}_3');
    });

    test('avoids names already taken without regard to case', () {
      final allocator = UniqueNameAllocator(['PAGE', '${_pageName}_2']);

      expect(allocator.claim(_pageName), '${_pageName}_3');
    });

    test('considers the extension when checking for collisions', () {
      final allocator = UniqueNameAllocator(['$_reportName.PDF']);

      expect(
        allocator.claim(_reportName, extension: 'pdf'),
        '${_reportName}_2',
      );
      expect(allocator.claim(_reportName, extension: 'txt'), _reportName);
    });

    test('reserves names independently for different extensions', () {
      final allocator = UniqueNameAllocator([]);

      expect(allocator.claim(_reportName, extension: 'pdf'), _reportName);
      expect(allocator.claim(_reportName, extension: 'txt'), _reportName);
      expect(
        allocator.claim(_reportName, extension: 'PDF'),
        '${_reportName}_2',
      );
    });
  });
}
