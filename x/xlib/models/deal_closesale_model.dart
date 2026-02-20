class DealclosesaleModel {
  int? id;
  String? supId;
  String? med;
  String? percentstock;
  String? target;
  String? currentorder;
  String? balance;
  String? note;
  String? extra;
  String? extraDate;
  String? period;
  String? deadline;
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

  DealclosesaleModel(
      {this.id,
      this.supId,
      this.med,
      this.percentstock,
      this.target,
      this.currentorder,
      this.balance,
      this.note,
      this.extra,
      this.extraDate,
      this.period,
      this.deadline,
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

  DealclosesaleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supId = json['sup_id'];
    med = json['med'];
    percentstock = json['percentstock'];
    target = json['target'];
    currentorder = json['currentorder'];
    balance = json['balance'];
    note = json['note'];
    extra = json['extra'];
    extraDate = json['extra_date'];
    period = json['period'];
    deadline = json['deadline'];
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
    data['target'] = this.target;
    data['currentorder'] = this.currentorder;
    data['balance'] = this.balance;
    data['note'] = this.note;
    data['extra'] = this.extra;
    data['extra_date'] = this.extraDate;
    data['period'] = this.period;
    data['deadline'] = this.deadline;
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
