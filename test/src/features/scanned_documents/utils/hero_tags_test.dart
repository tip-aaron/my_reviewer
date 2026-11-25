import 'package:flutter_test/flutter_test.dart';
import 'package:my_reviewer/src/features/scanned_documents/utils/hero_tags.dart';

const _groupId = 'group';
const _imagePath = 'page.png';

void main() {
  group('pageHeroTag', () {
    test('combines the group ID and image path', () {
      expect(
        pageHeroTag('group-1', '/images/page.png'),
        'group-1_/images/page.png',
      );
    });

    test('preserves empty and whitespace-only inputs', () {
      expect(pageHeroTag('', ''), '_');
      expect(pageHeroTag('  ', '  '), '  _  ');
    });

    test('preserves Unicode and punctuation', () {
      const groupId = 'café-العربية-👋';
      const imagePath = 'pages/書類_́.png';

      expect(pageHeroTag(groupId, imagePath), '${groupId}_$imagePath');
    });

    test('returns the same tag for the same inputs', () {
      final first = pageHeroTag(_groupId, _imagePath);

      expect(pageHeroTag(_groupId, _imagePath), first);
    });
  });
}
