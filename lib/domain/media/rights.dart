import 'package:xml/xml.dart';

class Rights {
  final String? status;

  Rights({
    this.status,
  });

  static Rights? parse(XmlElement? element) {
    if (element == null) {
      return null;
    }
    return new Rights(
      status: element.getAttribute("status"),
    );
  }
}
