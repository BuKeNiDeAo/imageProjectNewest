//
//  ViewController.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/9.
//

import UIKit
import SnapKit
import Kingfisher
import Foundation
import SVProgressHUD
import Reachability
import Alamofire
import MJRefresh

class ViewController: UIViewController {
    var vv_index = 0
    var vv_header0: MJRefreshNormalHeader!
    var vv_footer0: MJRefreshAutoNormalFooter!
    var vv_header1: MJRefreshNormalHeader!
    var vv_footer1: MJRefreshAutoNormalFooter!
    var vv_header2: MJRefreshNormalHeader!
    var vv_footer2: MJRefreshAutoNormalFooter!
    var vv_header3: MJRefreshNormalHeader!
    var vv_footer3: MJRefreshAutoNormalFooter!
    
    var vv_isNetworkStatus:Bool = true
    let vv_reachability = try! Reachability()
    
    var vv_noNetworlView: UIImageView!
    var vv_mainView: UIScrollView!
    var vv_leftBar: UIView!
    var vv_showBtn: UIButton!
    var vv_isLatent: Bool = false{
        didSet {
            vv_leftBar.isHidden = vv_isLatent
            vv_showBtn.isHidden = !vv_isLatent
                    }
    }
    var vv_newestImageLink = "https://api.hulktech.cn/image/getLatestUpdateDmList?page=1&pageSize=10"
    var vv_wallImageLink = "https://api.hulktech.cn/image/getLatestUpdateDmList?page=1&pageSize=10"
    var vv_faceImageLink = "https://api.hulktech.cn/image/getLatestUpdateDmList?page=1&pageSize=10"
    var vv_imageCollecImageLink = "https://api.hulktech.cn/image/getLatestUpdateDmList?page=1&pageSize=10"
    var vv_newestLb, vv_allRanked: UILabel!
    var vv_newestImageVeiw: UIButton!
    var vv_newestImageVeiwPath = "https://sjbz-fd.zol-img.com.cn/t_s1080x1920c5/g5/M00/0F/0F/ChMkJlfJSyWIPQEjAAX0y3KO2q8AAU89AJeLD0ABfTj756.jpg"

    let cache = ImageCache.default

    var vv_imageDocumentsPath: String!
    
    var vv_newestView, vv_wallPaperVeiw, vv_faceView, vv_imageCollecView: UICollectionView!
    var vv_newestViewUpdateBtn, vv_wallPaperVeiwUpdateBtn, vv_faceViewUpdateBtn, vv_imageCollecViewUpdateBtn: UIButton!
    var vv_newestViewNoNetImV, vv_wallPaperVeiwNoNetImV, vv_faceViewNoNetImV, vv_imageCollecViewNoNetImV: UIImageView!
    var vv_newestViewNoLoadCator, vv_wallPaperVeiwNoLoadCator, vv_faceViewNoLoadCator, vv_imageCollecViewNoLoadCator: UIActivityIndicatorView!
    // MARK: 四个预览View的数据源
    var vv_newestViewDataSourceArray: [FF_JsonList]?
    var vv_wallPaperVeiwDataSourceArray: [FF_JsonList]?
    var vv_faceViewDataSourceArray: [FF_JsonList]?
    var vv_imageCollecViewDataSourceArray: [FF_JsonList]?
    
    var vv_newestViewAllImagePath: [String] = []
    var vv_wallPaperVeiwAllImagePath: [String] = []
    var vv_faceViewAllImagePath: [String] = []
    var vv_imageCollecViewAllImagePath: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setAttribute()
        setNavibarimage()
        ff_initLeftBar()
        ff_addNewestLb()
        ff_addNewstImageView()
        ff_addAllRanked()
        ff_addMainView()
        ff_addNewestViewMJ()
        ff_addFaceViewMJ()
        ff_addWallViewMJ()
        ff_addFaceViewMJ()
        ff_addImageCollecViewMJ()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {    //界面将要展现时调用的方法
        super.viewWillAppear(animated)
        ff_monitorNetworkStatus()
        ff_creatSaveImagePathDocument()
        self.navigationController?.navigationBar.isHidden = true
        vv_mainView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func ff_setAttribute() {
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        vv_header0 = MJRefreshNormalHeader()
        vv_footer0 = MJRefreshAutoNormalFooter()
        vv_header1 = MJRefreshNormalHeader()
        vv_footer1 = MJRefreshAutoNormalFooter()
        vv_header2 = MJRefreshNormalHeader()
        vv_footer2 = MJRefreshAutoNormalFooter()
        vv_header3 = MJRefreshNormalHeader()
        vv_footer3 = MJRefreshAutoNormalFooter()
    }

    
// MARK:- 设置导航栏
    func setNavibarimage(){
        let barColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        let gradientLayer = CAGradientLayer()
        var frame = self.navigationController?.navigationBar.bounds
        frame!.size.height +=   UIApplication.shared.statusBarFrame.height
        gradientLayer.bounds = frame!
        gradientLayer.startPoint = CGPoint(x:0.5,y:0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [barColor.cgColor, barColor.cgColor]
        gradientLayer.locations = [0, 1]
        UIGraphicsBeginImageContext(gradientLayer.frame.size) //创建一个图形上下文
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)//返回当前图形上下文,相当于一个实例
        let ff_img = UIGraphicsGetImageFromCurrentImageContext()//得到一个代表绘制内容的UIImage对象
        UIGraphicsEndImageContext()
        self.navigationController?.navigationBar.setBackgroundImage(ff_img, for: .default)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.edgesForExtendedLayout = UIRectEdge()
    }

    
// MARK: - 左侧栏界面及功能实现方法,以模型的宽与屏幕的宽为标准比例
    func ff_initLeftBar() {
        vv_leftBar = UIView()
//        vv_leftBar.alpha = 1
        vv_leftBar.layer.borderWidth = 2
        vv_leftBar.layer.borderColor = UIColor.black.cgColor
        vv_leftBar.layer.cornerRadius = 18
        vv_leftBar.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMaxXMinYCorner.rawValue | CACornerMask.layerMaxXMaxYCorner.rawValue)
        vv_leftBar.clipsToBounds = true
        vv_leftBar.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        view.addSubview(vv_leftBar)
        vv_leftBar.snp.makeConstraints { (make) in
            make.top.equalTo(-1)
            make.bottom.equalTo(1)
            make.left.equalTo(-1)
            make.width.equalTo(82.ff_widthTransform())
        }
        ff_initLikeBtn(superView: vv_leftBar)
        ff_initClassBtn(superView: vv_leftBar, tag: 1, imageName: "icon-zuixin", y: 238)
        ff_initClassBtn(superView: vv_leftBar, tag: 2, imageName: "icon-bizhi", y: 360)
        ff_initClassBtn(superView: vv_leftBar, tag: 3, imageName: "icon-biaoqing", y: 482)
        ff_initClassBtn(superView: vv_leftBar, tag: 4, imageName: "icon-tuji", y: 604)
        ff_initHideLeftBarBtn(superView: vv_leftBar)
    }
    
