import 'dart:convert';
import 'dart:io';

import 'package:bip21/bip21.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> fixtures = json
      .decode(File("./test/fixtures.json").readAsStringSync(encoding: utf8));

  List<dynamic> valid = fixtures["valid"] as List<dynamic>;
  List<dynamic> invalid = fixtures["invalid"] as List<dynamic>;

  valid.removeWhere((f) => f["compliant"] != null);

  group("valid encoding", () {
    valid.forEach((f) {
      String address = f["address"];
      Map<String, dynamic> options = f["options"];
      String urnScheme = f["urnScheme"];

      test("encodes ${f["uri"]}", () {
        String result = Bip21.encode(
          BitcoinRequest(address: address, options: options),
          urnScheme,
        );
        expect(result, f["uri"]);
      });
    });
  });

  group("valid decoding", () {
    valid.forEach((f) {
      String address = f["address"];
      Map<String, dynamic> options = f["options"];

      test(
          "decodes ${f["uri"]} ${f["compliant"] != null ? "(non-compliant)" : ""}",
          () {
        BitcoinRequest decode = Bip21.decode(f["uri"], f["urnScheme"]);
        expect(decode.address, address);
        if (options != null) {
          String label = options["label"];
          String message = options["message"];
          dynamic amount = options["amount"];

          expect(decode.label, label);
          expect(decode.message, message);
          expect(
            decode.amount,
            amount is int
                ? amount.toDouble()
                : amount is String ? double.parse(amount) : amount,
          );
        }
      });
    });
  });

  group("invalid encoding", () {
    invalid.forEach((f) {
      if (f["address"] != null) {
        test("throws ${f["exception"]} for ${f["uri"]}", () {
          expect(
            () {
              Bip21.encode(f["address"], f["options"]);
            },
            throws,
          );
        });
      }
    });
  });

  group("invalid decoding", () {
    invalid.forEach((f) {
      if (f["uri"] != null) {
        test("throws ${f["exception"]} for ${f["uri"]}", () {
          expect(
            () {
              Bip21.decode(f["uri"]);
            },
            throwsA(f["exception"]),
          );
        });
      }
    });
  });
}
