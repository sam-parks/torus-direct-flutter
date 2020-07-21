import Flutter
import UIKit
import SafariServices

public class SwiftTorusDirectPlugin: NSObject, FlutterPlugin {

  let torusSwiftDirectSDK;
  
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "torus.flutter.dev/torus-direct", binaryMessenger: registrar.messenger())
    let instance = SwiftTorusDirectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "init":
            let arguments = call.arguments as! NSDictionary
            let verifierType = arguments["verifierType"] as! String
            let verifierName = arguments["verifierName"] as! String
            let clientId = arguments["clientID"] as! String
            let typeOfLogin = arguments["typeOfLogin"] as! String
            let verifier = arguments["verifier"] as! String
            let subVerifierDetails = [["clientId": clientId,
                                   "typeOfLogin": typeOfLogin,
                                   "verifier": verifier]]
  
            torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType: verifierType, aggregateVerifierName: verifierName, subVerifierDetails: subVerifierDetails)
            result("success")

        case "triggerLogin":
            torusSwiftDirectSDK.triggerLogin(browserType: .external).done
            { 
              data in print("private key rebuild", data)
              result(data)
                        }.catch { 
                                result(FlutterError.init(code: "NATIVE_ERR",
                                                 message: "Error: " + err,
                                                 details: nil))
                              }
                               
        default:
            result(FlutterMethodNotImplemented)
        }
    }
       
      
  }

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    
    var url: URL?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url!)
    }
    
    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

