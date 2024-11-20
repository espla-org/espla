import 'package:espla/services/db/org.dart';
import 'package:flutter/cupertino.dart';

class OrgState with ChangeNotifier {
  List<Org> orgs = [
    Org(
      id: '0x123',
      name: 'Tech Innovators',
      description: 'Leading technology solutions provider',
      image: 'https://picsum.photos/seed/picsum/200',
      createdAt: DateTime(2023, 1, 15),
      updatedAt: DateTime(2024, 3, 1),
    ),
    Org(
      id: '0x456',
      name: 'Green Earth Initiative',
      description: 'Environmental conservation organization',
      image: 'https://picsum.photos/seed/picsum2/200',
      createdAt: DateTime(2023, 3, 20),
      updatedAt: DateTime(2024, 2, 28),
    ),
    Org(
      id: '0x789',
      name: 'Global Education Fund',
      description: 'Promoting education worldwide',
      image: 'https://picsum.photos/seed/picsum3/200',
      createdAt: DateTime(2023, 6, 5),
      updatedAt: DateTime(2024, 1, 15),
    ),
    Org(
      id: '0xabc',
      name: 'Healthcare Alliance',
      description: 'Advancing healthcare accessibility',
      image: 'https://picsum.photos/seed/picsum4/200',
      createdAt: DateTime(2023, 8, 10),
      updatedAt: DateTime(2024, 2, 20),
    ),
    Org(
      id: '0xdef',
      name: 'Arts & Culture Society',
      description: 'Promoting local arts and culture',
      image: 'https://picsum.photos/seed/picsum5/200',
      createdAt: DateTime(2023, 11, 30),
      updatedAt: DateTime(2024, 3, 5),
    ),
  ];
}
