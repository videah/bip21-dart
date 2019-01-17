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
