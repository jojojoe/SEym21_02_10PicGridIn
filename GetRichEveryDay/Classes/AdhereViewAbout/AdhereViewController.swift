//
//  ViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/2.
//

import UIKit
import Alertift

class AdhereViewController: UIViewController {
    
    let topView = TopUserCoinsView()
    let collectionCellID = "AdhereViewController"
    var collectionView: UICollectionView?
    var fDataArray: Array<PurchaseItemModel> = []
    var adhereNumLabel = UILabel()
    var adhereNumImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        topView.backgroundColor = .black
        topView.enterStyle(styel: .nameAndCoins)
        topView.loadCurrentUserInfo()
        topView.coinsButtonClickCallBack = {
            NotificationCenter.default.post(name: .GREDJumpToStore, object: nil)
        }
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(currentDiviceIsFullSceen() ? 88 : 64)
        }
        
        adhereNumLabel.textAlignment = .left
        adhereNumLabel.textColor = .white
        adhereNumLabel.font = UIFont(name: fontHiraginoSansW6, size: 10)
        adhereNumLabel.text = "My \(String.init(utf8String: uStrF)!): \(digitalFormat(num: UserManage.default.currentUserModel?.userAdheretNum ?? 0))"
        self.view.addSubview(adhereNumLabel)
        adhereNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(topView.snp.bottom).offset(5)
            make.height.equalTo(12)
        }
        
        adhereNumImageView.image = UIImage(withBundleName: "get_like_post_refresh_ic")
        self.view.addSubview(adhereNumImageView)
        adhereNumImageView.snp.makeConstraints { (make) in
            make.left.equalTo(adhereNumLabel.snp.right).offset(10)
            make.width.height.equalTo(10)
            make.centerY.equalTo(adhereNumLabel)
        }
        
        let reloadButton = UIButton()
        reloadButton.addTarget(self, action: #selector(reloadButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.left.equalTo(adhereNumLabel.snp.left).offset(0)
            make.right.equalTo(adhereNumImageView.snp.right).offset(0)
        }
        
        cacheData()
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notify:)), name: .GREDReloadData, object: nil)
        request()
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: screenWidth_Int - 70, height: 48)
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView?.backgroundColor = .black
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.register(AdhereCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints({ (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.bottom.equalTo(0)
        })
    }
    
    func cacheData() {
        let item1 = PurchaseItemModel.init()
        item1.itemCount = 10
        item1.localizedPrice = "$1.11"
        item1.itemType = EPurchaseItemType.Ef_money
        
        let item2 = PurchaseItemModel.init()
        item2.itemCount = 30
        item2.localizedPrice = "$5.99"
        item2.itemType = EPurchaseItemType.Ef_money
        
        let item3 = PurchaseItemModel.init()
        item3.itemCount = 65
        item3.localizedPrice = "$8.88"
        item3.itemType = EPurchaseItemType.Ef_money
        
        let item4 = PurchaseItemModel.init()
        item4.itemCount = 150
        item4.localizedPrice = "$18.88"
        item4.itemType = EPurchaseItemType.Ef_money
        
        let item5 = PurchaseItemModel.init()
        item5.itemCount = 10
        item5.localizedPrice = "200"
        item5.costTotal = "200"
        item5.itemType = EPurchaseItemType.Ef_coins
        
        let item6 = PurchaseItemModel.init()
        item6.itemCount = 20
        item6.localizedPrice = "400"
        item6.costTotal = "400"
        item6.itemType = EPurchaseItemType.Ef_coins
        
        let item7 = PurchaseItemModel.init()
        item7.itemCount = 60
        item7.localizedPrice = "1200"
        item7.costTotal = "1200"
        item7.itemType = EPurchaseItemType.Ef_coins
        
        let item8 = PurchaseItemModel.init()
        item8.itemCount = 200
        item8.localizedPrice = "4000"
        item8.costTotal = "4000"
        item8.itemType = EPurchaseItemType.Ef_coins
        
        self.fDataArray = [item1, item2, item3, item4, item5, item6, item7, item8]
    }
    
    @objc func reloadButtonClick(button: UIButton) {
        guard let currentUserModel = UserManage.default.currentUserModel else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            return
        }
        UserManage.userInfoUpload(showHub: true)
    }
    
    @objc func userlogin(notify: Notification) {
        self.request()
        topView.loadCurrentUserInfo()
        adhereNumLabel.text = "My \(String.init(utf8String: uStrF)!): \(digitalFormat(num: UserManage.default.currentUserModel?.userAdheretNum ?? 0))"
    }
    
    @objc func reloadData(notify: Notification) {
        refreshData()
    }
    
    func request() {
        self.refreshData()
    }
    
    func refreshData() {
        let dataArray = PurchaseItemCollectionManage.default.obtainItems(withPurchaseItemType: .Ef_money, .Ef_coins)
        if dataArray.count > 0  {
            self.fDataArray = dataArray
            self.collectionView?.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.loadCurrentUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension AdhereViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as? AdhereCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? AdhereCollectionViewCell
        let itemModel = fDataArray[indexPath.row]
        cell?.enterData(purchasemodel: itemModel)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let currentUserModel = UserManage.default.currentUserModel else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            return
        }
        
        let itemModel = fDataArray[indexPath.row]
        
        if itemModel.itemType == EPurchaseItemType.Ef_money {
            PurchaseItemCollectionManage.default.startBuy(purchase: itemModel, node: nil, isAdheret: true)
        } else {
            buy(buyType: itemModel.itemType, userMoel: currentUserModel, itemModel: itemModel)
        }
        
    }
    
    // 购买
    func buy(buyType: EPurchaseItemType?, userMoel: UserModel, itemModel: PurchaseItemModel) {
        
        switch buyType {
        case .Ef_money:
            break
            
        case .Ef_coins:
            AdjustManage.sharedInstance.pointPurchaseItemClick()
            guard let coinsNum = itemModel.costTotal?.int, let itemNum = itemModel.itemCount else {
                return
            }
            
            if (userMoel.userNativeCoinsNum ?? 0) >= coinsNum {
                HubManager.show()
                RequestNetWork.requestCoinsForever(isPromotion: false, foreverSize: itemNum, success: {
                        // 用户资料变更
                    AdjustManage.sharedInstance.pointExchangeSuccessFollowerTotal()
                    HubManager.success("Buy Success")
                    UserManage.userInfoUpload()
                }) { (error) in
                    Alertift.alert(title: error.localizedDescription, message: nil)
                    .action(.cancel("OK")) { _, _, _ in
                    }
                    .show(on: self.visibleVC, completion: nil)
                }
                
            } else {
                Alertift.alert(title: "Coins Shortage", message: nil)
                .action(.cancel("OK")) { _, _, _ in
                    NotificationCenter.default.post(name: .GREDJumpToStore, object: nil)
                }
                .show(on: visibleVC, completion: nil)
            }
            break
        default:
            break
        }
    }
}
