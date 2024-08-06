import 'package:limcad/resources/api/from_json.dart';

class StateResponse implements FromJson<StateResponse> {
  String? stateId;
  String? stateName;

  StateResponse({this.stateId, this.stateName});

  @override
  StateResponse fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    stateName = json['stateName'];
    return this;
  }
}

class IdResponse implements FromJson<IdResponse> {
  int? lgaId;
  String? stateId;

  IdResponse({this.lgaId, this.stateId});

  @override
  IdResponse fromJson(Map<String, dynamic> json) {
    lgaId = json['lgaId'];
    stateId = json['stateId'];
    return this;
  }
}

class LGAResponse implements FromJson<LGAResponse> {
  IdResponse? id;
  String? lgaName;
  StateResponse? state;

  LGAResponse({this.id, this.lgaName, this.state});

  @override
  LGAResponse fromJson(Map<String, dynamic> json) {
    id = IdResponse().fromJson(json['id']);
    lgaName = json['lgaName'];
    state = StateResponse().fromJson(json['state']);
    return this;
  }

  static List<LGAResponse> listFromJson(List<dynamic> jsonList) {
    List<LGAResponse> lgaList = [];
    for (var item in jsonList) {
      lgaList.add(LGAResponse().fromJson(item));
    }
    return lgaList;
  }
}