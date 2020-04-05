class WeatherInfo{
  var cityid="";
  var date="";
  var week="";
  var update_time="";
  var city="";
  var cityEn="";
  var country="";
  var countryEn="";
  var wea="";
  var wea_img="";
  var tem="";
  var tem1="";
  var tem2="";
  var win="";
  var win_speed="";
  var win_meter="";

  void FromJson(Map<String,dynamic> result){
    cityid=result["cityid"];
    date=result["date"];
    week=result["week"];
    update_time=result["update_time"];
    city=result["city"];
    cityEn=result["cityEn"];
    country=result["country"];
    countryEn=result["countryEn"];
    wea=result["wea"];
    wea_img=result["wea_img"];
    tem=result["tem"];
    tem1=result["tem1"];
    tem2=result["tem2"];
    win=result["win"];
    win_speed=result["win_speed"];
    win_meter=result["win_meter"];
  }
}