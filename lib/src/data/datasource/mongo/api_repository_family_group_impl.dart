import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_family_group.dart';

class ApiRepositoryFamilyGroupImpl extends ApiRepositoryFamilyGroupInterface {
  @override
  Future<List<User>> getFamilyGroupByUser(String userId) {
    throw UnimplementedError();
  }
}
