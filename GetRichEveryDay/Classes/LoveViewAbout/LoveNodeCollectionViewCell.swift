//
//  LoveNodeCollectionViewCell.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/8.
//

import UIKit

class LoveNodeCollectionViewCell: UICollectionViewCell {
    let nodeImageView = UIImageView()
    let loveLabel = UILabel()
    let typeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .black
        self.contentView.layer.masksToBounds = true
        
        nodeImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(nodeImageView)
        nodeImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        self.loveLabel.font = UIFont(name: fontHiraginoSansW6, size: 12)
        self.loveLabel.textAlignment = .center
        self.loveLabel.textColor = UIColor.hexColor(hex: "#FFFFFF")
        self.loveLabel.backgroundColor = UIColor.init(hexString: "#000000", transparency: 0.6)
        self.contentView.addSubview(self.loveLabel)
        self.loveLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        typeImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(typeImageView)
        typeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.top.equalTo(3)
            make.right.equalTo(-3)
        }
    }
    
    func assignment(imageUrl: URL?, loveNum: String, type: Int) {
        
        if let url = imageUrl {
            nodeImageView.kf.indicatorType = .activity
            nodeImageView.kf.setImage(with: url)
        }
        self.loveLabel.text = "💖" + loveNum
        
        switch type {
        case 1:
            self.typeImageView.image = UIImage()
            break
            
        case 2:
            self.typeImageView.image = UIImage(withBundleName: "MarsVideo")
            break
            
        case 8:
            self.typeImageView.image = UIImage(withBundleName: "MarsImages")
            break
            
        case 11:
            self.typeImageView.image = UIImage(withBundleName: "he_ic_igtv")
            break
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
