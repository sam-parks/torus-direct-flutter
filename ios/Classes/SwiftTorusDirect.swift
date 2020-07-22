import Flutter
import UIKit
import SafariServices

public class SwiftTorusDirectPlugin: NSObject, FlutterPlugin {

  let torusSwiftDirectSDK: TorusSwiftDirectSDK;

  
  override public init(){

   let subVerifierDetails =  SubVerifierDetails(loginType: .installed,
                                                    loginProvider: .google,
                                                    clientId: "653095671042-san67chucuujmjoo218khq2rb92bh80d.apps.googleusercontent.com",
                                                    verifierName: "google-test-1594836702346",
                                                    redirectURL: "com.googleusercontent.apps.653095671042-san67chucuujmjoo218khq2rb92bh80d:/oauthredirect")

    self.torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, 
                                                            aggregateVerifierName: "google-test-1594836702346", 
                                                            subVerifierDetails: [subVerifierDetails], loglevel: .trace)
    super.init()                                              
  }



  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "torus.flutter.dev/torus-direct", binaryMessenger: registrar.messenger())
    let instance = SwiftTorusDirectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "triggerLogin":
            self.torusSwiftDirectSDK.triggerLogin(browserType: .external).done
            { 
              data in print("private key rebuild", data)
              result(data)
            }   
        default:
            result(FlutterMethodNotImplemented)
        }
    } 
  }


