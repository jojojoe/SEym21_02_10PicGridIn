//
//  ViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/2.
//

import UIKit
import Alertift
import MJRefresh

class LoveViewController: UIViewController {

    let topView = TopUserCoinsView()
    let cellID = "LoveNodeViewCellID"
    var haveNext = true // true 表示可以进行分页请求 可以请求
    var dataArray: Array<Node> = []
    var collectionView: UICollectionView?
    let reloadButton = UIButton()
    let emptyImageView = UIImageView()
        
    let tipLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChange(notify:)), name: .GREDUserChange, object: nil)
        
        tipLabel.text = "There are currently no posts, if you need to purchase, post."
        tipLabel.isHidden = true
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.init(hexString: "#909090")
        tipLabel.font = UIFont(name: fontHiraginoSansW6, size: 12)
        tipLabel.numberOfLines = 0
        self.view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
        emptyImageView.isHidden = true
        emptyImageView.image = UIImage(withBundleName: "no_post_ic")
        self.view.addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints { (make) in
            make.width.equalTo(24)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(tipLabel.snp.top).offset(-20)
        }
        
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        
        var space: CGFloat = CGFloat((screenWidth_Int - 182 - 18) / 2)
        layout.itemSize = CGSize(width: 91, height: 91)
        if currentDiviceIsFullSceen() {
            space = CGFloat((screenWidth_Int - 240 - 18) / 2)
            layout.itemSize = CGSize(width: 120, height: 120)
        }
        
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 10, left: space, bottom: 10, right: space)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView!.backgroundColor = .clear
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.showsVerticalScrollIndicator = false
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.register(LoveNodeCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView?.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
            self.requestNoed(isRefresh: false)
        })
        
        self.view.addSubview(self.collectionView!)
        
        self.collectionView!.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-30)
        }
        
        reloadButton.setImage(UIImage(withBundleName: "get_like_post_refresh_ic"), for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(-18)
            make.top.equalTo(self.topView.snp.bottom).offset(0)
        }
    }
    @objc func reloadButtonClick(button: UIButton) {
        refreshData()
    }
    
    @objc func userlogin(notify: Notification) {
        
        if UserManage.default.currentUserModel == nil {
            self.dataArray = []
            self.collectionView?.reloadData()
            return
        }
        
        topView.loadCurrentUserInfo()
    }
    
    @objc func userChange(notify: Notification) {
        if UserManage.default.currentUserModel != nil {
            refreshData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.loadCurrentUserInfo()
        if self.dataArray.count == 0 && (UserManage.default.currentUserModel != nil){
            refreshData()
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

extension LoveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.dataArray.count
        self.tipLabel.isHidden = count == 0 ? false : true
        emptyImageView.isHidden = self.tipLabel.isHidden
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? LoveNodeCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let node = self.dataArray[indexPath.row]
        let cell = cell as? LoveNodeCollectionViewCell
        cell?.assignment(imageUrl: node.displayUrl,
                        loveNum: digitalFormat(num: node.edgeLoveBy ?? 0),
                        type: node.mediaType ?? 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let node = self.dataArray[indexPath.row]
        let loveBuyVC = LoveBuyViewController()
        loveBuyVC.nodeModel = node
        loveBuyVC.modalTransitionStyle = .crossDissolve
        loveBuyVC.modalPresentationStyle = .fullScreen
        
        var typeImage = UIImage()
        switch node.mediaType {
        case 1:
            typeImage = UIImage()
            break
            
        case 2:
            typeImage = UIImage(withBundleName: "MarsVideo")!
            break
            
        case 8:
            typeImage = UIImage(withBundleName: "MarsImages")!
            break
            
        case 11:
            typeImage = UIImage(withBundleName: "he_ic_igtv")!
            break
        default:
            break
        }
        
        loveBuyVC.typeImageView.image = typeImage
        
        self.present(loveBuyVC, animated: true) {
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//        print(scrollView.contentSize.height - scrollView.frame.size.height - 20)
//        print(scrollView.contentOffset.y)
//        print("======================================================================")
//
//        if scrollView.contentSize.height - scrollView.frame.size.height - 20 == scrollView.contentOffset.y {
//            requestNoed(isRefresh: false)
//        }
//    }
    
    func refreshData() {
        requestNoed(isRefresh: true)
    }
    
    private func requestNoed(isRefresh: Bool) {
        
        if isRefresh {
            HubManager.show()
            self.haveNext = true
        }
                
        if !self.haveNext {
            return
        }
        
        guard let userCoreID = UserManage.default.currentUserModel?.userCore_ID else {
            return
        }
        
        var lastIDstr: String? = nil
        if self.dataArray.count > 0 && !isRefresh{
            lastIDstr = self.dataArray.last?.ID
        }
        
        RequestNetWork.requestUserNodes(userCoreID: userCoreID,
                                        count: 1,
                                        lastID: lastIDstr,
                                        success: { (resultArray, haveNext) in
                                            self.haveNext = haveNext
                                            
                                            if isRefresh {
                                                self.dataArray = []
                                            }
                                            
                                            if resultArray.count > 0 {
                                                self.dataArray += resultArray
                                            }
                                            
                                            self.collectionView?.reloadData()
                                            self.collectionView?.mj_footer?.endRefreshing()
                                            HubManager.hide()
                                            
        }) { (error) in
            debugPrint("requestUserNodes error")
            HubManager.hide()
        }
    }
}