    func ff_initLikeBtn(superView: UIView) {
        let likeBtn = UIButton()
        likeBtn.tag = 0
        likeBtn.setImage(UIImage(named: "icon-xihuang"), for: .normal)
        superView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.right.equalTo(-11)
            make.centerY.equalTo(ff_getCenterY(y: 64, heifgh: 60))
            make.height.equalTo(likeBtn.snp.width).multipliedBy(ff_getWidthHeitghScale(w: 1, h: 1))
        }
        likeBtn.addTarget(self, action: #selector(ff_leftBarTrigger(btn:)), for: .touchUpInside)
    }
    
    func ff_initClassBtn(superView: UIView,tag: Int,imageName: String, y: CGFloat) {
        let classBtn = UIButton()
        classBtn.setImage(UIImage(named: imageName), for: .normal)
        classBtn.tag = tag
        superView.addSubview(classBtn)
        classBtn.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.right.equalTo(-11)
            make.centerY.equalTo(ff_getCenterY(y: y, heifgh: 94))
            make.height.equalTo(classBtn.snp.width).multipliedBy(1/ff_getWidthHeitghScale(w: 60, h: 94))
        }
        classBtn.addTarget(self, action: #selector(ff_leftBarTrigger(btn:)), for: .touchUpInside)
    }
    
