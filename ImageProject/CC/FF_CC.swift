//
//  FF_CC.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/23.

/*
import UIKit
import MJRefresh
@objc protocol FF_ViewControProtocol {
    @objc optional func ff_(path: String, pathArr: [String])
    @objc optional func ff_1(path: String, pathArr: [String],id: Int)
}

class FF_CC: UICollectionView {
    
    var vv_catorView: UIActivityIndicatorView!
  
    var vv_domain: String!
    var vv_pageParameter: Int!
    var vv_otherParameter: String!
    var vv_link: String!
    // 装着所有页的集合，用于刷新顺序
    var vv_index: Int = 0
    // 一共有多少页
    var vv_pageTotal: Int!
    // 所有页的集合
    var vv_allPageArr: [Int] = []
    
    var vv_showImagePathArr: [String] = []
    var vv_isMinWidth: Bool = true

    var vv_delerate: FF_ViewControProtocol?
    
    var vv_frame: CGRect!
    
    var vv_header: MJRefreshNormalHeader!
    var vv_footer: MJRefreshAutoNormalFooter!

    init(frame: CGRect,collectionViewLayout: UICollectionViewLayout, domain: String) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.frame = frame
        self.vv_domain = domain

        vv_otherParameter = "&pageSize=12"
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
        register(FF_CVCellNewest.self, forCellWithReuseIdentifier: "itemId")
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
            pageParameter = Int(arc4random_uniform(20))
            link = vv_domain + pageParameter.description + vv_otherParameter
            vv_catorView.startAnimating()
        }else {
            pageParameter = Int(arc4random_uniform(UInt32(vv_pageTotal!)))
            link = vv_domain + pageParameter.description + vv_otherParameter
        }
        vv_index = 0
        vv_allPageArr.removeAll()
        vv_showImagePathArr.removeAll()
        FF_Link.ff_dacodeNewestJsonData(path: link){ [unowned self]pathArr,total in
            vv_showImagePathArr = pathArr
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
//            self.mj_footer?.endRefreshing()
            self.reloadData()
        } failure: { [self] in
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

extension FF_CC: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath) as! FF_CVCellNewest
        cell.ff_addInformation(imagePath: vv_showImagePathArr[indexPath.row])
        return cell
    }
    
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vv_delerate?.ff_!(path: vv_showImagePathArr[indexPath.row], pathArr: vv_showImagePathArr)
    }
    
}

extension FF_CC: UICollectionViewDelegateFlowLayout {
    // 动态设置每个Item的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch vv_isMinWidth {
        case true:
            let scale = ff_getHeightWidthScale(h: 106, w: 86)
            print(collectionView.bounds.size.width)
            let layoutWidth = (collectionView.bounds.size.width - 20.ff_widthTransform())/3
            let layoutHeight = layoutWidth*scale
            return CGSize(width: layoutWidth, height: layoutHeight)
        case false:
            let scale = ff_getHeightWidthScale(h: 106, w: 86)
            let layoutWidth = (collectionView.bounds.size.width - 15.ff_widthTransform())/4
            let layoutHeight = layoutWidth*scale
            return CGSize(width: layoutWidth, height: layoutHeight)
        }
    }
    
    // 向委托询问节的连续行或列之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 6.ff_heitghTransform()
    }


}


extension FF_CC {
    func ff_newestHeaderRefresh() {
        ff_initRefress()
//                    self.mj_header?.endRefreshing()
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
                FF_Link.ff_dacodeNewestJsonData(path: link){ [unowned self]pathArr,total in
                    self.vv_showImagePathArr = vv_showImagePathArr + pathArr
                    self.mj_footer?.endRefreshing()
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
