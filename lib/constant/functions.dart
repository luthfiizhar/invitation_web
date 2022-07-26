import 'package:hive/hive.dart';

Future logout() async {
  var box = await Hive.openBox('userLogin');
  box.delete('name');
  box.delete('nip');
  box.delete('jwtToken');
}
