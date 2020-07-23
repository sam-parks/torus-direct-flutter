import Flutter
import UIKit
import SafariServices

public class SwiftTorusDirectPlugin: NSObject, FlutterPlugin {
  var torusSwiftDirectSDK: TorusSwiftDirectSDK;
  var subVerifierDetails: SubVerifierDetails;
  
  override public init(){

    subVerifierDetails =  SubVerifierDetails(loginType: .installed,
                                                    loginProvider: .google,
                                                    clientId: "653095671042-san67chucuujmjoo218khq2rb92bh80d.apps.googleusercontent.com",
                                                    verifierName: "tokenizer-google-ios",
                                                    redirectURL: "com.googleusercontent.apps.653095671042-san67chucuujmjoo218khq2rb92bh80d:/oauthredirect")

    self.torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, 
                                                            aggregateVerifierName: "tokenizer-google-ios", 
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
        case "setOptions": 
            guard let args = call.arguments as? Dictionary<String, String> else {
              result("iOS could not recognize flutter arguments in method: (sendParams)") 
              break
            }
            let verifierTypeString : String  =  args["verifierType"]! as String
            let loginProviderString : String =  args["loginProvider"]! as String
            let clientId : String  =  args["clientId"]! as String
            let verifierName : String  = args["verifierName"]! as String
            let redirectURL : String =  args["redirectURL"]! as String
          

            subVerifierDetails = SubVerifierDetails(loginType: .installed,
                                                    loginProvider: LoginProviders(rawValue:loginProviderString)!,
                                                    clientId: clientId,
                                                    verifierName: verifierName,
                                                    redirectURL: redirectURL)
            self.torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType: verifierTypes(rawValue: verifierTypeString)!, 
                                                            aggregateVerifierName: verifierName, 
                                                            subVerifierDetails: [subVerifierDetails], loglevel: .trace)

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


