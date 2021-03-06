class PopupModel {
  int id;
  String subject;
  String detail;
  String postdate;
  String photo;
  String document;
  String popstatus;

  PopupModel(
      {this.id,
      this.subject,
      this.detail,
      this.postdate,
      this.photo,
      this.document,
      this.popstatus});

  PopupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    detail = json['detail'];
    postdate = json['postdate'];
    photo = json['photo'];
    document = json['document'];
    popstatus = json['popstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['detail'] = this.detail;
    data['postdate'] = this.postdate;
    data['photo'] = this.photo;
    data['document'] = this.document;
    data['popstatus'] = this.popstatus;
    return data;
  }
}
