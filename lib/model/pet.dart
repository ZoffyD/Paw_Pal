class pet {
  String? petid;
  String? userId;
  String? petname;
  String? age;
  String? gender;
  String? petType;
  String? petCategory;
  String? health;
  String? description;
  String? lat;
  String? lng;
  String? created_at;

  //Owner info
  String? name;
  String? email;
  String? phone;


  pet({
    this.petid,
    this.userId,
    this.petname,
    this.age,
    this.gender,
    this.petType,
    this.petCategory,
    this.health,
    this.description,
    this.lat,
    this.lng,
    this.created_at,
    this.name,
    this.email,
    this.phone,
  });

   pet.fromJson(Map<String, dynamic> json) {
      petid =  json['pet_id'];
      userId = json['user_id'];
      petname = json['pet_name'];
      age = json['age'];
      gender = json['gender'];
      petType = json['pet_type'];
      petCategory = json[ 'category'];
      health = json['health'];
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
    data['age'] = age;
    data['gender'] = gender;
    data['pet_type'] = petType;
    data['category'] = petCategory;
    data['health'] = health;
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
