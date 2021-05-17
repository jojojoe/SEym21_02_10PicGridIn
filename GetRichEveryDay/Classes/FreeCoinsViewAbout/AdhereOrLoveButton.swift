//
//  AdhereOrLoveButton.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/9.
//

import UIKit
import RxCocoa
import RxSwift

protocol AdHereOrLoveButtonDelegate: class {
    func buttonClick()
}

class AdHereOrLoveButton: UIView {
    
    let titleLabel = UILabel()
    let coinsLabel = UILabel()
    let button = UIButton()
    let emptyView = UIImageView()
    var adhereCoins = "+4"
    var loveCoins = "+1"
    var isLove = true

    weak var delegate: AdHereOrLoveButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(withBundleName: "get_coins_like_btn_bg_ic")
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        titleLabel.text = String.init(utf8String: uStrf)!
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: fontHiraginoSansW6, size: 14)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }

        self.button.rx.tap.asObservable().debounce(.milliseconds(240), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in
            self?.delegate?.buttonClick()
        })
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    func getOneLoveAndAdhereCoins() {
        if let user = UserManage.default.currentUserModel {
            
            self.adhereCoins = "+" + user.userOneAdhereGetCoins
            self.loveCoins = "+" + user.userOneLoveGetCoins
            
            if self.isLove {
                coinsLabel.text = self.loveCoins
            } else {
                coinsLabel.text = self.adhereCoins
            }
        }
    }
    
    func typeLove(isEmpty: Bool) {
        self.isLove = true
        if isEmpty {
            titleLabel.text = "Reload"
            return
        }
        
        let lKey = String.init(utf8String: uStrl)!
        titleLabel.text = lKey + " " + self.loveCoins + "🌟"
    }
    
    func typeAdhere(isEmpty: Bool) {
        self.isLove = false
        if isEmpty {
            titleLabel.text = "Reload"
            return
        }
        
        let fKey = String.init(utf8String: uStrf)!
        titleLabel.text = fKey + " " + self.adhereCoins + "🌟"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
