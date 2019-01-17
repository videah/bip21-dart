import 'dart:convert';
import 'package:meta/meta.dart';

class BitcoinRequest {
  String address;
  Map<String, dynamic> options;

  BitcoinRequest({@required this.address, this.options}) {
    if (this.options == null) this.options = Map();
  }

  String get label => options["label"];
  String get message => options["message"];
  double get amount => options["amount"] is int
      ? options["amount"].toDouble()
      : options["amount"] is String
          ? double.parse(options["amount"])
          : options["amount"];

  set label(String newLabel) => options["label"] = newLabel;
  set message(String newMessage) => options["message"] = newMessage;
  set amount(dynamic newAmount) => options["amount"] = newAmount;

  BitcoinRequest.fromJson(Map<String, dynamic> json)
      : address = json["address"],
        options = json["options"];

  String toJson() {
    Map<String, dynamic> decodeOptions = options;
    decodeOptions.removeWhere((key, value) => value == null);
    return json.encode({
      "address": address,
      "options": decodeOptions,
    }).toString();
  }

  @override
  String toString() => Bip21.encode(this);
}

class Bip21 {
  static BitcoinRequest decode(String uri, [String urnScheme]) {
    urnScheme = urnScheme ?? "bitcoin";
    if (uri.indexOf(urnScheme) != 0 || uri[urnScheme.length] != ":")
      throw ("Invalid BIP21 URI");

    int split = uri.indexOf("?");
    Map<String, String> uriOptions = Uri.parse(uri).queryParameters;

    Map<String, dynamic> options = Map.from({
      "message": uriOptions["message"],
      "label": uriOptions["label"],
    });

    String address =
        uri.substring(urnScheme.length + 1, split == -1 ? null : split);

    if (uriOptions["amount"] != null) {
      if (uriOptions["amount"].indexOf(",") != -1)
        throw ("Invalid amount: commas are invalid");
      double amount = double.tryParse(uriOptions["amount"]);
      if (amount == null || amount.isNaN)
        throw ("Invalid amount: not a number");
      if (!amount.isFinite) throw ("Invalid amount: not finite");
      if (amount < 0) throw ("Invalid amount: not positive");
      options["amount"] = amount;
    }

    return BitcoinRequest(
      address: address,
      options: options,
    );
  }

  static String encode(BitcoinRequest req, [String urnScheme]) {
    urnScheme = urnScheme ?? "bitcoin";
    String query = "";
    if (req.options != null && req.options.isNotEmpty) {
      if (req.amount != null) {
        if (!req.amount.isFinite) throw ("Invalid amount: not finite");
        if (req.amount < 0) throw ("Invalid amount: not positive");
      }

      Map<String, dynamic> uriOptions = req.options;
      uriOptions.removeWhere((key, value) => value == null);
      uriOptions.forEach((key, value) {
        uriOptions[key] = value.toString();
      });

      if (uriOptions.isEmpty) uriOptions = null;
      query = Uri(queryParameters: uriOptions).toString();
      // Dart isn't following RFC-3986...
      query = query.replaceAll(RegExp(r"\+"), "%20");
    }

    return "$urnScheme:${req.address}$query";
  }
}
