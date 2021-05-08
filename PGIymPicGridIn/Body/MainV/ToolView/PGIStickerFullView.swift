//
//  PGIStickerFullView.swift
//  PGIymPicGridIn
//
//  Created by JOJO on 2021/4/30.
//

import UIKit

class PGIStickerFullView: UIView {
    var collection: UICollectionView!
    var backBtnClickBlock: (()->Void)?
    var selectBtnClickBlock: ((_ stickerItem: GCStickerItem)->Void)?
    var currentSelectIndexPath : IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PGIStickerFullView {
    func loadData() {
        
    }
    
    
    func setupView() {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "sticker_icon_return"), for: .normal)
        addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.height.width.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: GCStickerCell.self)
        
        
    }
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
    
    
}

extension PGIStickerFullView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = DataManager.default.stickerList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: GCStickerCell.self, for: indexPath)
        
        cell.contentImageView.image = UIImage(named: item.thumbnail)
        
        if currentSelectIndexPath?.item == indexPath.item {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        if item.isPro == false {
            cell.proImageV.isHidden = true
        } else {
            cell.proImageV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PGIStickerFullView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - (20 * 4) - 1) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension PGIStickerFullView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = DataManager.default.stickerList[indexPath.item]
        selectBtnClickBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

