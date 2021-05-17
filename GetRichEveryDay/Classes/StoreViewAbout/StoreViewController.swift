//
//  ViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/2.
//

import UIKit

class StoreViewController: UIViewController {
    
    let topView = TopUserCoinsView()
    let collectionCellID = "StoreViewController"
    var collectionView: UICollectionView?
    var fDataArray: Array<PurchaseItemModel> = []
    var topViewIsBack = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        cacheData()
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notify:)), name: .GREDReloadData, object: nil)
        
        topView.backgroundColor = .black
        topView.loadCurrentUserInfo()
        
        if topViewIsBack {
            topView.enterStyle(styel: .backAndCoins)
            topView.backButtonClickCallBack = {
                self.dismiss(animated: true) {
                }
            }
        } else {
            topView.enterStyle(styel: .nameAndCoins)
        }
        
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(currentDiviceIsFullSceen() ? 88 : 64)
        }
        
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
        self.collectionView?.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints({ (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(currentDiviceIsFullSceen() ? 90 : 30)
            make.bottom.equalTo(0)
        })
        
        refreshData()
    }
    
    func cacheData() {
        let item1 = PurchaseItemModel.init()
        item1.itemCount = 200
        item1.localizedPrice = "$1.11"
        
        let item2 = PurchaseItemModel.init()
        item2.itemCount = 600
        item2.localizedPrice = "$5.99"
        
        let item3 = PurchaseItemModel.init()
        item3.itemCount = 1300
        item3.localizedPrice = "$8.88"
        
        let item4 = PurchaseItemModel.init()
        item4.itemCount = 3000
        item4.localizedPrice = "$18.88"
        
        let item5 = PurchaseItemModel.init()
        item5.itemCount = 8000
        item5.localizedPrice = "$48.88"
        
        let item6 = PurchaseItemModel.init()
        item6.itemCount = 20000
        item6.localizedPrice = "$88.88"
        
        self.fDataArray = [item1, item2, item3, item4, item5, item6]
    }
    
    @objc func userlogin(notify: Notification) {
        refreshData()
        topView.loadCurrentUserInfo()
    }
    
    @objc func reloadData(notify: Notification) {
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.loadCurrentUserInfo()
    }
    
    func refreshData() {
        
        let arrayData = PurchaseItemCollectionManage.default.obtainItems(withPurchaseItemType: .ECoins_money)
        
        if arrayData.count > 0 {
            self.fDataArray = arrayData
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AdjustManage.sharedInstance.pointCoinsStoreImpression()
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

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as? StoreCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? StoreCollectionViewCell
        let itemModel = fDataArray[indexPath.row]
        cell?.enterData(purchasemodel: itemModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AdjustManage.sharedInstance.pointPurchaseItemClick()
        guard UserManage.default.currentUserModel != nil else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            return
        }
        
        let itemModel = fDataArray[indexPath.row]
        PurchaseItemCollectionManage.default.startBuy(purchase: itemModel, node: nil, isAdheret: nil)
    }
        
}
