import 'package:vivo_vivo_app/src/domain/models/Request/family_group_request.dart';

abstract class ApiRepositoryFamilyMembersInterface {
  Future getFamilyMembersByUser(String userId);
  Future getFamilyGroupByUserId(int userId);
  Future getFamilyGroupByUserInDanger(String familyMemberId);
  Future getAllFamilyGroupByUserId(String userId);
  Future getUserByDni(String dni);
  Future getPolicesByUserMember(String userID);
  Future postFamilyGroup(FamilyGroupRequest familyGroupRequest);
  Future deleteFamilyGroupMember(String userID, String userFamilyMemberID);
}
