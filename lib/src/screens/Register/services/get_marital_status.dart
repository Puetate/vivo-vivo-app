import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/drop_down_item.dart';

Future<List<DropDownItem>> getMaritalStatus() async {
  var res = await Api.httpGet("marital-status");
  if (res.data == null || res.error as bool) return List<DropDownItem>.empty();
  List<DropDownItem> maritalStatus = (res.data as List)
      .map(
        (p) => DropDownItem.fromJson(p),
      )
      .toList();
  return maritalStatus;
}
