import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/marital_status.dart';

Future<List<DropDownItem>> getMaritalStatus() async {
  var res = await Api.httpGet("marital-status");
  List<DropDownItem> maritalStatus = (res.data as List)
      .map(
        (p) => DropDownItem.fromJson(p),
      )
      .toList();
  return maritalStatus;
}
