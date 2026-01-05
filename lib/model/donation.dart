class Donation {
  String? donation_id;
  String? donation_type;
  String? amount;
  String? description;
  String? donation_date;
  String? pet_name;

  Donation({
    this.donation_id,
    this.donation_type,
    this.amount,
    this.description,
    this.donation_date,
    this.pet_name,
  });

 Donation.fromJson(Map<String, dynamic>json){
  donation_id = json['donation_id'];
  donation_type = json['donation_type'];
  amount = json['amount'];
  description = json['description'];
  donation_date = json['donation_date'];
  pet_name = json['pet_name'];
 }
  
}