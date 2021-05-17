//
//  AdhereCollectionViewCell.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/7.
//

import UIKit

class AdhereCollectionViewCell: UICollectionViewCell {
    
    let bgImageView = UIImageView()
    let cellTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgImageView.image = UIImage(withBundleName: "store_buy_item_bg_ic")
        self.contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        cellTitleLabel.textAlignment = .center
        cellTitleLabel.textColor = .white
        cellTitleLabel.font = UIFont(name: fontHiraginoSansW6, size: 18)
        self.contentView.addSubview(cellTitleLabel)
        cellTitleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    func enterData(purchasemodel: PurchaseItemModel) {
        
        if purchasemodel.itemType == EPurchaseItemType.Ef_coins {
            self.cellTitleLabel.text = "👩\((purchasemodel.itemCount?.toString())!) = 🌟\(String(purchasemodel.costTotal ?? "XXX"))"
            
        } else {
            self.cellTitleLabel.text = "👩\((purchasemodel.itemCount?.toString())!) = \(String(purchasemodel.localizedPrice))"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