    func ff_initHideLeftBarBtn(superView: UIView) {
        let hideBtn = UIButton()
        hideBtn.tag = 5
        hideBtn.setImage(UIImage(named: "icon-cbl"), for: .normal)
        superView.addSubview(hideBtn)
        hideBtn.snp.makeConstraints { (make) in
            make.left.equalTo(27)
            make.right.equalTo(-27)
            make.centerY.equalTo(ff_getCenterY(y: 730, heifgh: 28))
            make.height.equalTo(hideBtn.snp.width).multipliedBy(ff_getWidthHeitghScale(w: 1, h: 1))
        }
        hideBtn.addTarget(self, action: #selector(ff_leftBarTrigger(btn:)), for: .touchUpInside)
        
        vv_showBtn = UIButton()
        vv_showBtn.isHidden = true
        vv_showBtn.tag = 5
        vv_showBtn.setImage(UIImage(named: "icon-cbl-1"), for: .normal)
        view.addSubview(vv_showBtn)
        vv_showBtn.snp.makeConstraints { (make) in
            make.left.equalTo(hideBtn)
            make.right.equalTo(hideBtn)
            make.centerY.equalTo(hideBtn)
            make.height.equalTo(hideBtn)
        }
        vv_showBtn.addTarget(self, action: #selector(ff_leftBarTrigger(btn:)), for: .touchUpInside)
    }
    
    @objc func ff_leftBarTrigger(btn: UIButton) {
        switch btn.tag {
        case 0:
            let like = FF_Like()
            self.navigationController?.pushViewController(like, animated: true)
        case 1:
                vv_mainView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        case 2:
                vv_mainView.setContentOffset(CGPoint(x: 0, y: vv_mainView.frame.height*1), animated: true)
        case 3:
                vv_mainView.setContentOffset(CGPoint(x: 0, y: vv_mainView.frame.height*2), animated: true)
        case 4:
                vv_mainView.setContentOffset(CGPoint(x: 0, y: vv_mainView.frame.height*3), animated: true)
        case 5:
            vv_isLatent = !vv_isLatent
        default:
            print("6")
        }
    }
// MARK: -------------------------------------------------------------------------------------
   
    
// MARK: - 布局主界面
    func ff_addNewestLb() {
        vv_newestLb = UILabel()
        ff_initLb(lb: vv_newestLb, title: "最新推荐", y: 54, width: 72, height:  25)
    }
    /// 初始化主界面两个标题
    func ff_initLb(lb:UILabel, title: String, y: CGFloat, width: CGFloat, height: CGFloat) {
        lb.text = title
        lb.textAlignment = .center
        lb.font = UIFont.init(name: "PingFang SC", size: 18)
        self.view.addSubview(lb)
        lb.snp.makeConstraints { (make) in
            let a = ff_getCenterY(y: y, heifgh: height)
            make.left.equalTo(95.ff_widthTransform())
            make.centerY.equalTo(a)
            make.size.equalTo(CGSize(width: width, height: 25))
        }
        
        let adronView = UIView()
        adronView.backgroundColor = UIColor.init(red: 1, green: 0.84, blue: 0.56, alpha: 1)
        view.addSubview(adronView)
        adronView.snp.makeConstraints { (make) in
            make.left.equalTo(lb.snp.left)
            make.width.equalTo(lb.snp.width)
            make.top.equalTo(lb.snp.top).offset(18)
            make.bottom.equalTo(lb.snp.bottom).offset(-3)
        }
        
        self.view.insertSubview(adronView, belowSubview: lb)
    }
    
    /// 添加最新推荐到主view上
    func ff_addNewstImageView() {
        vv_newestImageVeiw = UIButton()
        vv_newestImageVeiw.clipsToBounds = true
        vv_newestImageVeiw.layer.cornerRadius = 18
        vv_newestImageVeiw.backgroundColor = .red
        view.addSubview(vv_newestImageVeiw)
        vv_newestImageVeiw.snp.makeConstraints { (make) in
            let scale = ff_getHeightWidthScale(h: 151, w: 268)
            make.top.equalTo(vv_newestLb.snp.bottom).offset(11.ff_heitghTransform())
            make.left.equalTo(vv_newestLb.snp.left)
            make.right.equalTo(-12.ff_widthTransform())
            make.height.equalTo(vv_newestImageVeiw.snp.width).multipliedBy(scale)
        }
        let url = URL(string:vv_newestImageVeiwPath)
        vv_newestImageVeiw.kf.setImage(with: url, for: .normal)
        vv_newestImageVeiw.addTarget(self, action: #selector(ff_openNewestImageView), for: .touchUpInside)
    }
    
    @objc func ff_openNewestImageView(bt:UIButton) {
        let catimage = FF_CatNewestImage()
        catimage.vv_iamgeKey = vv_newestImageVeiwPath
        self.modalPresentationStyle = .fullScreen
        catimage.modalPresentationStyle = .fullScreen
        present(catimage, animated: true, completion: nil)
    }
    
    func ff_addAllRanked() {
        vv_allRanked = UILabel()
        vv_allRanked.text = "总榜"
        vv_allRanked.textAlignment = .center
        vv_allRanked.font = UIFont.init(name: "PingFang SC", size: 18)
        self.view.addSubview(vv_allRanked)
        vv_allRanked.snp.makeConstraints { (make) in
            make.top.equalTo(vv_newestImageVeiw.snp.bottom).offset(29.ff_heitghTransform())
            make.left.equalTo(95.ff_widthTransform())
            make.size.equalTo(CGSize(width: 36, height: 25))
        }
        
        let adronView = UIView()
        adronView.backgroundColor = UIColor.init(red: 1, green: 0.84, blue: 0.56, alpha: 1)
        view.addSubview(adronView)
        adronView.snp.makeConstraints { (make) in
            make.left.equalTo(vv_allRanked.snp.left)
            make.width.equalTo(vv_allRanked.snp.width)
            make.top.equalTo(vv_allRanked.snp.top).offset(18)
            make.bottom.equalTo(vv_allRanked.snp.bottom).offset(-3)
        }
        self.view.insertSubview(adronView, belowSubview: vv_allRanked)
    }
    
    // MARK: -布局mainView
    func ff_addMainView() {
        vv_mainView = UIScrollView()
        vv_mainView.backgroundColor = .clear
        vv_mainView.alwaysBounceVertical = false
        vv_mainView.isScrollEnabled = false

        view.addSubview(vv_mainView)
        vv_mainView.snp.makeConstraints { (make) in
            make.top.equalTo(vv_allRanked.snp.bottom).offset(12.ff_heitghTransform())
            make.bottom.equalTo(-18)
            make.leading.equalTo(vv_newestImageVeiw.snp.leading)
            make.trailing.equalTo(vv_newestImageVeiw.snp.trailing)
        }
        vv_mainView.layoutIfNeeded()
        vv_mainView.contentSize = CGSize(width: vv_mainView.frame.size.width, height: vv_mainView.frame.size.height*4)
        vv_mainView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        ff_addPreviewUpMainView(tag: 0)
        ff_addPreviewUpMainView(tag: 1)
        ff_addPreviewUpMainView(tag: 2)
        ff_addPreviewUpMainView(tag: 3)
    }
    
    func addNoNetworkView() {
        vv_noNetworlView = UIImageView()
        vv_noNetworlView.image = UIImage(named: "icon-noNetwork")
        view.addSubview(vv_noNetworlView)
        vv_noNetworlView.snp.makeConstraints { (make) in
            make.edges.equalTo(vv_mainView.snp.edges)
        }

    }
    
    // MARK: 布局colletionView
    func ff_addPreviewUpMainView(tag: Int) {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = 86.ff_widthTransform()
        let scale = ff_getHeightWidthScale(h: 106, w: 86)
        let itemsSize = CGSize(width: itemWidth, height: itemWidth*scale)
        layout.itemSize = itemsSize
        layout.minimumLineSpacing = 0.ff_heitghTransform()
        layout.minimumInteritemSpacing = 0
        switch tag {
        case 0:
            let rect = ff_calculateColleectionViewFrame(tag: 0)
            vv_newestView = UICollectionView(frame: rect, collectionViewLayout: layout)
            vv_newestView.backgroundColor = .clear
            ff_setPreview(preview: vv_newestView, referenceView: vv_mainView, tag: tag)
            vv_newestViewNoLoadCator = UIActivityIndicatorView.init(style: .large)
            ff_setNoloadCator(catorView: vv_newestViewNoLoadCator, tag: tag, catorViewCenter: vv_newestView)
            vv_newestViewUpdateBtn = UIButton()
            ff_setNoLoadBtn(imageView: vv_newestViewUpdateBtn, rect: rect, tag: 0)
            vv_newestViewNoNetImV = UIImageView()
            ff_addNoNetworkView(noNetworkView: vv_newestViewNoNetImV, rect: rect, isHid: vv_isNetworkStatus)
        case 1:
            let rect = ff_calculateColleectionViewFrame(tag: 1)
            vv_wallPaperVeiw = UICollectionView(frame: rect, collectionViewLayout: layout)
            vv_wallPaperVeiw.backgroundColor = .clear
            ff_setPreview(preview: vv_wallPaperVeiw, referenceView: vv_mainView, tag: tag)
            vv_wallPaperVeiwNoLoadCator = UIActivityIndicatorView.init(style: .large)
            ff_setNoloadCator(catorView: vv_wallPaperVeiwNoLoadCator, tag: tag, catorViewCenter: vv_wallPaperVeiw)
            vv_wallPaperVeiwUpdateBtn = UIButton()
            ff_setNoLoadBtn(imageView: vv_wallPaperVeiwUpdateBtn, rect: rect, tag: 1)
            vv_wallPaperVeiwNoNetImV = UIImageView()
            ff_addNoNetworkView(noNetworkView: vv_wallPaperVeiwNoNetImV, rect: rect, isHid: vv_isNetworkStatus)
        case 2:
            let rect = ff_calculateColleectionViewFrame(tag: 2)
            vv_faceView = UICollectionView(frame: rect, collectionViewLayout: layout)
            vv_faceView.backgroundColor = .clear
            ff_setPreview(preview: vv_faceView, referenceView: vv_mainView, tag: tag)
            vv_faceViewNoLoadCator = UIActivityIndicatorView.init(style: .large)
            ff_setNoloadCator(catorView: vv_faceViewNoLoadCator, tag: tag, catorViewCenter: vv_faceView)
            vv_faceViewUpdateBtn = UIButton()
            ff_setNoLoadBtn(imageView: vv_faceViewUpdateBtn, rect: rect, tag: 2)
            vv_faceViewNoNetImV = UIImageView()
            ff_addNoNetworkView(noNetworkView: vv_faceViewNoNetImV, rect: rect, isHid: vv_isNetworkStatus)
        case 3:
            let rect = CGRect(x: 0, y: vv_mainView.frame.height*CGFloat(tag), width: vv_mainView.frame.width, height: vv_mainView.frame.height)
            vv_imageCollecView = UICollectionView(frame: rect, collectionViewLayout: layout)
            vv_imageCollecView.backgroundColor = .clear
            ff_setPreview(preview: vv_imageCollecView, referenceView: vv_mainView, tag: tag)
            vv_imageCollecViewNoLoadCator = UIActivityIndicatorView.init(style: .large)
            ff_setNoloadCator(catorView: vv_imageCollecViewNoLoadCator, tag: tag, catorViewCenter: vv_imageCollecView)
            vv_imageCollecViewUpdateBtn = UIButton()
            ff_setNoLoadBtn(imageView: vv_imageCollecViewUpdateBtn, rect: rect, tag: 3)
            vv_imageCollecViewNoNetImV = UIImageView()
            ff_addNoNetworkView(noNetworkView: vv_imageCollecViewNoNetImV, rect: rect, isHid: vv_isNetworkStatus)
        default:
            break
        }
    }
    
    // MARK: - 初始化图片预览view
    func ff_calculateColleectionViewFrame(tag: Int) -> CGRect {
        let collectionViewHeight = ff_calculateCollecHeight(collectionView: vv_mainView)
        let rect = CGRect(x: 0, y: vv_mainView.frame.height*CGFloat(tag), width: vv_mainView.frame.width, height: collectionViewHeight)
        return rect
    }
    
    func ff_setPreview(preview: UICollectionView, referenceView: UIScrollView, tag: Int) {
        preview.tag = tag
        vv_mainView.addSubview(preview)
        preview.layoutIfNeeded()
        preview.delegate = self
        preview.dataSource = self
        preview.register(NSClassFromString("UICollectionViewCell"), forCellWithReuseIdentifier: "itemId")
    }
    
    
    /// 计算前面三个collectionviewa的高度方法
    func ff_calculateCollecHeight(collectionView: UIView) -> CGFloat {
        let scale = ff_getHeightWidthScale(h: 106, w: 86)
        let layoutWidth = (collectionView.bounds.size.width - 10.ff_widthTransform())/3
        let layoutHeight = layoutWidth*scale
        let colletMaxHeight = vv_mainView.frame.height - 20.ff_heitghTransform()
        var colletionHeight: CGFloat = 0
        for spasing in 0...5 {
            let itemHeightToal = layoutHeight * CGFloat(spasing)
            let gapToal = CGFloat((spasing-1)) * 6.ff_heitghTransform()
            let a = itemHeightToal + gapToal
            if a < colletMaxHeight {
                colletionHeight = itemHeightToal + gapToal
                
            }else {break}
        }
        return colletionHeight
    }
    
    /// 计算图集view的高度
    func ff_calculateImageCollecViewHeight(collectionView: UIView) -> CGFloat {
        let scale = ff_getHeightWidthScale(h: 91, w: 271)
        let layoutWidth = collectionView.bounds.size.width
        let layoutHeight = layoutWidth*scale
        let colletMaxHeight = vv_mainView.frame.height
        var colletionHeight: CGFloat = 0
        for spasing in 0...10 {
            let itemHeightToal = layoutHeight * CGFloat(spasing)
            let gapToal = CGFloat((spasing-1)) * 8.ff_heitghTransform()
            let a = itemHeightToal + gapToal
            if a < colletMaxHeight {
                colletionHeight = itemHeightToal + gapToal
            }else {break}
        }
        return colletionHeight
    }
    
    func ff_setNoLoadBtn(imageView: UIButton, rect: CGRect, tag: Int) {
        imageView.frame = rect
        imageView.tag = tag
        imageView.setImage(UIImage(named: "icon-jiazai"), for: .normal)
        imageView.isHidden = true
        imageView.addTarget(self, action: #selector(ff_updade), for: .touchUpInside)
        vv_mainView.addSubview(imageView)
    }
    
    @objc func ff_updade(bt: UIButton) {
        if vv_isNetworkStatus == false{
            DispatchQueue.main.async { [self] in
                let hud = MBProgressHUD.showAdded(to: vv_mainView ?? view, animated: true)
                hud.mode = .text
                hud.label.text = "没有网络"
                hud.hide(animated: true, afterDelay: 8)
            }
            return
        }
        switch bt.tag {
        case 0:
//            ff_dacodeNewestJsonData(path: vv_newestImageLink)
            ff_loadNewestImagePath()
        case 1:
//            ff_dacodeWallJsonData(path: vv_wallImageLink)
            ff_loadWallImagePath()
        case 2:
//            ff_dacodeFaceJsonData(path: vv_faceImageLink)
            ff_loadFaceImagePath()
        case 3:
//            ff_dacodeImagecollecJsonData(path: vv_imageCollecImageLink)
            ff_loadImageCollecImagePath()
        default:
            break
        }
    }
    
    func ff_setNoloadCator(catorView: UIActivityIndicatorView, tag: Int, catorViewCenter: UICollectionView) {
        catorView.center = CGPoint(x: catorViewCenter.frame.width/2, y: vv_mainView.frame.height*CGFloat(tag) + catorViewCenter.frame.height/2)
        catorView.startAnimating()
        vv_mainView.addSubview(catorView)
    }
    
    func ff_addNoNetworkView(noNetworkView: UIImageView, rect: CGRect, isHid: Bool) {
        noNetworkView.frame = rect
        noNetworkView.isHidden = true
        noNetworkView.image = UIImage(named: "icon-noNetwork")
        vv_mainView.addSubview(noNetworkView)
    }

    
}

extension ViewController: UICollectionViewDataSource {
    // 返回分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 返回每个分区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch collectionView.tag {
            case 0:
                if vv_newestViewDataSourceArray != nil {
                    for index in 0..<vv_newestViewDataSourceArray!.count{
                        vv_newestViewAllImagePath.append(vv_newestViewDataSourceArray![index].image_source_url)
                    }
                }
                return vv_newestViewDataSourceArray?.count ?? 0
            case 1:
                if vv_wallPaperVeiwDataSourceArray != nil {
                    for index in 0..<vv_wallPaperVeiwDataSourceArray!.count{
                        vv_wallPaperVeiwAllImagePath.append(vv_wallPaperVeiwDataSourceArray![index].image_source_url)
                    }
                }
                return vv_wallPaperVeiwDataSourceArray?.count ?? 0
            case 2:
                if vv_faceViewDataSourceArray != nil {
                    for index in 0..<vv_faceViewDataSourceArray!.count{
                        vv_faceViewAllImagePath.append(vv_faceViewDataSourceArray![index].image_source_url)
                    }
                }
                return vv_faceViewDataSourceArray?.count ?? 0
            case 3:
                if vv_imageCollecViewDataSourceArray != nil {
                    for index in 0..<vv_imageCollecViewDataSourceArray!.count{
                        vv_imageCollecViewAllImagePath.append(vv_imageCollecViewDataSourceArray![index].image_source_url)
                    }
                }
                return vv_imageCollecViewDataSourceArray?.count ?? 0
            default:
                return 0
        }
    }
    
    // 返回每个分区具体的数据载体item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 3{
            let cell = ff_setImageColletViewCell(collectionView: collectionView, indexPath: indexPath)
            return cell
        }else{
            let cell = ff_setPriviewViewCell(collectionView: collectionView, indexPath: indexPath)
            return cell
        }
    }
    
