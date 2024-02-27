import 'package:vivo_vivo_app/src/domain/models/family_group_request.dart';

abstract class ApiRepositoryFamilyMembersInterface {
  Future getFamilyMembersByUser(String userId);
  Future getFamilyGroupByUserId(String userId);
  Future getFamilyGroupByUserInDanger(String familyMemberId);
  Future getAllFamilyGroupByUserId(String userId);
  Future getUserByDni(String dni);
  Future postFamilyGroup(FamilyGroupRequest familyGroupRequest);
}
