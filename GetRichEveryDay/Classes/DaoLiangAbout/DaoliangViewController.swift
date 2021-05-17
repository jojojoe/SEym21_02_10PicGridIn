import UIKit
import AdSupport

class DaoliangViewController: UIViewController {
    
    let clouseButton = UIButton()
    let daoliangTitle = UILabel()
    let daoliangAppIcon = UIImageView()
    let daoliangAppName = UILabel()
    let daoliangDesc = UILabel()
    let downloadButton = UIButton()
    var daoliangNobackTransfer = false // 强制倒量
    var schemeModel: DaoliangSchemeModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.hexColor(hex: "#000000", alpha: 0.7)
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(322)
            make.height.equalTo(300)
            make.centerY.equalTo(self.view)
            make.centerX.equalTo(self.view)
        }
            
        self.downloadButton.backgroundColor = UIColor.init(hexString: "#6D6ED7")
        self.downloadButton.setTitle("Download", for: .normal)
        self.downloadButton.setTitleColor(.white, for: .normal)
        self.downloadButton.titleLabel?.font = UIFont(name: fontAvenirBlack, size: 18)
        self.downloadButton.titleLabel?.textAlignment = .center
        self.downloadButton.addTarget(self, action: #selector(downloadbuttonClick(button:)), for: .touchUpInside)
        self.downloadButton.layer.cornerRadius = 23
        self.downloadButton.layer.masksToBounds = true
        self.view.addSubview(self.downloadButton)
        self.downloadButton.snp.makeConstraints { (make) in
            make.width.equalTo(160)
            make.height.equalTo(46)
            make.bottom.equalTo(contentView.snp.bottom).offset(-18)
            make.centerX.equalTo(contentView)
        }
        
        self.daoliangAppIcon.backgroundColor = .white
        contentView.addSubview(self.daoliangAppIcon)
        self.daoliangAppIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.bottom.equalTo(contentView.snp.bottom).offset(-200)
            make.centerX.equalTo(self.downloadButton)
        }
        
        self.daoliangAppName.textColor = UIColor.hexColor(hex: "#195581")
        self.daoliangAppName.textAlignment = .center
        self.daoliangAppName.font = UIFont(name: fontAvenirBlack, size: 15)
        contentView.addSubview(self.daoliangAppName)
        self.daoliangAppName.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.top.equalTo(self.daoliangAppIcon.snp.bottom).offset(15)
            make.centerX.equalTo(self.daoliangAppIcon)
        }
        
        self.daoliangDesc.numberOfLines = 0
        self.daoliangDesc.textColor = UIColor.hexColor(hex: "#000000", alpha: 0.5)
        self.daoliangDesc.font = UIFont(name: fontAvenirHeavy, size: 12)
        self.daoliangDesc.textAlignment = .center
        contentView.addSubview(daoliangDesc)
        daoliangDesc.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(self.daoliangAppName.snp.bottom).offset(3)
            make.bottom.equalTo(self.downloadButton.snp.top).offset(-5)
        }
        
        self.clouseButton.setImage(UIImage(withBundleName: "Marsclose"), for: .normal)
        self.clouseButton.alpha = 0
        self.clouseButton.addTarget(self, action: #selector(closeButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(self.clouseButton)
        self.clouseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalTo(downloadButton)
            make.top.equalTo(contentView.snp.bottom).offset(16)
        }
    }
    
    func assignmentDaoliang(model: DaoliangSchemeModel) {
        self.schemeModel = model
        self.daoliangAppIcon.kf.indicatorType = .activity
        self.daoliangAppIcon.kf.setImage(with: URL.init(string: model.failpyIcon))
        self.daoliangAppName.text = model.productName
        let config = NativeConfigManage.default.config
        self.daoliangTitle.text = config?.cfgDliangTitle ?? ""
        self.daoliangDesc.text = config?.cfgDliangDesc ?? ""
    }
    
    @objc func downloadbuttonClick(button: UIButton) {

        let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if let appURL = URL.init(string: (schemeModel?.failpyUrl ?? "") + "?idfa=" + uuid) {
            UIApplication.shared.openURL(url: appURL)
            RequestNetWork.requestReardPost(productScheme: schemeModel?.scheme ?? "", deviceID: uuid) {
                debugPrint("success")
            }
        }
    }
    
    @objc func closeButtonClick(button: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        EventManage.trankEvent(eventToken: adJustDaoLiangShow)
        
        if !daoliangNobackTransfer {
            Timer.after(3) {
                UIView.animate(withDuration: 0.5) {
                    self.clouseButton.alpha = 1
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

