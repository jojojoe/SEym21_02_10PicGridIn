import UIKit
import WebKit
import CoreTelephony

class WebPurchaseViewController: UIViewController {
    
    let loadingView = UIActivityIndicatorView(style: .gray)
    let dismissButton = UIButton()
    
    var didDisApear: (() -> Void)?
    
    let configurations = [
        "CallAppStoreMessagehandler",
        "AppIapHandler",
        "PaySuccessHandler",
        "baseMessagehandler",
    ]
    
    var purchaseURL: URL {
        
        var url = URL(string: "https://pay.so\("cialc")ube.me/")!
        
        debugOnly {
            url = URL(string: "https://testpay.socialcube.me/")!
        }
        return url
    }
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        
        configurations.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        
        var webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
        webView.scrollView.bounces = false
        
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        
        return webView
    }()
    
    let parameters: [String: Any]
    
    var successBlock: ((Bool, [String: Any]) -> Void)?
    var iapDidSelect: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dismissButton.setImage(UIImage(withBundleName: "Marsclose-1"), for: .normal)
        dismissButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        view.addSubview(webView)
        view.addSubview(loadingView)
        view.addSubview(dismissButton)
        
        var request = URLRequest(url: purchaseURL)
        request.timeoutInterval = 60
        webView.load(request)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisApear?()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dismissButton.frame = CGRect(x: 0, y: view.safeArea.top, width: 44, height: 44)
        
        webView.frame = view.bounds
        loadingView.frame = view.bounds
    }
    
    init(isDirectFans: Bool,
         userID: String,
         token: String,
         productID: String,
         promotionId: String,
         isPromotion: Bool,
         mediaUrl: String,
         directFavorMediaId: String,
         price: String,
         originPrice: String,
         goodName: String,
         num: String,
         promoteRate: String,
         currencyCode: String,
         idfa: String,
         completion: ((Bool, [String: Any]) -> Void)?,
         iapBlock: (() -> Void)?) {
        
        let countryCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode ?? "US"
        let appName = UIApplication.shared.displayName ?? "Baseline"
        let bundleIdentifier = obtainBundleIdentifier()
        
        parameters = [
            "x1pk": userID,
            "1iyp": isDirectFans.int,
            "garg": productID,
            "5krp": isPromotion.int,
            "klyl": mediaUrl,
            "ym15": directFavorMediaId,
            "p5tv": token,
            "p4ce": price,
            "n5v6": goodName,
            "f4ez": num,
            "ixx6": "iOS",
            "tyre": promoteRate,
            "m9wy": promotionId,
            "hw3i": appName,
            "inh2": currencyCode,
            "vzhn": idfa,
            "mmes": originPrice,
            "pgti": countryCode,
            "zojt": bundleIdentifier,
        ]
        
        super.init(nibName: nil, bundle: nil)
        
        successBlock = completion
        iapDidSelect = iapBlock
    }
    
    init() {
        parameters = [:]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WebPurchaseViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any] {
            let methodName = body["methodName"] as? String
            let params = body["params"] as? [String: Any]
            
            switch methodName {
            case "closeWebView":
                dismiss(animated: true, completion: nil)
            case "invokeOpenAppStore":
                if let appStoreUrl = params?["appStoreUrl"] as? String {
                    UIApplication.shared.openURL(url: appStoreUrl)
                }
            case "invokePaySuccessFunction":
                if let params = params {
                    dismiss(animated: true, completion: nil)
                    successBlock?(true, params)
                }
            case "invokeAppleIapFunction":
                iapDidSelect?()
            default:
                break
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        dismissButton.isHidden = true
        loadingView.stopAnimating()
        if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
            let dataString = String(data: data, encoding: .utf8) {
            webView.evaluateJavaScript("configureOrderInfo(\(dataString))") { _, _ in
            }
        }
    }
    
    // MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        loadingView.startAnimating()
    }
    
    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        //        dismiss(animated: true, completion: nil)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}

