class PeanutObject {
  Map<String,String> values;

  PeanutObject(){
    values=new Map<String,String>();
  }

  String GetValue(String fieldName){
    return values[fieldName];
  }

  void SetValue(String fieldName,String content){
    values[fieldName]=content;
  }
}