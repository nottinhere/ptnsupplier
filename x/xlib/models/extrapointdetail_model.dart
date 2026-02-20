class PointReportDetailModel {
  String? medId;
  String? customerCode;
  String? datepost;
  String? qty;
  String? point;
  String? campId;

  PointReportDetailModel(
      {this.medId, this.customerCode, this.datepost, this.qty, this.point, this.campId});

  PointReportDetailModel.fromJson(Map<String, dynamic> json) {
    medId = json['med_id'];
    customerCode = json['customer_code'];
    datepost = json['datepost'];
    qty = json['qty'];
    point = json['point'];
    campId = json['camp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['med_id'] = this.medId;
    data['customer_code'] = this.customerCode;
    data['datepost'] = this.datepost;
    data['qty'] = this.qty;
    data['point'] = this.point;
    data['camp_id'] = this.campId;
    return data;
  }
}
