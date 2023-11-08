import 'package:vivo_vivo_app/src/domain/models/user.dart';

abstract class ApiRepositoryFamilyGroupInterface {
  Future<List<User>> getFamilyGroupByUser(String userId);
}