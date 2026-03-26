import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 01.1 Nyquist Validation:', () {
    group('1. GitHub Actions Workflows (SHA Pinning):', () {
      final workflowFiles = [
        '.github/workflows/ci.yml',
        '.github/workflows/security.yml',
        '.github/workflows/scorecard.yml',
      ];

      for (final filePath in workflowFiles) {
        test('$filePath should use SHA hashes for all actions', () {
          final file = File(filePath);
          expect(
            file.existsSync(),
            isTrue,
            reason: 'Workflow file $filePath missing',
          );

          final content = file.readAsStringSync();
          final lines = content.split('\n');

          for (final line in lines) {
            if (line.trim().startsWith('uses:')) {
              // Ignore local actions (e.g., uses: ./.github/actions/local)
              if (line.contains('./')) continue;

              // Action name should be followed by @ and a 40-character SHA hash
              // Example: uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683
              expect(
                line,
                matches(RegExp(r'uses: [^@]+@[a-f0-9]{40}')),
                reason:
                    'Line "$line" in $filePath does not use a pinned SHA hash',
              );
            }
          }
        });
      }
    });

    group('2. Static Analysis & Formatting:', () {
      test('analysis_options.yaml should contain strict lint rules', () {
        final file = File('analysis_options.yaml');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('avoid_print: true'));
        expect(content, contains('avoid_relative_lib_imports: true'));
        expect(content, contains('prefer_const_constructors: true'));
        expect(content, contains('depend_on_referenced_packages: true'));
        expect(content, contains('exclude:'));
        expect(content, contains('**/*.g.dart'));
      });
    });

    group('3. Secrets & Environment Configuration:', () {
      test(
        'lib/core/config/app_config.dart should use String.fromEnvironment',
        () {
          final file = File('lib/core/config/app_config.dart');
          expect(file.existsSync(), isTrue);

          final content = file.readAsStringSync();
          expect(content, contains('String.fromEnvironment('));
          expect(content, contains('MUSICBRAINZ_USER_AGENT'));
          expect(content, contains('WIKIDATA_SPARQL_ENDPOINT'));
        },
      );

      test('.env.example should contain all required keys', () {
        final file = File('.env.example');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('FIREBASE_API_KEY='));
        expect(content, contains('MUSICBRAINZ_USER_AGENT='));
        expect(content, contains('WIKIDATA_SPARQL_ENDPOINT='));
      });
    });

    group('4. Security Policy:', () {
      test('SECURITY.md should be present and valid', () {
        final file = File('SECURITY.md');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('# Security Policy'));
        expect(content, contains('Reporting a Vulnerability'));
        expect(content, contains('Gitleaks'));
        expect(content, contains('Trivy'));
      });
    });

    group('5. Repository Health:', () {
      test('.github/dependabot.yml should be present and valid', () {
        final file = File('.github/dependabot.yml');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('version: 2'));
        expect(content, contains('package-ecosystem: "pub"'));
        expect(content, contains('package-ecosystem: "github-actions"'));
      });

      test('.gitleaks.toml should contain paths allowlist', () {
        final file = File('.gitleaks.toml');
        expect(file.existsSync(), isTrue);

        final content = file.readAsStringSync();
        expect(content, contains('[allowlist]'));
        expect(content, contains('paths = ['));
        expect(content, contains('build'));
        expect(content, contains('.planning'));
      });
    });
  });
}
