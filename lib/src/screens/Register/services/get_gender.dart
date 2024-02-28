import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/drop_down_item.dart';

Future<List<DropDownItem>> getGender() async {
  var res = await Api.httpGet("gender");
  if (res.data == null || res.error as bool) return List<DropDownItem>.empty();
  List<DropDownItem> genders = (res.data as List)
      .map(
        (p) => DropDownItem.fromJson(p),
      )
      .toList();
  return genders;
}
