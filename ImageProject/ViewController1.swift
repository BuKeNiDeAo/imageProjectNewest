//
//  ViewController1.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/23.
//
/*
import UIKit
import SnapKit
import Kingfisher
import Foundation
import SVProgressHUD
import Reachability
import Alamofire
import MJRefresh

class ViewController1: UIViewController {
    var vv_newestVeiw, vv_wallVeiw, vv_faceView: FF_CC!
    var vv_imageCollecView: FF_VV!
    var vv_newestRect, vv_wallRect, vv_faceRect, vv_imageCollecRect: CGRect!
    
    var vv_isNetworkStatus:Bool = true
    let vv_reachability = try! Reachability()
    var vv_noNetworlView: UIImageView!
    
    var vv_mainView: UIScrollView!
    var vv_mainViewWidth, vv_mainViewheitgh: CGFloat!
    
    var vv_leftBar: UIView!
    var vv_hideLeftBarBtn: UIButton!
    var vv_isLatent: Bool = false{
        didSet {
            vv_leftBar.isHidden = vv_isLatent
            vv_hideLeftBarBtn.isHidden = !vv_isLatent
                    }
    }
    
    var vv_newestLb, vv_allRanked: UILabel!
    var vv_newestImageVeiw: UIButton!
    var vv_newestImageVeiwPath: String!
//    let cache = ImageCache.default

//    var saveImagePathDocumentsPath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setAttribute()
        setNavibarimage()
        ff_initLeftBar()
        ff_addNewestLb()
        ff_addNewstImageView()
        ff_addAllRanked()
        ff_addMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ff_creatSaveImagePathDocument()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func ff_setAttribute() {
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
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
        ff_addLeftBarSubView()
    }
    
    func ff_addLeftBarSubView() {
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
        ff_initHideLeftBarBtnn(referencesView: hideBtn)
    }
    
    func ff_initHideLeftBarBtnn(referencesView: UIView) {
        vv_hideLeftBarBtn = UIButton()
        vv_hideLeftBarBtn.isHidden = true
        vv_hideLeftBarBtn.tag = 5
        vv_hideLeftBarBtn.setImage(UIImage(named: "icon-cbl-1"), for: .normal)
        view.addSubview(vv_hideLeftBarBtn)
        vv_hideLeftBarBtn.snp.makeConstraints { (make) in
            make.left.equalTo(referencesView)
            make.right.equalTo(referencesView)
            make.centerY.equalTo(referencesView)
            make.height.equalTo(referencesView)
        }
        vv_hideLeftBarBtn.addTarget(self, action: #selector(ff_leftBarTrigger(btn:)), for: .touchUpInside)
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
            if vv_isLatent{
                ff_showLeftBar()
            }else{
                ff_hideLeftBar()
            }
            vv_isLatent = !vv_isLatent
        default:
            break
        }
    }
    
    func ff_hideLeftBar() {
        vv_newestLb.snp.updateConstraints { (make) in
            make.left.equalTo(12)
        }
        
        vv_newestLb.layoutIfNeeded()
        vv_newestVeiw.frame =  CGRect(x: 0, y: 0, width: view.frame.width-24, height: vv_newestRect.height)
        vv_wallVeiw.frame =  CGRect(x: 0, y: vv_newestRect.height, width: view.frame.width-24, height: vv_newestRect.height)
        vv_faceView.frame =  CGRect(x: 0, y: vv_newestRect.height*2, width: view.frame.width-24, height: vv_newestRect.height)
        vv_imageCollecView.frame =  CGRect(x: 0, y: vv_newestRect.height*3, width: view.frame.width-24, height: vv_newestRect.height)
        view.bringSubviewToFront(vv_hideLeftBarBtn)

        vv_newestVeiw.reloadData()
        vv_wallVeiw.reloadData()
        vv_faceView.reloadData()
        vv_imageCollecView.reloadData()
        
    }
    
    func ff_showLeftBar() {
        vv_newestLb.snp.updateConstraints { (make) in
            make.left.equalTo(95.ff_widthTransform())
        }
        vv_newestVeiw.frame =  vv_newestRect
        vv_wallVeiw.frame =  vv_wallRect
        vv_faceView.frame =  vv_faceRect
        vv_imageCollecView.frame =  vv_imageCollecRect
        view.bringSubviewToFront(vv_hideLeftBarBtn)

        vv_newestVeiw.reloadData()
        vv_wallVeiw.reloadData()
        vv_faceView.reloadData()
        vv_imageCollecView.reloadData()
        view.bringSubviewToFront(vv_leftBar)
    }
// MARK: -------------------------------------------------------------------------------------
   
    
// MARK: - 布局主界面
    func ff_addNewestLb() {
        vv_newestLb = UILabel()
        vv_newestLb.text = "最新推荐"
        vv_newestLb.textAlignment = .center
        vv_newestLb.font = UIFont.init(name: "PingFang SC", size: 18)
        self.view.addSubview(vv_newestLb)
        vv_newestLb.snp.makeConstraints { (make) in
            let a = ff_getCenterY(y: 54, heifgh: 72)
            make.left.equalTo(95.ff_widthTransform())
            make.centerY.equalTo(a)
            make.size.equalTo(CGSize(width: 72, height: 25))
        }
        ff_initAfronView(referencesView: vv_newestLb)
    }
    /// 初始化修饰View
    func ff_initAfronView(referencesView: UIView) {
        let adronView = UIView()
        adronView.backgroundColor = UIColor.init(red: 1, green: 0.84, blue: 0.56, alpha: 1)
        view.addSubview(adronView)
        adronView.snp.makeConstraints { (make) in
            make.left.equalTo(referencesView.snp.left)
            make.width.equalTo(referencesView.snp.width)
            make.top.equalTo(referencesView.snp.top).offset(18)
            make.bottom.equalTo(referencesView.snp.bottom).offset(-3)
        }
        self.view.insertSubview(adronView, belowSubview: referencesView)
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
            make.right.equalTo(-12)
            make.height.equalTo(vv_newestImageVeiw.snp.width).multipliedBy(scale)
        }
        vv_newestImageVeiwPath = "https://sjbz-fd.zol-img.com.cn/t_s1080x1920c5/g5/M00/0F/0F/ChMkJlfJSyWIPQEjAAX0y3KO2q8AAU89AJeLD0ABfTj756.jpg"
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
            make.left.equalTo(vv_newestLb.snp.left)
            make.size.equalTo(CGSize(width: 36, height: 25))
        }
        ff_initAfronView(referencesView: vv_allRanked)
    }
    
    // MARK: -布局mainView
    func ff_addMainView() {
        vv_mainView = UIScrollView()
        vv_mainView.backgroundColor = .blue
        vv_mainView.alwaysBounceVertical = true
        vv_mainView.isScrollEnabled = false
        view.addSubview(vv_mainView)
        vv_mainView.snp.makeConstraints { (make) in
            make.top.equalTo(vv_allRanked.snp.bottom).offset(12.ff_heitghTransform())
            make.bottom.equalTo(-18)
            make.left.equalTo(vv_newestImageVeiw.snp.left)
            make.right.equalTo(vv_newestImageVeiw.snp.right)
        }
        vv_mainView.layoutIfNeeded()
        vv_mainView.contentSize = CGSize(width: vv_mainView.frame.width, height: vv_mainView.frame.height*4)
        vv_mainViewWidth = vv_mainView.frame.width
        vv_mainViewheitgh = vv_mainView.frame.height

        ff_initNesestView()
        ff_initWallView()
        ff_initFaceView()
        ff_initImageCollecView()
    }
    
    func ff_initNesestView() {
        vv_newestRect = CGRect(x: 0, y: 0, width: vv_mainView.frame.width, height: vv_mainView.frame.height)
        let layout = UICollectionViewFlowLayout()
        vv_newestVeiw = FF_CC.init(frame: vv_newestRect, collectionViewLayout: layout, domain: "https://api.hulktech.cn/image/getLatestUpdateDmList?page=")
        vv_newestVeiw.vv_delerate = self
        vv_mainView.addSubview(vv_newestVeiw)
        let vv_header = MJRefreshNormalHeader()
        let vv_footer = MJRefreshAutoNormalFooter()
        vv_header.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh))
        vv_newestVeiw.mj_header = vv_header
        vv_footer.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh))
        vv_newestVeiw.mj_footer = vv_footer
    }
    
    func ff_initWallView() {
        vv_wallRect = CGRect(x: 0, y: vv_mainView.frame.height, width: vv_mainView.frame.width, height: vv_mainView.frame.height)
        let layout2 = UICollectionViewFlowLayout()
        vv_wallVeiw = FF_CC.init(frame: vv_wallRect, collectionViewLayout: layout2, domain: "https://api.hulktech.cn/image/getDmBiaoqingList?page=")
        vv_wallVeiw.vv_delerate = self
        vv_mainView.addSubview(vv_wallVeiw)
        let vv_header2 = MJRefreshNormalHeader()
        let vv_footer2 = MJRefreshAutoNormalFooter()
        vv_header2.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh2))
        vv_wallVeiw.mj_header = vv_header2
        vv_footer2.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh2))
        vv_wallVeiw.mj_footer = vv_footer2
    }
    
    func ff_initFaceView() {
        vv_faceRect = CGRect(x: 0, y: vv_mainView.frame.height*2, width: vv_mainView.frame.width, height: vv_mainView.frame.height)
        let layout3 = UICollectionViewFlowLayout()
        vv_faceView = FF_CC.init(frame: vv_faceRect, collectionViewLayout: layout3, domain: "https://api.hulktech.cn/image/getDmBiaoqingList?page=")
        vv_faceView.vv_delerate = self
        vv_mainView.addSubview(vv_faceView)
        let vv_header3 = MJRefreshNormalHeader()
        let vv_footer3 = MJRefreshAutoNormalFooter()
        vv_header3.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh3))
        vv_faceView.mj_header = vv_header3
        vv_footer3.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh3))
        vv_faceView.mj_footer = vv_footer3
    }
    
    func ff_initImageCollecView() {
        let layout4 = UICollectionViewFlowLayout()
        vv_imageCollecRect = CGRect(x: 0, y:  vv_mainView.frame.height*3, width: vv_mainView.frame.width, height: vv_mainView.frame.height)
        vv_imageCollecView = FF_VV.init(frame: vv_imageCollecRect, collectionViewLayout: layout4, domain: "https://api.hulktech.cn/image/getDmTujiList?page=")
        vv_imageCollecView.vv_delerate = self
        vv_mainView.addSubview(vv_imageCollecView)
        let vv_header4 = MJRefreshNormalHeader()
        vv_header4.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh4))
        vv_imageCollecView.mj_header = vv_header4
        let vv_footer4 = MJRefreshAutoNormalFooter()
        vv_footer4.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh4))
        vv_imageCollecView.mj_footer = vv_footer4

    }
    
    @objc func ff_newestHeaderRefresh() {
        self.vv_newestVeiw.ff_newestHeaderRefresh()
    }
    
    @objc func ff_footerRefresh() {
        self.vv_newestVeiw.ff_footerRefresh()
    }
    
    @objc func ff_newestHeaderRefresh2() {
        self.vv_wallVeiw.ff_newestHeaderRefresh()
    }
    
    @objc func ff_footerRefresh2() {
        self.vv_wallVeiw.ff_footerRefresh()
    }
    
    @objc func ff_newestHeaderRefresh3() {
        self.vv_faceView.ff_newestHeaderRefresh()
    }
    
    @objc func ff_footerRefresh3() {
        self.vv_faceView.ff_footerRefresh()
    }
    
    @objc func ff_newestHeaderRefresh4() {
        self.vv_imageCollecView.ff_newestHeaderRefresh()
    }
    
    @objc func ff_footerRefresh4() {
        self.vv_imageCollecView.ff_footerRefresh()
    }

}




//MARK: - 创建保存文件
extension ViewController1 {
    func ff_creatSaveImagePathDocument() {
        let saveImagePathDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let fileManager: FileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: saveImagePathDocumentsPath)
        if exist == false {
            let imageURLStr: [String] = []
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            //返回encode的Data
            let encoded = try! encoder.encode(imageURLStr)
            fileManager.createFile(atPath: saveImagePathDocumentsPath,contents:encoded,attributes:nil)
        }else{return}
    }
}

//MARK: - 实现代理方法

extension ViewController1: FF_ViewControProtocol {
    func ff_(path: String, pathArr: [String]) {
        let catImage = FF_CatImage()
        catImage.vv_iamgeKey = path
        catImage.vv_allColletionImagePath = pathArr
        self.modalPresentationStyle = .fullScreen
        catImage.modalPresentationStyle = .fullScreen
        self.present(catImage, animated: true)
    }
}

extension ViewController1: FF_ViewContro2Protocol {
    func ff_1(pathArr: [String]) {
        let catImgaCollec = FF_CatImageView()
        catImgaCollec.vv_imageKey = pathArr
        self.navigationController?.pushViewController(catImgaCollec, animated: true)
    }
}
*/
