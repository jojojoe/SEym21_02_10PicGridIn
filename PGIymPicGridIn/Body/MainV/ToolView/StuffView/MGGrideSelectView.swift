//
//  MGGrideSelectView.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit

 

class MGGrideSelectView: UIView {

    let bgView = UIView()
    var collection: UICollectionView!
    var didSelectGridBlock: ((_ item: GridItem) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#F1F1EF")
        setupView()
        setupCollection()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        collection.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MGGrideSelectView {
    func setupView() {
        backgroundColor = .clear
        bgView.backgroundColor = .clear
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.left.top.bottom.right.equalToSuperview()
        }
         
        
        
    }
    
    func setupCollection() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        bgView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        collection.register(cellWithClass: MGGrideCell.self)
    }
    
}
    
extension MGGrideSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MGGrideCell.self, for: indexPath)
        let item = DataManager.default.gridList[indexPath.item]
        cell.contentImageV.image = UIImage(named: item.thumb ?? "")
        
        if item.isPro == false {
            cell.proImageV.isHidden = true
        } else {
            cell.proImageV.isHidden = false
        }
         
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.gridList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MGGrideSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension MGGrideSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let grid = DataManager.default.gridList[indexPath.item]
        didSelectGridBlock?(grid)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

    

class MGGrideCell: UICollectionViewCell {
    
    let contentImageV: UIImageView = UIImageView()
    let selectView: UIImageView = UIImageView()
    let proImageV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        addSubview(contentImageV)
        contentImageV.contentMode = .scaleAspectFit
        contentImageV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        selectView.layer.borderWidth = 1
        selectView.layer.borderColor = UIColor(hexString: "#FF4766")?.cgColor
        selectView.image = UIImage(named: "")
        selectView.isHidden = true
        addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        proImageV.image = UIImage(named: "grid_icon_vip")
        proImageV.isHidden = true
        addSubview(proImageV)
        proImageV.snp.makeConstraints {
            $0.centerX.equalTo(contentImageV.snp.right)
            $0.centerY.equalTo(contentImageV.snp.top)
            $0.width.height.equalTo(15)
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            selectView.isHidden = !isSelected
            if isSelected {
                
            } else {
                
            }
        }
    }
    
}
    
    
    

