//
//  FF_CatImageView.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/24.
//

import UIKit
import MJRefresh

class FF_CatImageView: UIViewController, UICollectionViewDataSource {
    var vv_header: MJRefreshNormalHeader!
    var vv_footer: MJRefreshAutoNormalFooter!

    var vv_imageKey: [String] = []
    var vv_preview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_setNavi()
        ff_setAttribute()
        ff_addPrevire()
        ff_addNewestViewMJ()
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
    
    func ff_setAttribute() {
        title = "图集"
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        vv_header = MJRefreshNormalHeader()
        vv_footer = MJRefreshAutoNormalFooter()
    }
    
    
    func ff_addPrevire() {
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
            let a = ff_getAutoLayoutRect(x: 95, y: 307, width: 268, height: 442)
            make.top.equalTo(50.ff_heitghTransform())
            make.height.equalTo(200)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        //设置代理与数据源
        vv_preview.delegate = self
        vv_preview.dataSource = self
        //注册数据载体类
        vv_preview.register(NSClassFromString("UICollectionViewCell"), forCellWithReuseIdentifier: "itemId")
    }
    
    func ff_addNewestViewMJ() {
        vv_header.setRefreshingTarget(self, refreshingAction: #selector(ff_newestHeaderRefresh))
        vv_preview.mj_header = vv_header
        vv_footer.setRefreshingTarget(self, refreshingAction: #selector(ff_footerRefresh))
        vv_preview.mj_footer = vv_footer
    }
    
    @objc func ff_newestHeaderRefresh() {
        vv_preview.mj_header!.endRefreshing()
        vv_preview.reloadData()
    }
    
    @objc func ff_footerRefresh() {
        vv_preview.mj_footer?.endRefreshingWithNoMoreData()
    }


}


extension FF_CatImageView: UICollectionViewDelegate {
    // 返回分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 返回每个分区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vv_imageKey.count
    }
    
    // 返回每个分区具体的数据载体item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        let vv_cellImageView = UIImageView()
        vv_cellImageView.frame = cell.bounds
            let imageURL = URL(string: vv_imageKey[indexPath.row])
            vv_cellImageView.kf.setImage(with: imageURL)
        cell.addSubview(vv_cellImageView)
        return cell
    }
    
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let CatImage = FF_CatImage()
        CatImage.vv_iamgeKey = vv_imageKey[indexPath.row]
        CatImage.vv_allLikeImagePath = vv_imageKey
        self.modalPresentationStyle = .fullScreen
        CatImage.modalPresentationStyle = .fullScreen
        present(CatImage, animated: true, completion: nil)
    }
    
}

extension FF_CatImageView: UICollectionViewDelegateFlowLayout {
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
