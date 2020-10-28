//
//  FF_MainView.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/26.
//

import UIKit
import Alamofire

protocol FF_ViewContro2Protocol {
    func ff_getImagePath(path: String, pathArr: [String])
    func ff_getImagePath(id: Int)
}


class FF_MainView: UICollectionView {
    
    //MARK: 配置url参数
    var vv_domain: String!
    var vv_pageParameter: Int!
    var vv_pageSize: Int!
    //MARK: 所有页的集合
    var vv_allPageArr: [Int] = []
    // MARK: 拉取的数据
//    var vv_link: String!
    // 装着所有页的集合，用于刷新顺序
    var vv_index: Int = 0
    // 一共有多少页
    var vv_pageTotal: Int!
    // id的集合
    var vv_idArray: [Int] = []
    // 名字集合
    var vv_naArray: [String] = []
    // 标题集合
    var vv_lbArray: [String] = []
    // cell上显示的图片path集合
    var vv_iamgePathArr: [String] = []
    var vv_coverPathArr: [String] = []
    //MARK: 指示是否宽屏显示
    var vv_isMinWidth: Bool = false
    // MARK: 指示是否为最后一个View
    var vv_isLastView: Bool = false
    var vv_delegate: FF_ViewContro2Protocol?
    var vv_frame: CGRect!

    override init(frame: CGRect,collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        ff_setAttribute()
//        ff_initRefress()
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
        register(FF_CVCellNewest.self, forCellWithReuseIdentifier: "itemIdNewest")
        register(FF_CVCellLast.self, forCellWithReuseIdentifier: "itemIdLast")
    }
    
    func ff_clearData() {
        vv_index = 0
        vv_pageTotal = nil 
        vv_allPageArr.removeAll()
        vv_iamgePathArr.removeAll()
        vv_coverPathArr.removeAll()
        vv_idArray.removeAll()
        vv_naArray.removeAll()
        vv_lbArray.removeAll()
    }

    func ff_initRefress(domain: String, pageSize: Int) {
        MBProgressHUD.hide(for: self, animated: true)
        MBProgressHUD.showAdded(to: self, animated: true)
        vv_domain = domain
        vv_pageSize = pageSize
        var pageParameter: Int
        var parameter: [String: Int]
        if vv_pageTotal == nil {
            pageParameter = 1
            parameter = [
                "page": pageParameter,
                "pageSize": pageSize
            ]
        }else {
            pageParameter = Int(arc4random_uniform(UInt32(vv_pageTotal!)))
            parameter = [
                "page": pageParameter,
                "pageSize": pageSize
            ]
        }
        vv_index = 0
        vv_allPageArr.removeAll()
        vv_iamgePathArr.removeAll()
        vv_coverPathArr.removeAll()
        vv_idArray.removeAll()
        vv_naArray.removeAll()
        vv_lbArray.removeAll()
        FF_Link.ff_dacodeImageCollectJsonData(domain: vv_domain, parameters: parameter){ [unowned self] imagePathArr, coverPathArr,total,idAY,naAY,lbAY     in
            self.vv_iamgePathArr = imagePathArr
            self.vv_lbArray = lbAY
            self.vv_naArray = naAY
            self.vv_coverPathArr = coverPathArr
            self.vv_idArray = idAY
            self.vv_pageTotal = total
            self.vv_allPageArr = FF_Link.ff_numberSort(end: vv_pageTotal)
            for dex in 0 ..< vv_allPageArr.count {
                if vv_allPageArr[dex] == pageParameter {
                    vv_allPageArr.remove(at: dex)
                    break
                }
            }
            MBProgressHUD.hide(for: self, animated: true)
            self.mj_header?.endRefreshing()
            self.mj_footer?.endRefreshing()
            self.reloadData()
        } failure: { [unowned self] in
            MBProgressHUD.hide(for: self, animated: true)
            self.mj_header?.endRefreshing()
            self.mj_footer?.endRefreshing()
            self.ff_setRefresh()
        }
    }
    
