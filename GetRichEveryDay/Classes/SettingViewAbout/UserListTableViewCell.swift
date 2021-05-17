//
//  UserListTableViewCell.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/4.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    let userIcon = UIImageView()
    let userName = UILabel()
    let selectImageView = UIImageView()
    let bgView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let bgView = UIView()
        self.contentView.addSubview(bgView)
        
        userIcon.layer.cornerRadius = 12
        userIcon.layer.masksToBounds = true
        bgView.addSubview(userIcon)
        userIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        userName.textAlignment = .left
        userName.textColor = .white
        userName.font = UIFont(name: fontHiraginoSansW6, size: 14)
        userName.sizeToFit()
        bgView.addSubview(userName)
        userName.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.equalTo(userIcon.snp.right).offset(14)
            make.right.equalTo(0)
        }
        
        selectImageView.backgroundColor = .clear
        selectImageView.image = UIImage(withBundleName: "setting_profile_select_ic")
        bgView.addSubview(selectImageView)
        selectImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(9)
            make.bottom.equalTo(userIcon.snp.bottom).offset(2)
            make.right.equalTo(userIcon.snp.right).offset(2)
            
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(24 + 14 + userName.size.width).priority(100)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width  - 100)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
    }
    
    func enterUserName(userName: String) {
        self.userName.text = userName
        self.bgView.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
