import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:flutter_test_01/constant/ConstantAssemble.dart';
import 'package:flutter_test_01/datastructor/GoodsClassify.dart';
import 'package:flutter_test_01/datastructor/GoodsDetail.dart';

class DBOperator {
  static Database db;

  Future<int> InitDbInstance() async {
    var resultCode;
    if(db==null){
      String dbDirectory = await getDatabasesPath();
      print(dbDirectory);
      db = await openDatabase(join(dbDirectory, "test.db"), version: 1,
          onCreate: (db, newVersion) {
            db.execute("create table " +
                ConstantAssemble.DATABASE_TABLENAME_CLASSIFY +
                " (classifyid int primary key,classifyname text)");
            db.execute("create table " +
                ConstantAssemble.DATABASE_TABLENAME_DETAIL +
                " (goodsid int primary key,name text,description text,imageurl text,originalprice double,currentprice double,classifyid int,classifyname text)");
            db.execute("create table " +
                ConstantAssemble.DATABASE_TABLENAME_HEADIMAGE +
                " (id int primary key,selectedindex int)");
          });
      resultCode=0;
    }
    else{
      resultCode=1;
    }
    return resultCode;
  }

  Future<List<GoodsClassify>> GetClassify() async{
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_CLASSIFY );
    List<GoodsClassify> classify=new List();
    for(Map<String,dynamic> eachSource in sourceData){
      GoodsClassify singleClassify=new GoodsClassify();
      singleClassify.classifyId=eachSource["classifyid"];
      singleClassify.classifyName=eachSource["classifyname"];
      classify.add(singleClassify);
    }
    return classify;
  }

  void StoreClassify(List<GoodsClassify> classify)  async{
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_CLASSIFY );
    if(sourceData.length!=0){
      int resultCode=await DeleteClassify();
      print(resultCode.toString());
    }
    print("Database ----- begin to store classify");
    for(GoodsClassify singleClassify in classify){
      db.rawInsert("insert into "+ConstantAssemble.DATABASE_TABLENAME_CLASSIFY+"(classifyid,classifyname) values (?,?)",[singleClassify.classifyId.toString(),singleClassify.classifyName]);
    }
  }

  Future<int> DeleteClassify() async{
    int resultCode= await db.delete(ConstantAssemble.DATABASE_TABLENAME_CLASSIFY );
    return resultCode;
  }

  Future<List<GoodsDetail>> GetGoodsinfos(int classifyId) async{
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_DETAIL+" where classifyid="+ classifyId.toString());
    List<GoodsDetail> goodsInfo=new List();
    for(Map<String,dynamic> eachSource in sourceData){
      GoodsDetail singleDetail=new GoodsDetail();
      singleDetail.goodsId=eachSource["goodsid"];
      singleDetail.name=eachSource["name"];
      singleDetail.description=eachSource["description"];
      singleDetail.imageUrl=eachSource["imageurl"];
      singleDetail.originalPrice=eachSource["originalprice"];
      singleDetail.currentPrice=eachSource["currentprice"];
      singleDetail.classifyid=eachSource["classifyid"];
      singleDetail.classifyname=eachSource["classifyname"];
      goodsInfo.add(singleDetail);
    }
    return goodsInfo;
  }

  void StoreGoodsInfos(int classifyId,List<GoodsDetail> goodsInfo) async{
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_DETAIL+" where classifyid="+ classifyId.toString() );
    if(sourceData.length!=0){
      int resultCode=await DeleteGoodsInfosByClassifyId(classifyId);
      print(resultCode.toString());
    }
    print("Database ----- begin to store detail");
    for(GoodsDetail eachDetail in goodsInfo){
      db.rawInsert("insert into "+ConstantAssemble.DATABASE_TABLENAME_DETAIL+" (goodsid,name,description,imageurl,originalprice,currentprice,classifyid,classifyname) values (?,?,?,?,?,?,?,?)",[eachDetail.goodsId.toString(),eachDetail.name,eachDetail.description,eachDetail.imageUrl,eachDetail.originalPrice.toString(),eachDetail.currentPrice.toString(),eachDetail.classifyid.toString(),eachDetail.classifyname]);
    }
  }

  Future<int> DeleteGoodsInfosByClassifyId(int classifyId) async{
    int resultCode= await db.rawDelete("delete from "+ConstantAssemble.DATABASE_TABLENAME_DETAIL+" where classifyid="+classifyId.toString());
    return resultCode;
  }

  Future<int> StoreHeadImageIndex(int index) async{
    int resultCode;
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_HEADIMAGE);
    if(sourceData.length!=0){
      resultCode= await db.rawUpdate("update "+ConstantAssemble.DATABASE_TABLENAME_HEADIMAGE+" set selectedindex=");
    }
    else{
      resultCode= await db.rawInsert("insert into "+ConstantAssemble.DATABASE_TABLENAME_HEADIMAGE+"(selectedindex) values ("+index.toString()+")");
    }
    return resultCode;
  }

  Future<int> GetHeadImageIndex() async{
    int index;
    List<Map<String, dynamic>> sourceData=await db.rawQuery("select * from "+ConstantAssemble.DATABASE_TABLENAME_HEADIMAGE);
    if(sourceData.length!=0){
      Map<String, dynamic> FirstElement=sourceData[0];
      index=FirstElement["selectedindex"];
    }
    else{
      index=0;
    }
    return index;
  }
}
