//
//  FF_CatNewestImage.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/20.
//
import UIKit
import Photos
import Foundation


class FF_CatNewestImage: UIViewController {
    var vv_likeBtn: UIButton!
    var vv_iamgeKey: String!
    var vv_imageView: UIImageView!
    var vv_imageURL: String!
    var vv_isLike: Bool = false {
        didSet{
            if vv_isLike{
                vv_likeBtn.setImage(UIImage(named: "icon-xihuang"), for: .normal)
            }else{
                vv_likeBtn.setImage(UIImage(named: "icon-xihuang-1"), for: .normal)
            }
        }
    }
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
            
//            let snpArray = ff_widthScaleTransform(x: 0, y: 147, width: 375, height: 486)
//            let heightWidthScale = ff_getHeightWidthScale(h: 486, w: 375)
//            make.center.equalTo(CGPoint(x: snpArray[0], y: snpArray[1]))
//            make.width.equalTo(snpArray[2])
//            make.height.equalTo(vv_imageView.snp.width).multipliedBy(heightWidthScale)

        }
    }
    
    func ff_initBackBtn() {
        let snpArray = ff_widthScaleTransform(x: 14, y: 50, width: 54, height: 54)
        let heightWidthScale = ff_getHeightWidthScale(h: 54, w: 54)
        ff_initBtn(imageNamed: "icon-fh", tag: 0, snpArray: snpArray, scale: heightWidthScale)
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
        ff_initBtn(imageNamed: "icon-xiazai", tag: 2, snpArray: snpArray, scale: heightWidthScale)
    }
    
    func ff_initShareBtn() {
        let snpArray = ff_widthScaleTransform(x: 236, y: 663, width: 101, height: 52)
        let heightWidthScale = ff_getHeightWidthScale(h: 52, w: 101)
        ff_initBtn(imageNamed: "icon-fengxiang", tag: 3, snpArray: snpArray, scale: heightWidthScale)
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
            self.dismiss(animated: true, completion: nil)
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
            UIImageWriteToSavedPhotosAlbum(vv_imageView.image!, self, #selector(ff_backAlerController), nil);
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

    func ff_openSysSetting(){
        let vv_setttingURL = URL(string: UIApplication.openSettingsURLString)//获取设置界面的地址
        if UIApplication.shared.canOpenURL(vv_setttingURL!){
            UIApplication.shared.open(vv_setttingURL!)
        }
    }
    
    @objc func ff_backAlerController() {
        let alertController = UIAlertController(title: "图片下载完成", message: "", preferredStyle: .alert)
        self.present(alertController, animated: true) {
            self.ff_timingMake()
        }
    }
    
    @objc func ff_timingMake(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}


//MARK: -保存url
extension FF_CatNewestImage {
    func ff_saveLikeImage() {
        switch vv_isLike {
        case false:
            let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
            let url = URL(fileURLWithPath: vv_imageDocumentsPath)
            let JSONdata = try! Data(contentsOf: url)
            var dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
            dic.append(vv_iamgeKey)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            //返回encode的Data
            let encoded = try! encoder.encode(dic)
            try? encoded.write(to:url)
            vv_isLike = true
        case true:
            let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
            let url = URL(fileURLWithPath: vv_imageDocumentsPath)
            let JSONdata = try! Data(contentsOf: url)
            var dic = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
            for index in 0..<dic.count{
                print(index,"-=-=-=-=-=-=-=-=")
                print(dic[index])
                if dic[index] == vv_iamgeKey {
                    dic.remove(at: index)
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


