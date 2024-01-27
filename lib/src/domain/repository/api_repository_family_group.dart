abstract class ApiRepositoryFamilyMembersInterface {
  Future getFamilyMembersByUser(String userId);
  Future getFamilyGroupByUserId(String userId);
  Future getFamilyGroupByUserInDanger(String familyMemberId);
  Future getAllFamilyGroupByUserId(String userId);
  Future getUserByDni(String dni);
}