    /// 设置前面三个预览viewCell视图
    func ff_setPriviewViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        let cellImageView = UIImageView()
        cellImageView.frame = cell.bounds
        var imageURL: URL?
        switch collectionView.tag {
        case 0:
            imageURL = URL(string: vv_newestViewDataSourceArray![indexPath.row].image_source_url)
        case 1:
            imageURL = URL(string: vv_wallPaperVeiwDataSourceArray![indexPath.row].image_source_url)
        case 2:
            imageURL = URL(string: vv_faceViewDataSourceArray![indexPath.row].image_source_url)
        default:
            imageURL = URL(string: "")
        }
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "icon-jiazai"))
        cell.addSubview(cellImageView)
        return cell
    }
    
    func ff_setImageColletViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .white
        let cellImageView = UIImageView()
        cellImageView.clipsToBounds = true
        cellImageView.layer.cornerRadius = 6
        cell.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { (make) in
            let scale = ff_getWidthHeitghScale(w: 98, h: 75)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.left.equalTo(8)
            make.width.equalTo(cellImageView.snp.height).multipliedBy(scale)
        }
        let imageURL = URL(string: vv_imageCollecViewDataSourceArray![indexPath.row].image_source_url)
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "icon-jiazai"))

        let lable1 = UILabel()
        lable1.text = "「图集」漫画图集"
        lable1.font = UIFont.init(name: "PingFang SC", size: 12)
        lable1.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        lable1.textAlignment = .right
        lable1.adjustsFontSizeToFitWidth = true
        cell.addSubview(lable1)
        lable1.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.height.equalTo(12)
            make.right.equalTo(-11)
            make.left.equalTo(20)
        }
        
        let lable2 = UILabel()
        lable2.text = "进去看看"
        lable2.textAlignment = .center
        lable2.font = UIFont.init(name: "PingFang SC", size: 13)
        lable2.textColor = UIColor(red: 1, green: 0.78, blue: 0.39, alpha: 1)
        lable2.backgroundColor = UIColor(red: 0.39, green: 0.17, blue: 0.97, alpha: 1)
        lable2.layer.cornerRadius = 15
        lable2.clipsToBounds = true
        cell.addSubview(lable2)
        lable2.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(cellImageView.snp.right).offset(10)
            make.width.equalTo(62)
            make.height.equalTo(26)
        }
