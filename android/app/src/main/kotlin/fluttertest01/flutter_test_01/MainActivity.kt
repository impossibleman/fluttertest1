package fluttertest01.flutter_test_01

import android.annotation.SuppressLint
import android.content.Context
import android.net.ConnectivityManager
import android.os.Bundle
import android.util.Log
//import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){

//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        GeneratedPluginRegistrant.registerWith(FlutterEngine(this));
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"firstcall").setMethodCallHandler{
//            methodCall, result ->  FlutterCallBackTest(methodCall,result)
//        }
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this));
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"firstcall").setMethodCallHandler{
            methodCall, result ->  FlutterCallBackTest(methodCall,result)
        }
    }

    @SuppressLint("NewApi")
    private fun FlutterCallBackTest(call:MethodCall,result:MethodChannel.Result){
        when(call.method){
            "test"->{
                Log.d("TAG","get info from flutter")
            }
            "checknet"->{
                Log.d("TAG","judge net state")
                var connectivityManager: ConnectivityManager= getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                var netInfo=connectivityManager.allNetworks
                if(netInfo!=null){
                    Log.d("TAG","net connected")
                    result.success(1)
                }
                else{
                    Log.d("TAG","net disconnected")
                    result.success(0)
                }
            }
        }
    }
}