    func ff_setRefresh() {
        DispatchQueue.main.async { [unowned self] in
            let hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.show(animated: true)
            hud.mode = .text
            hud.label.text = "网络异常，请下拉刷新"
            hud.hide(animated: true, afterDelay: 2)
        }
    }

    
}

extension FF_MainView: UICollectionViewDataSource {
    // 返回分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 返回每个分区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if vv_isLastView {
            return vv_coverPathArr.count
        }else {
            return vv_iamgePathArr.count
        }
    }
    
    // 返回每个分区具体的数据载体item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if vv_isLastView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemIdLast", for: indexPath) as! FF_CVCellLast
            
            cell.ff_addInformation(imagePath: vv_coverPathArr[indexPath.row], lb1Text: vv_lbArray[indexPath.row], lb3Text: vv_naArray[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemIdNewest", for: indexPath) as! FF_CVCellNewest
            cell.ff_addInformation(imagePath: vv_iamgePathArr[indexPath.row])
            return cell
        }
    }
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vv_isLastView {
                vv_delegate?.ff_getImagePath(id: vv_idArray[indexPath.row])
        }else {
            vv_delegate?.ff_getImagePath(path: vv_iamgePathArr[indexPath.row], pathArr: vv_iamgePathArr)
        }
    }
}

extension FF_MainView: UICollectionViewDelegateFlowLayout {
    // 动态设置每个Item的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if vv_isLastView {
            let scale = ff_getHeightWidthScale(h: 91, w: 271)
            let layoutWidth = (collectionView.bounds.size.width)
            let layoutHeight = layoutWidth*scale
            return CGSize(width: layoutWidth, height: layoutHeight)
        }else {
            let scale = ff_getHeightWidthScale(h: 106, w: 86)
            if vv_isMinWidth {
                let layoutWidth = (collectionView.bounds.size.width - 15.ff_widthTransform())/4
                let layoutHeight = layoutWidth*scale
                return CGSize(width: layoutWidth, height: layoutHeight)
            }else {
                let layoutWidth = (collectionView.bounds.size.width - 10.ff_widthTransform())/3
                let layoutHeight = layoutWidth*scale
                return CGSize(width: layoutWidth, height: layoutHeight)
            }
        }
    }
    
    // 向委托询问节的连续行或列之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if vv_isLastView {
            return 8.ff_heitghTransform()
        }else {
            return 6.ff_heitghTransform()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.ff_widthTransform()
    }
    
    
}


extension FF_MainView {
    func ff_newestHeaderRefresh() {
        AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
            ff_initRefress(domain: vv_domain, pageSize: vv_pageSize)
        }
    }
    
    func ff_footerRefresh() {
        AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
            if vv_pageTotal == nil {
                ff_initRefress(domain: vv_domain, pageSize: vv_pageSize)
            }else {
                if vv_index > vv_allPageArr.count - 1 {
                    self.mj_footer!.endRefreshingWithNoMoreData()
                }else{
                    let page = vv_allPageArr[vv_index]
                    let parameters = [
                        "page": page,
                        "pageSize": vv_pageSize!
                    ]
                    vv_index = vv_index + 1
                    FF_Link.ff_dacodeImageCollectJsonData(domain: vv_domain, parameters: parameters){ [unowned self] imagePathArr, coverPathArr,total,idAY,naAY,lbAY  in
                        self.vv_iamgePathArr = vv_iamgePathArr + imagePathArr
                        self.vv_coverPathArr = coverPathArr + coverPathArr
                        self.vv_idArray = vv_idArray + idAY
                        self.vv_naArray = vv_naArray + naAY
                        self.vv_lbArray = vv_lbArray + lbAY
                        self.mj_footer?.endRefreshing()
                        self.reloadData()
                    } failure: {
                        self.mj_footer?.endRefreshing()
                        self.ff_setRefresh()
                    }
                }
            }
        }
    }
}


