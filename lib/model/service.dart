class service {
  String? petid;
  String? userId;
  String? petname;
  String? petType;
  String? petCategory;
  String? description;
  String? lat;
  String? lng;
  String? created_at;

  //Owner info
  String? name;
  String? email;
  String? phone;


  service({
    this.petid,
    this.userId,
    this.petname,
    this.petType,
    this.petCategory,
    this.description,
    this.lat,
    this.lng,
    this.created_at,
    this.name,
    this.email,
    this.phone,
  });

   service.fromJson(Map<String, dynamic> json) {
      petid =  json['pet_id'];
      userId = json['user_id'];
      petname = json['pet_name'];
      petType = json['pet_type'];
      petCategory = json[ 'category'];
      description = json['description'];
      lat = json['lat'];
      lng = json['lng'];
      created_at = json['created_at'];

      name = json['name'];
      email = json['email'];
      phone = json['phone'];
  }  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petid;
    data['user_id'] = userId;
    data['pet_name'] = petname;
    data['pet_type'] = petType;
    data[ 'category'] = petCategory;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = created_at;

    data['name'] = name;
    data['email'] = email;
    data['phone']= phone;
    return data;
  }
}
