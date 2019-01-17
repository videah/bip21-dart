# bip-21

[![build status](https://secure.travis-ci.org/videah/bip21-dart.png)](http://travis-ci.org/videah/bip21-dart)
[![pub package](https://img.shields.io/pub/v/bip21.svg)](https://pub.dartlang.org/packages/bip21)

Dart implementation of the [BIP-21](https://github.com/bitcoin/bips/blob/master/bip-0021.mediawiki) Bitcoin URI scheme.

Based on the [bitcoinjs](https://github.com/bitcoinjs/bip21) implementation.

## Example

```dart
import 'dart:convert';
import 'package:bip21/bip21.dart';

main() {
  var decoded = Bip21.decode(
      "bitcoin:1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH?amount=20.3&label=Foobar");
  print(decoded.toJson());
  // => {"address":"1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH","options":{"label":"Foobar","amount":20.3}}

  var request = BitcoinRequest(address: "1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH");
  print(Bip21.encode(request));
  // => bitcoin:1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH

  var optionRequest = BitcoinRequest(
    address: "1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH",
    options: {"amount": 20.3, "label": "Foo"},
  );
  print(Bip21.encode(optionRequest));
  // => bitcoin:1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH?amount=20.3&label=Foo

  optionRequest.amount = 50.0;
  optionRequest.label = "Bar";
  optionRequest.message = "Hello World";
  print(Bip21.encode(optionRequest));
  // => bitcoin:1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH?amount=50.0&label=Bar&message=Hello%20World

  var jsonDecoded = BitcoinRequest.fromJson(
    json.decode(
      '{"address":"1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH","options":{"label":"Foobar","amount":20.3}}',
    ),
  );
  print(jsonDecoded.toString());
  // => bitcoin:1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH?label=Foobar&amount=20.3
}
```
# License

This library is licensed under the MIT license. Please read the [LICENSE](LICENSE) file for more information.
