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

class AppMainView: UIViewController {
    
    var vv_isNetworkStatus:Bool = true
    let vv_reachability = try! Reachability()
    
    var vv_mainView: FF_MainView!
    
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
    
    var vv_domainArr = [
        "https://api.hulktech.cn/image/getLatestUpdateDmList?",
        "https://api.hulktech.cn/image/getDmBiaoqingList?",
        "https://api.hulktech.cn/image/getLatestUpdateDmList?",
        "https://api.hulktech.cn/image/getDmTujiList?",
        "https://api.hulktech.cn/image/getImageList?"]
    
    let cache = ImageCache.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setAttribute()
        ff_initLeftBar()
        ff_addNewestLb()
        ff_addNewstImageView()
        ff_addAllRanked()
        ff_addMainView()
        ff_monitorNetworkStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FF_Link.ff_creatSaveImagePathDocument()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func ff_setAttribute() {
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        cache.memoryStorage.config.countLimit = 30
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024
        cache.memoryStorage.config.expiration = .seconds(60)
        cache.diskStorage.config.expiration = .seconds(120)
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
        ff_initHideLeftBarBtn(referencesView: hideBtn)
    }
    
    func ff_initHideLeftBarBtn(referencesView: UIView) {
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
            let iamgePathArr = FF_Link.ff_getDickImagePathArr()
            let FF_likePreview = FF_Preview()
            FF_likePreview.title = "我喜欢的"
            FF_likePreview.vv_imageImagePathArr = iamgePathArr
            self.navigationController?.pushViewController(FF_likePreview, animated: true)
        case 1:
            if vv_isNetworkStatus {
                AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
                    vv_mainView.vv_isLastView = false
                    vv_mainView.ff_clearData()
                    vv_mainView.ff_initRefress(domain: vv_domainArr[0], pageSize: 12)
                }
            }else {
                ff_showNONetwork()
            }
        case 2:
            if vv_isNetworkStatus {
                AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
                    vv_mainView.vv_isLastView = false
                    vv_mainView.ff_clearData()
                    vv_mainView.ff_initRefress(domain: vv_domainArr[1], pageSize: 12)
                }
            }else {
                ff_showNONetwork()
            }
        case 3:
            if vv_isNetworkStatus {
                AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
                    vv_mainView.vv_isLastView = false
                    vv_mainView.ff_clearData()
                    vv_mainView.ff_initRefress(domain: vv_domainArr[2], pageSize: 12)
                }
            }else {
                ff_showNONetwork()
            }
        case 4:
            if vv_isNetworkStatus {
                AF.cancelAllRequests(completingOnQueue: .main) { [unowned self] in
                vv_mainView.ff_clearData()
                vv_mainView.vv_isLastView = true
                vv_mainView.ff_initRefress(domain: vv_domainArr[3], pageSize: 4)
                }
            }else {
                ff_showNONetwork()
            }
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
        vv_mainView.vv_isMinWidth = true
        vv_mainView.reloadData()
        view.bringSubviewToFront(vv_hideLeftBarBtn)
    }
    
    func ff_showLeftBar() {
        vv_newestLb.snp.updateConstraints { (make) in
            make.left.equalTo(95.ff_widthTransform())
        }
        vv_mainView.vv_isMinWidth = false
        vv_mainView.reloadData()
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
        vv_newestImageVeiw.backgroundColor = .clear
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
//        vv_newestImageVeiw.kf.setImage(with: url, for: .normal)
        vv_newestImageVeiw.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: "icon-jiazai"))
        vv_newestImageVeiw.addTarget(self, action: #selector(ff_openNewestImageView), for: .touchUpInside)
    }
    
    @objc func ff_openNewestImageView(bt:UIButton) {
        let catImage = FF_CatImage()
        catImage.vv_iamgeKey = vv_newestImageVeiwPath
        catImage.vv_allColletionImagePath = [vv_newestImageVeiwPath]
        self.navigationController?.pushViewController(catImage, animated: true)
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
        let layout = UICollectionViewFlowLayout()
        vv_mainView = FF_MainView.init(frame: CGRect.zero, collectionViewLayout: layout)
        vv_mainView.vv_delegate = self
        vv_mainView.backgroundColor = .clear
        view.addSubview(vv_mainView)
        vv_mainView.snp.makeConstraints { (make) in
            make.top.equalTo(vv_allRanked.snp.bottom).offset(12.ff_heitghTransform())
            make.bottom.equalTo(-18)
            make.left.equalTo(vv_newestImageVeiw.snp.left)
            make.right.equalTo(vv_newestImageVeiw.snp.right)
        }
        vv_mainView.layoutIfNeeded()
        vv_mainView.ff_initRefress(domain: vv_domainArr[0], pageSize: 12)
        let vv_header = MJRefreshNormalHeader()
        let vv_footer = MJRefreshAutoNormalFooter()
        vv_header.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh))
        vv_mainView.mj_header = vv_header
        vv_footer.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh))
        vv_mainView.mj_footer = vv_footer
    }
    
    @objc func ff_newestHeaderRefresh() {
        if vv_isNetworkStatus {
            self.vv_mainView.ff_newestHeaderRefresh()
        }else {
            vv_mainView.mj_header?.endRefreshing()
            ff_showNONetwork()
        }
    }
    
    @objc func ff_footerRefresh() {
        if vv_isNetworkStatus {
            self.vv_mainView.ff_footerRefresh()
        }else {
            vv_mainView.mj_footer?.endRefreshing()
            ff_showNONetwork()
        }
    }
    
    func ff_showNONetwork() {
        DispatchQueue.main.async { [self] in
            let hud = MBProgressHUD.showAdded(to: vv_mainView ?? view, animated: true)
            hud.mode = .text
            hud.label.text = "没有网络"
            hud.hide(animated: true, afterDelay: 0.8)
        }
    }

    
}

