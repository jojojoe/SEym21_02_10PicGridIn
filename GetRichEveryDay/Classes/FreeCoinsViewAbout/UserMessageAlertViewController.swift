import UIKit

class UserMessageAlertViewController: UIViewController {
    
    let tipsTitle = UILabel()
    let sublabel = UILabel()
    var msgContent: String?
    var msgTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.hexColor(hex: "#000000", alpha: 0.5)
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.hexColor(hex: "#FFFFFF")
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(265)
            make.center.equalTo(self.view)
        }
        
        tipsTitle.font = UIFont(name: "Avenir-Medium", size: 20)
        tipsTitle.text = msgTitle
        tipsTitle.textAlignment = .center
        tipsTitle.textColor = UIColor.hexColor(hex: "#3C3C3C")
        contentView.addSubview(tipsTitle)
        tipsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        sublabel.font = UIFont(name: "Avenir-Medium", size: 15)
        sublabel.text = msgContent ?? "We limit your fo\("llow")/l\("ike") actions to avoid getting “Action Blocked” on your account from In\("stag")ram. You will be able to continue after countdown."
        sublabel.textAlignment = .center
        sublabel.numberOfLines = 0
        sublabel.textColor = UIColor.hexColor(hex: "#3C3C3C")
        contentView.addSubview(sublabel)
        sublabel.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.top.equalTo(tipsTitle.snp.bottom).offset(5)
        }
        
        let okButton = UIButton()
        okButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        okButton.backgroundColor = UIColor.hexColor(hex: "#6D6ED7")
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont(name: fontAvenirMedium, size: 14)
        okButton.layer.cornerRadius = 10
        okButton.layer.masksToBounds = true
        contentView.addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.width.equalTo(262)
            make.height.equalTo(40)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-14)
        }
    }
    
    @objc func buttonClick(button: UIButton) {
        self.dismiss(animated: true) {
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
