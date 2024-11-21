import 'package:espla/services/db/org.dart';
import 'package:flutter/cupertino.dart';

class OrgState with ChangeNotifier {
  List<Org> orgs = [
    Org(
      id: '0x0a26e479BaCe7D97c679b9b1de0fF606739Dafa2',
      name: 'DAO Brussels',
      description: 'Leading technology solutions provider',
      image: 'https://picsum.photos/seed/picsum/200',
      createdAt: DateTime(2023, 1, 15),
      updatedAt: DateTime(2024, 3, 1),
    ),
    Org(
      id: '0x456',
      name: 'Citizen Wallet',
      description: 'Environmental conservation organization',
      image: 'https://picsum.photos/seed/picsum2/200',
      createdAt: DateTime(2023, 3, 20),
      updatedAt: DateTime(2024, 2, 28),
    ),
    Org(
      id: '0x789',
      name: 'Brussels Pay',
      description: 'Promoting education worldwide',
      image: 'https://picsum.photos/seed/picsum3/200',
      createdAt: DateTime(2023, 6, 5),
      updatedAt: DateTime(2024, 1, 15),
    ),
    Org(
      id: '0xabc',
      name: 'Commons Hub',
      description: 'Advancing healthcare accessibility',
      image: 'https://picsum.photos/seed/picsum4/200',
      createdAt: DateTime(2023, 8, 10),
      updatedAt: DateTime(2024, 2, 20),
    ),
  ];
}
