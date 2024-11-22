import 'package:espla/services/db/db.dart';
import 'package:espla/services/db/org.dart';
import 'package:flutter/cupertino.dart';

class OrgState with ChangeNotifier {
  final MainDB _db = MainDB();

  List<Org> orgs = [];

  Future<List<Org>> fetchOrgs() async {
    try {
      orgs = await _db.org.getAll();
      notifyListeners();

      return orgs;
    } catch (e) {
      //
    }

    return [];
  }
}
