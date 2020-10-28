//
//  FF_VV.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/24.

/*
import UIKit




class FF_VV: UICollectionView, UICollectionViewDelegate {
    
    var vv_catorView: UIActivityIndicatorView!
  
    var vv_domain: String!
    var vv_pageParameter: Int!
    var vv_otherParameter: String!
//    var vv_link: String!
    // 装着所有页的集合，用于刷新顺序
    var vv_index: Int = 0
    // 一共有多少页
    var vv_pageTotal: Int!
    // 所有页的集合
    var vv_allPageArr: [Int] = []
    // id的集合
    var vv_idArray: [Int] = []
    // 名字集合
    var vv_naArray: [String] = []
    // 标题集合
    var vv_lbArray: [String] = []
    var vv_showImagePathArr: [String] = []
    var vv_isMinWidth: Bool = true

    var vv_delerate: FF_ViewContro2Protocol?
    
    var vv_frame: CGRect!

    init(frame: CGRect,collectionViewLayout: UICollectionViewLayout, domain: String) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.frame = frame
        self.vv_domain = domain
        vv_otherParameter = "&pageSize=4"
        ff_setAttribute()
        ff_setNoloadCator()
        ff_initRefress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ff_setAttribute() {
        backgroundColor = .clear
        layoutIfNeeded()
        delegate = self
        dataSource = self
//        register(NSClassFromString("UICollectionViewCell"), forCellWithReuseIdentifier: "itemId")
        register(FF_CVCellLast.self, forCellWithReuseIdentifier: "itemId")
    }
    
    func ff_setNoloadCator() {
        vv_catorView = UIActivityIndicatorView()
        vv_catorView.center = self.center
        vv_catorView.stopAnimating()
        self.addSubview(vv_catorView)
    }

    
    
    func ff_initRefress() {
        let link: String
        var pageParameter: Int
        if vv_pageTotal == nil {
            pageParameter = 1
            link = vv_domain + pageParameter.description + vv_otherParameter
            vv_catorView.startAnimating()
        }else {
            pageParameter = Int(arc4random_uniform(UInt32(vv_pageTotal!)))
            link = vv_domain + pageParameter.description + vv_otherParameter
        }
        vv_index = 0
        vv_allPageArr.removeAll()
        vv_showImagePathArr.removeAll()
        vv_idArray.removeAll()
        vv_naArray.removeAll()
        vv_lbArray.removeAll()
        FF_Link.ff_dacodeImageCollectJsonData(path: link){ [unowned self]pathArr,total,idAY,naAY,lbAY    in
            vv_lbArray = lbAY
            vv_naArray = naAY
            vv_showImagePathArr = pathArr
            vv_idArray = idAY
            vv_pageTotal = total
            vv_allPageArr = FF_Link.number(end: vv_pageTotal)
            for dex in 0 ..< vv_allPageArr.count {
                if vv_allPageArr[dex] == pageParameter {
                    vv_allPageArr.remove(at: dex)
                    break
                }
            }
            vv_catorView.stopAnimating()
            self.mj_header?.endRefreshing()
            self.mj_footer?.endRefreshing()
            self.reloadData()
        } failure: { [unowned self] in
            vv_catorView.stopAnimating()
            self.mj_header?.endRefreshing()
            self.mj_footer?.endRefreshing()
            DispatchQueue.main.async { [unowned self] in
                let hud = MBProgressHUD.showAdded(to: self, animated: true)
                hud.mode = .text
                hud.label.text = "网络异常，请下拉刷新"
                hud.hide(animated: true, afterDelay: 8)
            }

        }
    }

    
}

extension FF_VV: UICollectionViewDataSource {
    // 返回分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 返回每个分区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vv_showImagePathArr.count
    }
    
    // 返回每个分区具体的数据载体item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath) as! FF_CVCellLast
        cell.ff_addInformation(imagePath: vv_showImagePathArr[indexPath.row], lb1Text: vv_lbArray[indexPath.row], lb3Text: vv_naArray[indexPath.row])

//        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath)
//
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 8
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.backgroundColor = .white
//        let cellImageView = UIImageView()
//        cellImageView.clipsToBounds = true
//        cellImageView.layer.cornerRadius = 6
//        cell.addSubview(cellImageView)
//        cellImageView.snp.makeConstraints { (make) in
//
//            let scale = ff_getWidthHeitghScale(w: 98, h: 75)
//            make.top.equalTo(8)
//            make.bottom.equalTo(-8)
//            make.left.equalTo(8)
//            make.width.equalTo(cellImageView.snp.height).multipliedBy(scale)
//
//        }
//        let imageURL = URL(string: vv_showImagePathArr[indexPath.row])
//        cellImageView.kf.indicatorType = .activity
//        cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "icon-jiazai"))
//
//        let lable1 = UILabel()
//        lable1.text = "「图集」\(vv_lbArray[indexPath.row])图集"
//        lable1.font = UIFont.init(name: "PingFang SC", size: 12)
//        lable1.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        lable1.textAlignment = .right
//        lable1.adjustsFontSizeToFitWidth = true
//        cell.addSubview(lable1)
//        lable1.snp.makeConstraints { (make) in
////            make.top.equalTo(7)
////            make.height.equalTo(12)
////            make.right.equalTo(-11)
////            make.left.equalTo(20)
//            let a = ff_widthScaleTransform(x: 164, y: 9, width: 96, height: 12, actualWidth: cell.frame.width, actualHeight: cell.frame.height, templateWidth: 271, templateHeigh: 91)
//            make.center.equalTo(CGPoint(x: a[0], y: a[1]))
//            make.size.equalTo(CGSize(width: a[2], height: a[3]))
//        }
//
//        let lable2 = UILabel()
//        lable2.text = "进去看看"
//        lable2.textAlignment = .center
//        lable2.font = UIFont.init(name: "PingFang SC", size: 13)
//        lable2.textColor = UIColor(red: 1, green: 0.78, blue: 0.39, alpha: 1)
//        lable2.backgroundColor = UIColor(red: 0.39, green: 0.17, blue: 0.97, alpha: 1)
//        lable2.layer.cornerRadius = 15
//        lable2.clipsToBounds = true
//        cell.addSubview(lable2)
//        lable2.snp.makeConstraints { (make) in
////            make.top.equalTo(50)
////            make.left.equalTo(cellImageView.snp.right).offset(10)
////            make.width.equalTo(62)
////            make.height.equalTo(26)
//            let a = ff_widthScaleTransform(x: 116, y: 56, width: 76, height: 26, actualWidth: cell.frame.width, actualHeight: cell.frame.height, templateWidth: 271, templateHeigh: 91)
//            make.center.equalTo(CGPoint(x: a[0], y: a[1]))
//            make.size.equalTo(CGSize(width: a[2], height: a[3]))
//        }
//
//        let lable3 = UILabel()
//        lable3.text = vv_naArray[indexPath.row]
//        lable3.font = UIFont.init(name: "PingFang SC", size: 14)
//        lable3.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
//        cell.addSubview(lable3)
//        lable3.snp.makeConstraints { (make) in
////            make.left.equalTo(cellImageView.snp.right).offset(10)
////            make.right.equalTo(0)
////            make.top.equalTo(25)
////            make.height.equalTo(20)
//            let a = ff_widthScaleTransform(x: 116, y: 25, width: 122, height: 20, actualWidth: cell.frame.width, actualHeight: cell.frame.height, templateWidth: 271, templateHeigh: 91)
//            make.center.equalTo(CGPoint(x: a[0], y: a[1]))
//            make.size.equalTo(CGSize(width: a[2], height: a[3]))
//
//        }
        return cell
    }
    
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let path = "https://api.hulktech.cn/image/getImageList?page=1&pageSize=10&image_set_id=" + vv_idArray[indexPath.row].description
        FF_Link.ff_dacodeNewestJsonData(path: path) { [self] (iamgePathArr, a) in
            vv_delerate?.ff_1(pathArr: iamgePathArr)
        } failure: {
            DispatchQueue.main.async { [unowned self] in
                let hud = MBProgressHUD.showAdded(to: self, animated: true)
                hud.mode = .text
                hud.label.text = "请求失败"
                hud.hide(animated: true, afterDelay: 8)
            }

        }

    }
    
}

extension FF_VV: UICollectionViewDelegateFlowLayout {
    // 动态设置每个Item的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scale = ff_getHeightWidthScale(h: 91, w: 271)
        let layoutWidth = (collectionView.bounds.size.width)
        let layoutHeight = layoutWidth*scale
        return CGSize(width: layoutWidth, height: layoutHeight)
        
    }
    
    // 向委托询问节的连续行或列之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8.ff_heitghTransform()
    }


}


extension FF_VV {
    func ff_newestHeaderRefresh() {
        ff_initRefress()
    }
    
    func ff_footerRefresh() {
        if vv_pageTotal == nil {
            ff_initRefress()
        }else {
            if vv_index > vv_allPageArr.count - 1 {
                self.mj_footer!.endRefreshingWithNoMoreData()
            }else{
                let page = vv_allPageArr[vv_index]
                let link = vv_domain + page.description + vv_otherParameter
                vv_index = vv_index + 1
                FF_Link.ff_dacodeImageCollectJsonData(path: link){ [unowned self]pathArr,total,idAY,naAY,lbAY  in
                    self.vv_showImagePathArr = vv_showImagePathArr + pathArr
                    self.vv_idArray = vv_idArray + idAY
                    self.vv_naArray = vv_naArray + naAY
                    self.vv_lbArray = vv_lbArray + lbAY
                    self.mj_footer?.endRefreshing()
//                    self.willRemoveSubview(collectionViewLayout)
                    self.reloadData()
                } failure: {
                    DispatchQueue.main.async { [unowned self] in
                        self.mj_footer?.endRefreshing()
                        let hud = MBProgressHUD.showAdded(to: self, animated: true)
                        hud.mode = .text
                        hud.label.text = "网络异常，请下拉刷新"
                        hud.hide(animated: true, afterDelay: 8)
                    }
                }
            }
        }
    }
}

*/
