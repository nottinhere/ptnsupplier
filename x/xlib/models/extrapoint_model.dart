class PointReportModel {
  String? id;
  String? code;
  String? detail;
  String? subject;
  String? size;
  String? unit;
  String? sumpoint;
  String? campId;

  PointReportModel(
      {this.id, this.code, this.detail,this.subject, this.size, this.unit, this.sumpoint, this.campId});

  PointReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    detail = json['detail'];
    subject = json['subject'];
    size = json['size'];
    unit = json['unit'];
    sumpoint = json['sumpoint'];
    campId  = json['camp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['detail'] = this.detail;
    data['subject'] = this.subject;
    data['size'] = this.size;
    data['unit'] = this.unit;
    data['sumpoint'] = this.sumpoint;
    data['camp_id'] = this.campId;
    return data;
  }
}