//        
        let lable3 = UILabel()
        lable3.text = "漫画大合集(第一弹)"
        lable3.font = UIFont.init(name: "PingFang SC", size: 14)
        lable3.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell.addSubview(lable3)
        lable3.snp.makeConstraints { (make) in
            make.left.equalTo(cellImageView.snp.right).offset(10)
            make.right.equalTo(0)
            make.top.equalTo(25)
            make.height.equalTo(20)
        }
        return cell
    }
    
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        cache.retrieveImage(forKey: indexPath.row.description) { [self] result in
//            switch result {
//            case .success(let value):
//                print(value.cacheType)
//                print(value.image as Any)
//                let catImage = FF_CatImage()
//                if self.vv_newestViewDataSourceArray![indexPath.row].image_source_url != "" {
//                    catImage.vv_iamgeKey = self.vv_newestViewDataSourceArray![indexPath.row].image_source_url
////                    catImage.vv_iamgeKey = self.vv_allImagePath[indexPath.row]
//
//                    catImage.vv_allColletionImagePath = vv_newestViewAllImagePath
//                }
//                self.modalPresentationStyle = .fullScreen
//                catImage.modalPresentationStyle = .fullScreen
//                self.present(catImage, animated: true)
//            case .failure(let error):
//                print(error)
//            }
//        }
        let catImage = FF_CatImage()
        switch collectionView.tag {
        case 0:
            if self.vv_newestViewDataSourceArray![indexPath.row].image_source_url != "" {
                catImage.vv_iamgeKey = self.vv_newestViewDataSourceArray![indexPath.row].image_source_url
//                    catImage.vv_iamgeKey = self.vv_allImagePath[indexPath.row]
                catImage.vv_allColletionImagePath = vv_newestViewAllImagePath
            }
        case 1:
            if self.vv_wallPaperVeiwDataSourceArray![indexPath.row].image_source_url != "" {
                catImage.vv_iamgeKey = self.vv_wallPaperVeiwDataSourceArray![indexPath.row].image_source_url
//                    catImage.vv_iamgeKey = self.vv_allImagePath[indexPath.row]
                catImage.vv_allColletionImagePath = vv_wallPaperVeiwAllImagePath
            }
        case 2:
            if self.vv_faceViewDataSourceArray![indexPath.row].image_source_url != "" {
                catImage.vv_iamgeKey = self.vv_faceViewDataSourceArray![indexPath.row].image_source_url
//                    catImage.vv_iamgeKey = self.vv_allImagePath[indexPath.row]
                catImage.vv_allColletionImagePath = vv_wallPaperVeiwAllImagePath
            }
        case 3:
            if self.vv_imageCollecViewDataSourceArray![indexPath.row].image_source_url != "" {
                catImage.vv_iamgeKey = self.vv_imageCollecViewDataSourceArray![indexPath.row].image_source_url
//                    catImage.vv_iamgeKey = self.vv_allImagePath[indexPath.row]
                catImage.vv_allColletionImagePath = vv_wallPaperVeiwAllImagePath
            }
        default:
            break
        }
        self.modalPresentationStyle = .fullScreen
        catImage.modalPresentationStyle = .fullScreen
        self.present(catImage, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // 动态设置每个Item的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 3{
            let size = ff_setImageCollectionViewLayout(collectionView: collectionView)
            return size
        }else{
            let size = ff_setCollctionViewLayout(collectionView: collectionView)
            return size
        }
    }
    
    /// 设置前面三个Layout
    func ff_setCollctionViewLayout(collectionView: UICollectionView) -> CGSize {
        let scale = ff_getHeightWidthScale(h: 106, w: 86)
        let layoutWidth = (collectionView.bounds.size.width - 10.ff_widthTransform())/3
        let layoutHeight = layoutWidth*scale
        return CGSize(width: layoutWidth, height: layoutHeight)
    }
    
    /// 设置图集Layout
    func ff_setImageCollectionViewLayout(collectionView: UICollectionView) -> CGSize {
        let scale = ff_getHeightWidthScale(h: 91, w: 271)
        let layoutWidth = (collectionView.bounds.size.width)
        let layoutHeight = layoutWidth*scale
        return CGSize(width: layoutWidth, height: layoutHeight)
    }

    // 向委托询问节的连续行或列之间的间距。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 3 {
            return 8.ff_heitghTransform()
        }else{
            return 6.ff_heitghTransform()
        }
    }


}
//  MARK: -----------------------------------------------

