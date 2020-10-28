//
//  FF_CVCellimage1.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/24.
//

import Foundation

class FF_CVCellNewest: UICollectionViewCell {
    var vv_cellImageView = UIImageView()

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func ff_addImageView(path: String) {
        let url = URL(string: path)
        vv_cellImageView.kf.indicatorType = .activity
        vv_cellImageView.kf.setImage(with: url, placeholder: UIImage(named: "icon-jiazai"))
        addSubview(vv_cellImageView)
        vv_cellImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func ff_addInformation(imagePath: String) {
        ff_addImageView(path: imagePath)
    }
    
    
    
    
}