//MARK: - 实现代理方法
extension AppMainView: FF_ViewContro2Protocol {
    func ff_getImagePath(path: String, pathArr: [String]) {
        let catImage = FF_CatImage()
        catImage.vv_iamgeKey = path
        catImage.vv_allColletionImagePath = pathArr
        self.navigationController?.pushViewController(catImage, animated: true)
    }
    
    func ff_getImagePath(id: Int) {
        if vv_isNetworkStatus {
            let parameters = [
                "page": 1,
                "pageSize": 100,
                "image_set_id": id
            ]
            FF_Link.ff_dacodeImageCollectJsonData(domain: vv_domainArr[4], parameters: parameters) { [unowned self] iamgePathArr,a,b,c,d,e   in
                let FF_imageCollecView = FF_Preview()
                FF_imageCollecView.ff_transferAttribute(title: "图集", imageArr: iamgePathArr, isLike: false, domain: vv_domainArr[4], parameters: parameters)
                self.navigationController?.pushViewController(FF_imageCollecView, animated: true)
            } failure: {
                DispatchQueue.main.async { [unowned self] in
                    let hud = MBProgressHUD.showAdded(to: vv_mainView ?? view, animated: true)
                    hud.show(animated: true)
                    hud.mode = .text
                    hud.label.text = "网络异常，请重试"
                    hud.hide(animated: true, afterDelay: 2)
                }
            }
        }else {
            ff_showNONetwork()
        }
    }
    
    
}

extension AppMainView {
    // MARK: 监听网络状态
    func ff_monitorNetworkStatus() {
        vv_reachability.whenReachable = { [unowned self] reachability in
//            if reachability.connection == .wifi {
//                print("使用蜂窝网络")
//                ff_loadimagePath()
//            } else {
//                print("连接wifi")
//            }
            vv_isNetworkStatus = true
        }
        
        vv_reachability.whenUnreachable = { [unowned self] _ in
            vv_isNetworkStatus = false
            ff_showNONetwork()
        }
        do {
            try vv_reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

