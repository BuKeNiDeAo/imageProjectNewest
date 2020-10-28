//
//  FF_Like.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/14.
//

import UIKit
import MJRefresh

class FF_Preview: UIViewController, UICollectionViewDataSource {
    var vv_header: MJRefreshNormalHeader!
    var vv_footer: MJRefreshAutoNormalFooter!
    var vv_index: Int = 0
    var vv_imageImagePathArr: [String] = []
    var vv_showImagePathArr: [String] = []
    var vv_preview: UICollectionView!
    var vv_isLike: Bool = true
    var vv_domain: String!
    var vv_title: String!
    var vv_parameters: [String: Int]!
    var vv_idImage: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setNavi()
        ff_setAttribute()
        ff_addPreview()
        ff_addNewestViewMJ()
    }
    
    override func viewWillAppear(_ animated: Bool) {    //界面将要展现时调用的方法
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func ff_setNavi() {
        self.navigationController?.navigationBar.isHidden = false
        let barButton = UIBarButtonItem.init(image: UIImage(named: "icon-fanhui"), style: .done, target: self, action: #selector(ff_back))
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.init(name: "PingFang SC", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.init(name: "PingFang SC", size: 16) as Any]
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func ff_back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ff_transferAttribute(title: String, imageArr: [String], isLike: Bool, domain: String, parameters: [String: Int]) {
        vv_title = title
        vv_imageImagePathArr = imageArr
        vv_isLike = isLike
        vv_domain = domain
        vv_parameters = parameters
    }
        
    func ff_setAttribute() {
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        title = vv_title
        vv_header = MJRefreshNormalHeader()
        vv_footer = MJRefreshAutoNormalFooter()
        ff_setShowImagePathArr()
    }
    
    func ff_setShowImagePathArr() {
        let a = vv_index + 5
        for index in vv_index ... a {
            if index < vv_imageImagePathArr.count {
                vv_showImagePathArr.append(vv_imageImagePathArr[index])
                vv_index = vv_index + 1
            }else {
                break
            }
        }
    }
    
    func ff_addPreview() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = 86.ff_widthTransform()
        let scale = ff_getHeightWidthScale(h: 106, w: 86)
        let itemsSize = CGSize(width: itemWidth, height: itemWidth*scale)
        layout.itemSize = itemsSize
        layout.minimumLineSpacing = 0.ff_heitghTransform()
        layout.minimumInteritemSpacing = 0
        vv_preview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        vv_preview.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        self.view.addSubview(vv_preview)
        vv_preview.snp.makeConstraints { (make) in
            make.top.equalTo(50.ff_heitghTransform())
            make.height.equalTo(200)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        //设置代理与数据源
        vv_preview.delegate = self
        vv_preview.dataSource = self
        //注册数据载体类
//        vv_preview.register(NSClassFromString("UICollectionViewCell"), forCellWithReuseIdentifier: "itemId")
        vv_preview.register(FF_CVCellNewest.self, forCellWithReuseIdentifier: "itemIdNewest")

    }
    
    func ff_addNewestViewMJ() {
        vv_header.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh))
        vv_preview.mj_header = vv_header
        vv_footer.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh))
        vv_preview.mj_footer = vv_footer
    }
    
    func ff_getDickImagePathArr() -> [String] {
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        let iamgePathArr = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
        return iamgePathArr
    }
    
    func ff_loadNetwodrImagePath() {
        FF_Link.ff_dacodeImageCollectJsonData(domain: vv_domain, parameters: vv_parameters) { [self] iamgePathArr,a,b,c,d,e in
            vv_imageImagePathArr = iamgePathArr
            ff_setShowImagePathArr()
            vv_preview.reloadData()
            vv_preview.mj_header!.endRefreshing()
        } failure: {
            DispatchQueue.main.async { [unowned self] in
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.show(animated: true)
                hud.mode = .text
                hud.label.text = "网络异常，请下拉刷新"
                hud.hide(animated: true, afterDelay: 2)
            }
        }
    }
    
    @objc func ff_newestHeaderRefresh() {
        vv_imageImagePathArr.removeAll()
        vv_showImagePathArr.removeAll()
        vv_index = 0
        if vv_isLike {
            vv_imageImagePathArr = ff_getDickImagePathArr()
            ff_setShowImagePathArr()
            vv_preview.reloadData()
            vv_preview.mj_header!.endRefreshing()
        }else {
            ff_loadNetwodrImagePath()
        }
    }
    
    @objc func ff_footerRefresh() {
        if vv_index >= vv_imageImagePathArr.count {
            vv_preview.mj_footer?.endRefreshingWithNoMoreData()
        }else {
            ff_setShowImagePathArr()
            vv_preview.reloadData()
            vv_preview.mj_footer?.endRefreshing()
        }
    }

    deinit {
        print("deinit")
    }


}


extension FF_Preview: UICollectionViewDelegate {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemIdNewest", for: indexPath) as! FF_CVCellNewest
        cell.ff_addInformation(imagePath: vv_showImagePathArr[indexPath.row])
        return cell
    }
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let CatImage = FF_CatImage()
        CatImage.vv_iamgeKey = vv_showImagePathArr[indexPath.row]
        CatImage.vv_allLikeImagePath = vv_showImagePathArr
        self.navigationController?.pushViewController(CatImage, animated: true)
    }
    
}

extension FF_Preview: UICollectionViewDelegateFlowLayout {
    // 动态设置每个Item的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scale = ff_getHeightWidthScale(h: 106, w: 86)
        let layoutWidth = (collectionView.bounds.size.width - 20.ff_widthTransform())/3
        let layoutHeight = layoutWidth*scale
        let colletionTop = collectionView.frame.minY
        let residueHeight = view.frame.height - colletionTop - 20.ff_heitghTransform()
        var colletionHeight: CGFloat = 0
        for spasing in 0...10 {
            let itemHeightToal = layoutHeight * CGFloat(spasing)
            let gapToal = CGFloat((spasing-1)) * 6.ff_heitghTransform()
            let a = itemHeightToal + gapToal
            if a < residueHeight {
                colletionHeight = itemHeightToal + gapToal
            }else {break}
        }
        vv_preview.snp.updateConstraints { (up) in
            up.height.equalTo(colletionHeight)
        }
        return CGSize(width: layoutWidth, height: layoutHeight)
    }
    
    // 向委托询问节的连续行或列之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.ff_widthTransform()
    }

    // 向委托询问节的行或列中连续项之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.ff_heitghTransform()
    }

}