// MARK: - Json数据解析
extension ViewController {
    // MARK: 监听网络状态
    func ff_monitorNetworkStatus() {
        vv_reachability.whenReachable = { [self] reachability in
//            if reachability.connection == .wifi {
//                print("使用蜂窝网络")
//                ff_loadimagePath()
//            } else {
//                print("连接wifi")
//            }
            vv_isNetworkStatus = true
            vv_newestViewNoNetImV.isHidden = true
            vv_wallPaperVeiwNoNetImV.isHidden = true
            vv_faceViewNoNetImV.isHidden = true
            vv_imageCollecViewNoNetImV.isHidden = true
            ff_loadNewestImagePath()
            ff_loadWallImagePath()
            ff_loadFaceImagePath()
            ff_loadImageCollecImagePath()
        }
        
        vv_reachability.whenUnreachable = { [self] _ in
            print("没有网络")
            vv_isNetworkStatus = false
            vv_newestViewNoNetImV.isHidden = false
            vv_wallPaperVeiwNoNetImV.isHidden = false
            vv_faceViewNoNetImV.isHidden = false
            vv_imageCollecViewNoNetImV.isHidden = false
            
            vv_newestViewUpdateBtn.isHidden = false
            vv_wallPaperVeiwUpdateBtn.isHidden = false
            vv_faceViewUpdateBtn.isHidden = false
            vv_imageCollecViewUpdateBtn.isHidden = false
            vv_newestViewNoLoadCator.isHidden = false
            vv_wallPaperVeiwNoLoadCator.isHidden = false
            vv_faceViewNoLoadCator.isHidden = false
            vv_imageCollecViewNoLoadCator.isHidden = false
            DispatchQueue.main.async { [self] in
                let hud = MBProgressHUD.showAdded(to: vv_mainView ?? view, animated: true)
                hud.mode = .text
                hud.label.text = "没有网络"
                hud.hide(animated: true, afterDelay: 8)
            }
        }
        do {
            try vv_reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func ff_loadNewestImagePath() {
        if vv_newestViewDataSourceArray == nil {
            ff_dacodeNewestJsonData(path: vv_newestImageLink)
        }else{
            vv_newestViewNoLoadCator.isHidden = true
            vv_newestViewUpdateBtn.isHidden = true
            vv_newestView.reloadData()
        }
    }
    
    func ff_loadWallImagePath() {
        if vv_wallPaperVeiwDataSourceArray == nil {
            ff_dacodeWallJsonData(path: vv_wallImageLink)
        }else{
            vv_wallPaperVeiwNoLoadCator.isHidden = true
            vv_wallPaperVeiwUpdateBtn.isHidden = true
            vv_wallPaperVeiw.reloadData()
        }
    }
    
    func ff_loadFaceImagePath() {
        if vv_faceViewDataSourceArray == nil {
            ff_dacodeFaceJsonData(path: vv_faceImageLink)
        }else{
            vv_faceViewNoLoadCator.isHidden = true
            vv_faceViewUpdateBtn.isHidden = true
            vv_faceView.reloadData()
        }
    }
    
    func ff_loadImageCollecImagePath() {
        if vv_imageCollecViewDataSourceArray == nil{
            ff_dacodeImagecollecJsonData(path: vv_imageCollecImageLink)
        }else{
            vv_imageCollecViewNoLoadCator.isHidden = true
            vv_imageCollecViewUpdateBtn.isHidden = true
            vv_imageCollecView.reloadData()
        }
    }
    
    
    func ff_dacodeNewestJsonData(path: String) {
        vv_newestViewNoLoadCator.isHidden = false
        vv_newestViewUpdateBtn.isHidden = true
        let decoder = JSONDecoder()
        AF.request(path).validate().responseData { [self] (response) in
            if let data = response.data {
                let jsonResult = try? decoder.decode(FF_JsonResult.self, from: data)
                if vv_newestViewDataSourceArray != nil{
                    vv_newestViewDataSourceArray?.removeAll()
                }
                if let DSA = jsonResult?.data.list{
                    vv_newestViewDataSourceArray = DSA
                    vv_newestView.reloadData()
                    vv_newestViewNoLoadCator.isHidden = true
                }else{
                    vv_newestViewUpdateBtn.isHidden = false
                    vv_newestViewNoLoadCator.isHidden = true
                    vv_newestViewUpdateBtn.isHidden = false
                    vv_newestViewNoLoadCator.isHidden = true
                    DispatchQueue.main.async {
                        let hud = MBProgressHUD.showAdded(to: vv_newestView ?? vv_mainView ?? view, animated: true)
                        hud.mode = .text
                        hud.label.text = "网络异常，请下拉刷新"
                        hud.hide(animated: true, afterDelay: 8)
                    }
                }
            }else{
                vv_newestViewUpdateBtn.isHidden = false
                vv_newestViewNoLoadCator.isHidden = true
                DispatchQueue.main.async {
                    let hud = MBProgressHUD.showAdded(to: vv_newestView ?? vv_mainView ?? view, animated: true)
                    hud.mode = .text
                    hud.label.text = "网络异常，请下拉刷新"
                    hud.hide(animated: true, afterDelay: 8)
                }
            }
        }
    }
    
    func ff_dacodeWallJsonData(path: String) {
        vv_wallPaperVeiwNoLoadCator.isHidden = false
        vv_wallPaperVeiwUpdateBtn.isHidden = true
        let decoder = JSONDecoder()
        AF.request(path).validate().responseData { [self] (response) in
            if let data = response.data {
                let jsonResult = try? decoder.decode(FF_JsonResult.self, from: data)
                if vv_wallPaperVeiwDataSourceArray != nil{
                    vv_wallPaperVeiwDataSourceArray?.removeAll()
                }
                if let DSA = jsonResult?.data.list{
                    vv_wallPaperVeiwDataSourceArray = DSA
                    vv_wallPaperVeiw.reloadData()
                    vv_wallPaperVeiwNoLoadCator.isHidden = true
                }else{
                    vv_wallPaperVeiwUpdateBtn.isHidden = false
                    vv_wallPaperVeiwNoLoadCator.isHidden = true
                    DispatchQueue.main.async {
                        let hud = MBProgressHUD.showAdded(to: vv_wallPaperVeiw ?? vv_mainView ?? view, animated: true)
                        hud.mode = .text
                        hud.label.text = "网络异常，请点击刷新"
                        hud.hide(animated: true, afterDelay: 8)
                    }

                }
            }else{
                vv_wallPaperVeiwUpdateBtn.isHidden = false
                vv_wallPaperVeiwNoLoadCator.isHidden = true
                DispatchQueue.main.async {
                    let hud = MBProgressHUD.showAdded(to: vv_wallPaperVeiw ?? vv_mainView ?? view, animated: true)
                    hud.mode = .text
                    hud.label.text = "网络异常，请点击刷新"
                    hud.hide(animated: true, afterDelay: 8)
                }
            }
        }
    }

    func ff_dacodeFaceJsonData(path: String) {
        vv_faceViewNoLoadCator.isHidden = false
        vv_faceViewUpdateBtn.isHidden = true
        let decoder = JSONDecoder()
        AF.request(path).validate().responseData { [self] (response) in
            if let data = response.data {
                let jsonResult = try? decoder.decode(FF_JsonResult.self, from: data)
                if vv_faceViewDataSourceArray != nil{
                    vv_faceViewDataSourceArray?.removeAll()
                }
                if let DSA = jsonResult?.data.list{
                    vv_faceViewDataSourceArray = DSA
                    vv_faceView.reloadData()
                    vv_faceViewNoLoadCator.isHidden = true
                }else{
                    vv_faceViewUpdateBtn.isHidden = false
                    vv_faceViewNoLoadCator.isHidden = true
                    DispatchQueue.main.async {
                        let hud = MBProgressHUD.showAdded(to: vv_wallPaperVeiw ?? vv_mainView ?? view, animated: true)
                        hud.mode = .text
                        hud.label.text = "网络异常，请下拉刷新"
                        hud.hide(animated: true, afterDelay: 8)
                    }
                }
            }else{
                vv_faceViewUpdateBtn.isHidden = false
                vv_faceViewNoLoadCator.isHidden = true
                DispatchQueue.main.async {
                    let hud = MBProgressHUD.showAdded(to: vv_wallPaperVeiw ?? vv_mainView ?? view, animated: true)
                    hud.mode = .text
                    hud.label.text = "网络异常，请下拉刷新"
                    hud.hide(animated: true, afterDelay: 8)
                }
            }
        }
    }

    func ff_dacodeImagecollecJsonData(path: String) {
        vv_imageCollecViewNoLoadCator.isHidden = false
        vv_imageCollecViewUpdateBtn.isHidden = true
        let decoder = JSONDecoder()
        AF.request(path).validate().responseData { [self] (response) in
            if let data = response.data {
                let jsonResult = try? decoder.decode(FF_JsonResult.self, from: data)
                if vv_imageCollecViewDataSourceArray != nil{
                    vv_imageCollecViewDataSourceArray?.removeAll()
                }
                if let DSA = jsonResult?.data.list{
                    vv_imageCollecViewDataSourceArray = DSA
                    vv_imageCollecView.reloadData()
                    vv_imageCollecViewNoLoadCator.isHidden = true
                }else{
                    vv_imageCollecViewUpdateBtn.isHidden = false
                    vv_imageCollecViewNoLoadCator.isHidden = true
                    DispatchQueue.main.async {
                        let hud = MBProgressHUD.showAdded(to: vv_imageCollecView ?? vv_mainView ?? view, animated: true)
                        hud.mode = .text
                        hud.label.text = "网络异常，请下拉刷新"
                        hud.hide(animated: true, afterDelay: 8)
                    }
                }
            }else{
                vv_imageCollecViewUpdateBtn.isHidden = false
                vv_imageCollecViewNoLoadCator.isHidden = true
                DispatchQueue.main.async {
                    let hud = MBProgressHUD.showAdded(to: vv_imageCollecView ?? vv_mainView ?? view, animated: true)
                    hud.mode = .text
                    hud.label.text = "网络异常，请下拉刷新"
                    hud.hide(animated: true, afterDelay: 8)
                }
            }
        }
    }


}


//MARK: - 创建保存文件
extension ViewController {
    func ff_creatSaveImagePathDocument() {
        vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let fileManager: FileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: vv_imageDocumentsPath)
        if exist == false {
            let imageURLStr: [String] = []
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            //返回encode的Data
            let encoded = try! encoder.encode(imageURLStr)
            fileManager.createFile(atPath: vv_imageDocumentsPath,contents:encoded,attributes:nil)
        }else{return}
    }
}

extension ViewController {
    func ff_addNewestViewMJ() {
        vv_header0.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh))
         self.vv_newestView.mj_header = vv_header0
        vv_footer0.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh))
        self.vv_newestView.mj_footer = vv_footer0
    }
    
    @objc func ff_newestHeaderRefresh() {
        self.vv_newestView.mj_header!.endRefreshing()
        ff_dacodeNewestJsonData(path: vv_newestImageLink)
    }
    
    @objc func ff_footerRefresh() {
        vv_newestView.mj_footer!.endRefreshingWithNoMoreData()
    }
    
    func ff_addWallViewMJ() {
        vv_header1.setRefreshingTarget(self, refreshingAction: #selector(ff_wallViewHeaderRefresh))
        vv_wallPaperVeiw.mj_header = vv_header1
        vv_footer1.setRefreshingTarget(self, refreshingAction: #selector(ff_wallViewFooterRefresh))
        vv_wallPaperVeiw.mj_footer = vv_footer1
    }

    @objc func ff_wallViewHeaderRefresh() {
        self.vv_wallPaperVeiw.mj_header!.endRefreshing()
        ff_dacodeWallJsonData(path: vv_wallImageLink)
    }
    
    @objc func ff_wallViewFooterRefresh() {
        vv_wallPaperVeiw.mj_footer!.endRefreshingWithNoMoreData()
    }
    
    func ff_addFaceViewMJ() {
        vv_header2.setRefreshingTarget(self, refreshingAction: #selector(ff_faceViewHeaderRefresh))
        vv_faceView.mj_header = vv_header2
        vv_footer2.setRefreshingTarget(self, refreshingAction: #selector(ff_faceViewFooterRefresh))
        vv_faceView.mj_footer = vv_footer2
    }

    @objc func ff_faceViewHeaderRefresh() {
        self.vv_faceView.mj_header!.endRefreshing()
        ff_dacodeFaceJsonData(path: vv_faceImageLink)
    }
    
    @objc func ff_faceViewFooterRefresh() {
        vv_faceView.mj_footer!.endRefreshingWithNoMoreData()
    }
    
    func ff_addImageCollecViewMJ() {
        vv_header3.setRefreshingTarget(self, refreshingAction: #selector(ff_ImageCollecViewHeaderRefresh))
        vv_imageCollecView.mj_header = vv_header3
        vv_footer3.setRefreshingTarget(self, refreshingAction: #selector(ff_imageCollecViewFooterRefresh))
        vv_imageCollecView.mj_footer = vv_footer3
    }

    @objc func ff_ImageCollecViewHeaderRefresh() {
        self.vv_imageCollecView.mj_header!.endRefreshing()
        ff_dacodeImagecollecJsonData(path: vv_imageCollecImageLink)
    }
    
    @objc func ff_imageCollecViewFooterRefresh() {
        self.vv_newestView.mj_footer!.endRefreshing()
        vv_imageCollecView.mj_footer!.endRefreshingWithNoMoreData()
    }

    
}
