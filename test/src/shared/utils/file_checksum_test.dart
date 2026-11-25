import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_reviewer/src/shared/utils/file_checksum.dart';

const _emptyFileSha256 =
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
const _abcSha256 =
    'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad';

void main() {
  late Directory tempDirectory;
  late File tempFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('checksum_test_');
    tempFile = File('${tempDirectory.path}${Platform.pathSeparator}data.bin');
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  group('verifyFileSha256', () {
    test('returns true when the file matches the expected digest', () async {
      await tempFile.writeAsString('abc');

      expect(await verifyFileSha256(tempFile, _abcSha256), isTrue);
    });

    test(
      'matches digest case-insensitively and ignores surrounding whitespace',
      () async {
        await tempFile.writeAsString('abc');

        expect(
          await verifyFileSha256(tempFile, '  ${_abcSha256.toUpperCase()} \n'),
          isTrue,
        );
      },
    );

    test('returns false when the digest does not match', () async {
      await tempFile.writeAsString('abc');

      expect(await verifyFileSha256(tempFile, _emptyFileSha256), isFalse);
    });

    test('returns true for an empty file with its SHA-256 digest', () async {
      await tempFile.writeAsBytes([]);

      expect(await verifyFileSha256(tempFile, _emptyFileSha256), isTrue);
    });

    test(
      'returns true without reading the file when the digest is blank',
      () async {
        expect(await verifyFileSha256(tempFile, ' \t\n '), isTrue);
      },
    );

    test(
      'propagates a file system error when the file cannot be read',
      () async {
        await expectLater(
          verifyFileSha256(tempFile, _abcSha256),
          throwsA(isA<FileSystemException>()),
        );
      },
    );
  });
}
