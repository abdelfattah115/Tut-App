
// onBoarding models
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlider;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlider, this.currentIndex);
}

// login models
class Customer{
  String id;
  String name;
  int numOfNotification;

  Customer(this.id, this.name, this.numOfNotification);
}

class Contacts{
  String phone;
  String email;
  String link;

  Contacts(this.phone, this.email, this.link);
}

class Authentication{
  Customer? customer;
  Contacts? contacts;

  Authentication(this.customer, this.contacts);
}

class Service{
  int id;
  String title;
  String image;

  Service(this.id, this.image, this.title);
}

class Store{
  int id;
  String title;
  String image;

  Store(this.id, this.image, this.title);
}

class BannerAd{
  int id;
  //String link;
  String title;
  String image;

  BannerAd(this.id, this.title, this.image);
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData data;

  HomeObject(this.data);
}

class StoreDetails{
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;

  StoreDetails(this.image, this.id, this.title,this.details, this.services, this.about);
}