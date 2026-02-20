class DealraiseModel {
  int? id;
  String? supId;
  String? med;
  String? percentstock;
  String? newprice;
  String? oldprice;
  String? deal;
  String? free;
  String? total;
  String? unit;
  String? actiondate;
  String? lastpricemaxorder;
  String? labelchange;
  String? remark;
  String? datepost;
  String? dealstatus;
  String? dealstatustxt;
  String? dbName;
  String? dbHilight;
  String? dbDeal;
  String? dbFree;
  String? dbPrice;
  String? dbCMin;

  DealraiseModel(
      {this.id,
      this.supId,
      this.med,
      this.percentstock,
      this.newprice,
      this.oldprice,
      this.deal,
      this.free,
      this.total,
      this.unit,
      this.actiondate,
      this.lastpricemaxorder,
      this.labelchange,
      this.remark,
      this.datepost,
      this.dealstatus,
      this.dealstatustxt,
      this.dbName,
      this.dbHilight,
      this.dbDeal,
      this.dbFree,
      this.dbPrice,
      this.dbCMin});

  DealraiseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supId = json['sup_id'];
    med = json['med'];
    percentstock = json['percentstock'];
    newprice = json['newprice'];
    oldprice = json['oldprice'];
    deal = json['deal'];
    free = json['free'];
    total = json['total'];
    unit = json['unit'];
    actiondate = json['actiondate'];
    lastpricemaxorder = json['lastpricemaxorder'];
    labelchange = json['labelchange'];
    remark = json['remark'];
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
    data['newprice'] = this.newprice;
    data['oldprice'] = this.oldprice;
    data['deal'] = this.deal;
    data['free'] = this.free;
    data['total'] = this.total;
    data['unit'] = this.unit;
    data['actiondate'] = this.actiondate;
    data['lastpricemaxorder'] = this.lastpricemaxorder;
    data['labelchange'] = this.labelchange;
    data['remark'] = this.remark;
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
