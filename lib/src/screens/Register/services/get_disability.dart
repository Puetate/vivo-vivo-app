import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/marital_status.dart';

Future<List<DropDownItem>> getDisability() async {
  var res = await Api.httpGet("disability");
  List<DropDownItem> maritalStatus = (res.data as List)
      .map(
        (p) => DropDownItem.fromJson(p),
      )
      .toList();
  return maritalStatus;
}
