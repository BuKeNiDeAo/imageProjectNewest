//
//  FF_CatImage.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/14.
//


import UIKit
import Photos
import Foundation


class FF_CatImage: UIViewController {
    var vv_likeBtn: UIButton!
    var vv_imageView: UIImageView!
//    var vv_imageURL: String!
    var vv_isLike: Bool = false {
        didSet{
            if vv_isLike{
                vv_likeBtn.setImage(UIImage(named: "icon-xihuang"), for: .normal)
            }else{
                vv_likeBtn.setImage(UIImage(named: "icon-xihuang-1"), for: .normal)
            }
        }
    }
    var vv_iamgeKey: String!
    var vv_allColletionImagePath: [String]?
    var vv_allLikeImagePath: [String]?
    var vv_imageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setAttribute()
        ff_initImageView()
        ff_initBackBtn()
        ff_addLikeBtn()
        ff_initDownloaBtn()
        ff_initShareBtn()
    }
    
    func ff_setAttribute() {
        view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        navigationController?.navigationBar.isHidden = true
    }
    
// MARK: - 添加UIkongjian
    func ff_initImageView() {
        vv_imageView = UIImageView()
        let url = URL(string: vv_iamgeKey)
        vv_imageView.kf.setImage(with: url)
//        vv_imageView.ff_downloadedFrom(link: vv_imageURL)
        view.addSubview(vv_imageView)
        vv_imageView.snp.makeConstraints { (make) in
            let snpArray = ff_heitghScaleTransform(x: 0, y: 147, width: 375, height: 486)
            let heightWidthScale = ff_getHeightWidthScale(h: 486, w: 375)
            make.center.equalTo(CGPoint(x: snpArray[0], y: snpArray[1]))
            make.height.equalTo(snpArray[3])
            make.width.equalTo(vv_imageView.snp.height).multipliedBy(1/heightWidthScale)
        }
        ff_addGesture()
    }
    
    func ff_initBackBtn() {
        let snpArray = ff_widthScaleTransform(x: 14, y: 50, width: 54, height: 54)
        let heightWidthScale = ff_getHeightWidthScale(h: 54, w: 54)
        let _ = ff_initBtn(imageNamed: "icon-fh", tag: 0, snpArray: snpArray, scale: heightWidthScale)
    }
    
    func ff_addLikeBtn() {
        let snpArray = ff_widthScaleTransform(x: 321, y: 59, width: 36, height: 36)
        let heightWidthScale = ff_getHeightWidthScale(h: 36, w: 36)
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        let dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
        vv_likeBtn = ff_initBtn(imageNamed: "icon-xihuang-1", tag: 1, snpArray: snpArray, scale: heightWidthScale)
        let bool = dic.contains(vv_iamgeKey)
        if bool{
            vv_isLike = true
        }
    }
        
    func ff_initDownloaBtn() {
        let snpArray = ff_widthScaleTransform(x: 38, y: 663, width: 101, height: 52)
        let heightWidthScale = ff_getHeightWidthScale(h: 52, w: 101)
        let _ = ff_initBtn(imageNamed: "icon-xiazai", tag: 2, snpArray: snpArray, scale: heightWidthScale)
    }
    
    func ff_initShareBtn() {
        let snpArray = ff_widthScaleTransform(x: 236, y: 663, width: 101, height: 52)
        let heightWidthScale = ff_getHeightWidthScale(h: 52, w: 101)
        let _ = ff_initBtn(imageNamed: "icon-fengxiang", tag: 3, snpArray: snpArray, scale: heightWidthScale)
    }
    
    func ff_initBtn(imageNamed: String, tag: Int, snpArray: [CGFloat], scale: CGFloat) -> UIButton{
        let btn = UIButton()
        btn.tag = tag
        btn.setImage(UIImage(named: imageNamed), for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalTo(CGPoint(x: snpArray[0], y: snpArray[1]))
            make.width.equalTo(snpArray[2])
            make.height.equalTo(btn.snp.width).multipliedBy(scale)
        }
        btn.addTarget(self, action: #selector(ff_setBtnFunc(btn:)), for: .touchUpInside)
        return btn
    }

    @objc func ff_setBtnFunc(btn: UIButton) {
        switch btn.tag {
        case 0:
            self.navigationController?.popViewController(animated: true)
        case 1:
            ff_saveLikeImage()
        case 2:
            ff_isAuthorized()
        case 3:
            let activityVC = UIActivityViewController(activityItems: [vv_imageView.image!], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        default:
            break
        }
    }

// MARK: - 保存图片
    func ff_isAuthorized() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            DispatchQueue.main.async { [self] in
                UIImageWriteToSavedPhotosAlbum(vv_imageView.image!, self, #selector(saveImage), nil)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                self.ff_isAuthorized()
            }
        case .denied:
            ff_openSysSetting()
        default:
            break
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
       if error != nil{
          debugPrint(error)
       }else{
        ff_popupWindo()
       }
    }
    


    func ff_openSysSetting(){
        let vv_setttingURL = URL(string: UIApplication.openSettingsURLString)//获取设置界面的地址
        if UIApplication.shared.canOpenURL(vv_setttingURL!){
            UIApplication.shared.open(vv_setttingURL!)
        }
    }
    
    @objc func ff_popupWindo() {
        DispatchQueue.main.async { [self] in
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = "图片下载完成"
            hud.hide(animated: true, afterDelay: 0.8)
        }
    }
    
//    @objc func ff_backAlerController() {
//        let alertController = UIAlertController(title: "图片下载完成", message: "", preferredStyle: .alert)
//        self.present(alertController, animated: true) {
//            self.ff_timingMake()
//        }
//    }
    
    @objc func ff_timingMake(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
// MARK: -滑动切换图片
    func ff_addGesture() {
        let vv_swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ff_selectLast))
        vv_swipeLeft.direction = .left
        view.addGestureRecognizer(vv_swipeLeft)
        
        let vv_swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ff_selectNext))
        vv_swipeRight.direction = .right
        view.addGestureRecognizer(vv_swipeRight)

    }
    
    @objc func ff_selectLast() {
        print("往左滑")
        if vv_allColletionImagePath == nil{
            ff_leftSlide(imageDataSource: vv_allLikeImagePath!)
        }else{
            ff_leftSlide(imageDataSource: vv_allColletionImagePath!)
        }
        ff_showAnimation(.fromRight)
    }
    
    @objc func ff_selectNext() {
        print("往you滑")
        if vv_allColletionImagePath == nil{
            ff_rightSilde(imageDataSource: vv_allLikeImagePath!)
        }else{
            ff_rightSilde(imageDataSource: vv_allColletionImagePath!)
        }
    }
    
    func ff_showAnimation(_ subtype: CATransitionSubtype) {
        let vv_transition = CATransition()
        vv_transition.duration = 0.5
        vv_transition.type = CATransitionType.moveIn 
        vv_transition.subtype = subtype
        vv_imageView.exchangeSubview(at: 1, withSubviewAt: 0)
        vv_imageView.layer.add(vv_transition, forKey: nil)
    }
    

    func ff_rightSilde(imageDataSource: [String]) {
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        let dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
        for index in 0..<imageDataSource.count {
            if imageDataSource[index] == vv_iamgeKey{
                if vv_imageIndex == nil {
                    vv_imageIndex = index
                }
                if vv_imageIndex-1 >= 0 {
                    vv_iamgeKey = imageDataSource[vv_imageIndex-1]
                    let url = URL(string: imageDataSource[vv_imageIndex-1])
                    vv_imageView.kf.setImage(with: url)
                    if dic.contains(vv_iamgeKey){
                        vv_isLike = true
                    }else{
                        vv_isLike = false
                    }
                    vv_imageIndex = vv_imageIndex-1
                    ff_showAnimation(.fromLeft)
                    break
                }else{
                    ff_hintNoImage()
                    break
                }
            }
        }
    }
    
    func ff_leftSlide(imageDataSource: [String]){
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        let dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>

        for index in 0..<imageDataSource.count {
            if imageDataSource[index] == vv_iamgeKey{
                if vv_imageIndex == nil {
                    vv_imageIndex = index
                }
                if vv_imageIndex+1 < imageDataSource.count {
                    vv_iamgeKey = imageDataSource[vv_imageIndex+1]
                    let url = URL(string: imageDataSource[vv_imageIndex+1])
                    vv_imageView.kf.setImage(with: url)
                    if dic.contains(imageDataSource[vv_imageIndex+1]){
                        vv_isLike = true
                    }else{
                        vv_isLike = false
                    }
                    vv_imageIndex = vv_imageIndex+1
                    ff_showAnimation(.fromLeft)
                    break
                }else{
                    ff_hintNoImage()
                    break
                }
            }
        }

    }
    
    func ff_hintNoImage(){
        let alertController = UIAlertController(title: "没有图片了", message: "", preferredStyle: .alert)
        self.present(alertController, animated: true) {
            self.ff_timingMake()
        }
    }

    
}


//MARK: -保存url
extension FF_CatImage {
    func ff_saveLikeImage() {
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        var dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
        switch vv_isLike {
        case false:
            dic.append(vv_iamgeKey)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            //返回encode的Data
            let encoded = try! encoder.encode(dic)
            try? encoded.write(to:url)
            vv_isLike = true
        case true:
            for index in 0..<dic.count{
                if dic[index] == vv_iamgeKey {
                    dic.remove(at: index)
                    break
                }
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            //返回encode的Data
            let encoded = try! encoder.encode(dic)
            try? encoded.write(to:url)
            vv_isLike = false
        }
    }
    
    
}


