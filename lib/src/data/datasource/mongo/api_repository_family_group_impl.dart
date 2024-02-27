import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group_request.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/repository/api_repository_family_group.dart';

class ApiRepositoryFamilyGroupImpl extends ApiRepositoryFamilyMembersInterface {
  @override
  Future getFamilyMembersByUser(String userId) async {
    var res = await Api.httpGet("family-group/family-members/$userId");
    return res;
  }

  @override
  Future getFamilyGroupByUserId(String userId) async {
    var res = await Api.httpGet("family-group/family-member/$userId");
    if (res.data == null || res.error as bool) return List<UserAlert>.empty();
    List<UserAlert> usersAlerts = (res.data as List)
        .map(
          (p) => UserAlert.fromJson(p),
        )
        .toList();
    return usersAlerts;
  }

  @override
  Future getFamilyGroupByUserInDanger(String familyMemberId) async {
    var res = await Api.httpGet("family-group/user-in-danger/$familyMemberId");
    return res;
  }

  @override
  Future getAllFamilyGroupByUserId(String userId) async {
    var res = await Api.httpGet("family-group/user/$userId");
    return res;
  }

  @override
  Future getUserByDni(String dni) async {
    var res = await Api.httpGet("user/dni/$dni");
    return res;
  }

  @override
  Future postFamilyGroup(FamilyGroupRequest familyGroupRequest) async {
    var res = await Api.post("family-group", familyGroupRequest.toJson());
    return res;
  }
}
