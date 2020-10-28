//
//  FF_CVCellLast.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/24.
//

import Foundation

class FF_CVCellLast: UICollectionViewCell {
    
    var vv_cellImageView = UIImageView()
    var vv_label1 = UILabel()
    var vv_label2 = UILabel()
    var vv_label3 = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
    }
    
    func ff_setImageView(path: String) {
        vv_cellImageView.clipsToBounds = true
        vv_cellImageView.layer.cornerRadius = 6
        addSubview(vv_cellImageView)
        vv_cellImageView.snp.makeConstraints { (make) in
                    let scale = ff_getWidthHeitghScale(w: 98, h: 75)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.left.equalTo(8)
            make.width.equalTo(vv_cellImageView.snp.height).multipliedBy(scale)
            
        }
        let imageURL = URL(string: path)
        vv_cellImageView.kf.indicatorType = .activity
        vv_cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "icon-jiazai"))
    }
    
    func ff_setLabel1(str: String) {
        vv_label1.text = "「图集」\(str)图集"
        vv_label1.font = UIFont.init(name: "PingFang SC", size: 12)
        vv_label1.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        vv_label1.textAlignment = .right
        vv_label1.adjustsFontSizeToFitWidth = true
        addSubview(vv_label1)
        vv_label1.snp.makeConstraints { (make) in
            make.right.equalTo(-11)
            make.left.equalTo(0)
            make.top.equalTo(9)
            make.height.equalTo(15)
        }
    }
    
    func ff_setLabel2() {
        vv_label2.text = "进去看看"
        vv_label2.textAlignment = .center
        vv_label2.font = UIFont.init(name: "PingFang SC", size: 13)
        vv_label2.textColor = UIColor(red: 1, green: 0.78, blue: 0.39, alpha: 1)
        vv_label2.backgroundColor = UIColor(red: 0.39, green: 0.17, blue: 0.97, alpha: 1)
        vv_label2.layer.cornerRadius = 15
        vv_label2.clipsToBounds = true
        addSubview(vv_label2)
        vv_label2.snp.makeConstraints { (make) in
            make.bottom.equalTo(-13)
            make.left.equalTo(vv_cellImageView.snp.right).offset(10)
            make.width.equalTo(76)
            make.height.equalTo(26)
        }
    }
    
    func ff_setLabel3(str: String) {
        vv_label3.text = str
        vv_label3.font = UIFont.init(name: "PingFang SC", size: 14)
        vv_label3.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        addSubview(vv_label3)
        vv_label3.snp.makeConstraints { (make) in
            make.left.equalTo(vv_cellImageView.snp.right).offset(10)
            make.right.equalTo(0)
            make.bottom.equalTo(vv_label2.snp.top).offset(-7)
            make.height.equalTo(20)
        }
    }
    
    func ff_addInformation(imagePath: String, lb1Text: String, lb3Text: String) {
        ff_setImageView(path: imagePath)
        ff_setLabel1(str: lb1Text)
        ff_setLabel2()
        ff_setLabel3(str: lb3Text)
    }
}
