import 'package:vivo_vivo_app/src/domain/api/vivo_vivo_api.dart';
import 'package:vivo_vivo_app/src/domain/models/marital_status.dart';

Future<List<MaritalStatus>> getUser() async {
    var res = await Api.httpGet("marital-status");
    return res;
  }