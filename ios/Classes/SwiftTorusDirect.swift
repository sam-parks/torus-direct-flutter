import Flutter
import UIKit
import SafariServices

public class SwiftTorusDirectPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "torus.flutter.dev/torus-direct", binaryMessenger: registrar.messenger())
    let instance = SwiftTorusDirectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "triggerLogin":
        let subVerifierDetails =  SubVerifierDetails(loginType: .installed,
                                                    loginProvider: .google,
                                                    clientId: "238941746713-vfap8uumijal4ump28p9jd3lbe6onqt4.apps.googleusercontent.com",
                                                    verifierName: "google-ios",
                                                    redirectURL: "com.googleusercontent.apps.238941746713-vfap8uumijal4ump28p9jd3lbe6onqt4:/oauthredirect")

        let torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType: .singleIdVerifier, 
                                                            aggregateVerifierName: "multigoogle-torus", 
                                                            subVerifierDetails: [subVerifierDetails])
            torusSwiftDirectSDK.triggerLogin(browserType: .external).done
            { 
              data in print("private key rebuild", data)
              result(data)
            }   
        default:
            result(FlutterMethodNotImplemented)
        }
    } 
  }


