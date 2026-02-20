class DealspacialpriceModel {
  int? id;
  String? supId;
  String? med;
  String? percentstock;
  String? deal;
  String? free;
  String? total;
  String? unit;
  String? cost;
  String? extra;
  String? nexttime;
  String? remark;
  String? period_start;
  String? period_end;
  String? period;
  String? datepost;
  String? dealstatus;
  String? dealstatustxt;
  String? dbName;
  String? dbHilight;
  String? dbDeal;
  String? dbFree;
  String? dbPrice;
  String? dbCMin;

  DealspacialpriceModel(
      {this.id,
      this.supId,
      this.med,
      this.percentstock,
      this.deal,
      this.free,
      this.total,
      this.unit,
      this.cost,
      this.extra,
      this.nexttime,
      this.remark,
      this.period_start,
      this.period_end,
      this.period,
      this.datepost,
      this.dealstatus,
      this.dealstatustxt,
      this.dbName,
      this.dbHilight,
      this.dbDeal,
      this.dbFree,
      this.dbPrice,
      this.dbCMin});

  DealspacialpriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supId = json['sup_id'];
    med = json['med'];
    percentstock = json['percentstock'];
    deal = json['deal'];
    free = json['free'];
    total = json['total'];
    unit = json['unit'];
    cost = json['cost'];
    extra = json['extra'];
    nexttime = json['nexttime'];
    remark = json['remark'];
    period_start = json['period_start'];
    period_end = json['period_end'];
    period = json['period'];
    datepost = json['datepost'];
    dealstatus = json['dealstatus'];
    dealstatustxt = json['dealstatustxt'];
    dbName = json['db_name'];
    dbHilight = json['db_hilight'];
    dbDeal = json['db_deal'];
    dbFree = json['db_free'];
    dbPrice = json['db_price'];
    dbCMin = json['db_cMin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sup_id'] = this.supId;
    data['med'] = this.med;
    data['percentstock'] = this.percentstock;
    data['deal'] = this.deal;
    data['free'] = this.free;
    data['total'] = this.total;
    data['unit'] = this.unit;
    data['cost'] = this.cost;
    data['extra'] = this.extra;
    data['nexttime'] = this.nexttime;
    data['remark'] = this.remark;
    data['period_start'] = this.period_start;
    data['period_end'] = this.period_end;
    data['period'] = this.period;
    data['datepost'] = this.datepost;
    data['dealstatus'] = this.dealstatus;
    data['dealstatustxt'] = this.dealstatustxt;
    data['db_name'] = this.dbName;
    data['db_hilight'] = this.dbHilight;
    data['db_deal'] = this.dbDeal;
    data['db_free'] = this.dbFree;
    data['db_price'] = this.dbPrice;
    data['db_cMin'] = this.dbCMin;
    return data;
  }
}
