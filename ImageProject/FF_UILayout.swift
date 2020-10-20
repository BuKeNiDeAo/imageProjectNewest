//
//  FF_Util.swift
//  AnimeGather
//
//  Created by 刘胜 on 2020/9/4.
//  Copyright © 2020 liusheng. All rights reserved.
//

import Foundation
import UIKit

let VV_screenWidth = UIScreen.main.bounds.width
let VV_screenHeight =  UIScreen.main.bounds.height

/// 获取snp约束布局的上下左右
public func ff_getAutoLayoutRect(x:CGFloat, y: CGFloat, width: CGFloat, height:CGFloat, actualWidth: CGFloat = UIScreen.main.bounds.width, actualHeight: CGFloat = UIScreen.main.bounds.height, templateWidth:CGFloat = 375,  templateHeigh:CGFloat = 812) -> Array<CGFloat>{
    var snpLaoutData:[CGFloat] = []
    let offsetTop = actualHeight * y / templateHeigh
    let offsetBottom = 0 - actualHeight * (templateHeigh - y - height) / templateHeigh
    let offsetLeft = actualWidth * x / templateWidth
    let offsetRight = 0 - actualWidth * (templateWidth - x - width) / templateWidth
    
    snpLaoutData.append(offsetTop)
    snpLaoutData.append(offsetBottom)
    snpLaoutData.append(offsetLeft)
    snpLaoutData.append(offsetRight)
    return snpLaoutData

}

/// 过去snp布局的中心点，以及宽高，全部按比例得到
public func ff_getAutoLayoutCenter(x:CGFloat, y: CGFloat, width:CGFloat, height:CGFloat, actualWidth: CGFloat = UIScreen.main.bounds.width, actualHeight: CGFloat = UIScreen.main.bounds.height, templateWidth:CGFloat = 375,  templateHeigh:CGFloat = 812) -> Array<CGFloat>{
    var snpLaoutData:[CGFloat] = []
    let snpCenterX = actualWidth * (x + (width / 2)) / templateWidth
    let snpCenterY = actualHeight * (y + (height / 2)) / templateHeigh
    let snpSizeWidth = actualWidth * width / templateWidth
    let snpSizeHeight = actualHeight * height / templateHeigh
    
    snpLaoutData.append(snpCenterX)
    snpLaoutData.append(snpCenterY)
    snpLaoutData.append(snpSizeWidth)
    snpLaoutData.append(snpSizeHeight)
    return snpLaoutData
}

/// 根据CGRect来换算，xywh全部按比例换算
public func ff_frameTransform(x: CGFloat, y: CGFloat, width: CGFloat, heitgh: CGFloat, actualWidth: CGFloat = UIScreen.main.bounds.width, actualHeight: CGFloat = UIScreen.main.bounds.height, templateWidth:CGFloat = 375,  templateHeigh:CGFloat = 812) -> Array<CGFloat> {
    var actualFrame:[CGFloat] = []
    let actualX = actualWidth * (x / templateWidth)
    let actualY = actualHeight * (y / templateHeigh)
    let actualWidth = actualWidth * (width / templateWidth)
    let actualHeight = actualHeight * (heitgh / templateHeigh)
    
    actualFrame.append(actualX)
    actualFrame.append(actualY)
    actualFrame.append(actualWidth)
    actualFrame.append(actualHeight)
    return actualFrame
}

/// 根据模型的宽和屏幕的宽为比例换算，高参照宽。得到的是中心点和宽高
public func ff_widthScaleTransform(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, actualWidth: CGFloat = UIScreen.main.bounds.width, actualHeight: CGFloat = UIScreen.main.bounds.height, templateWidth:CGFloat = 375,  templateHeigh:CGFloat = 812) -> Array<CGFloat> {
    let widthWithHeitghScale = width / height
    var snpLaoutData:[CGFloat] = []
    let snpCenterX = actualWidth * (x + (width / 2)) / templateWidth
    let snpCenterY = actualHeight * (y + (height / 2)) / templateHeigh
    let snpSizeWidth = actualWidth * width / templateWidth
    let snpSizeHeight = snpSizeWidth / widthWithHeitghScale
    
    snpLaoutData.append(snpCenterX)
    snpLaoutData.append(snpCenterY)
    snpLaoutData.append(snpSizeWidth)
    snpLaoutData.append(snpSizeHeight)
    return snpLaoutData
}

/// 根据模型的高和屏幕的高为比例换算，宽参照高。得到的的是中心点和宽高
public func ff_heitghScaleTransform(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, actualWidth: CGFloat = UIScreen.main.bounds.width, actualHeight: CGFloat = UIScreen.main.bounds.height, templateWidth:CGFloat = 375,  templateHeight:CGFloat = 812) -> Array<CGFloat> {
    let widthWithHeitghScale = width / height
    var snpLaoutData:[CGFloat] = []
    let snpCenterX = actualWidth * (x + (width / 2)) / templateWidth
    let snpCenterY = actualHeight * (y + (height / 2)) / templateHeight
    let snpSizeHeight = actualHeight * height / templateHeight
    let snpSizeWidth = snpSizeHeight * widthWithHeitghScale
    
    snpLaoutData.append(snpCenterX)
    snpLaoutData.append(snpCenterY)
    snpLaoutData.append(snpSizeWidth)
    snpLaoutData.append(snpSizeHeight)
    return snpLaoutData

}

/// 获得宽高比例
public func ff_getWidthHeitghScale(w: CGFloat, h: CGFloat) -> CGFloat {
    return w / h
}

/// 获得高宽比例
public func ff_getHeightWidthScale(h: CGFloat, w: CGFloat) -> CGFloat {
    return h / w
}

/// 获取中心的Y，得到的比例之后的
public func ff_getCenterY(y: CGFloat, heifgh: CGFloat, templateHeigh: CGFloat = 812, screenH: CGFloat = UIScreen.main.bounds.height) -> CGFloat {
    let h = y + heifgh/2
    let centerY = h/templateHeigh * screenH
    return centerY
}

/// 获取中心点X，得到的是比例之后的
public func ff_getCenterX(x: CGFloat, width: CGFloat, templateWidth: CGFloat = 375, screenW: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
    let w = x + width/2
    let centerX = w/templateWidth * screenW
    return centerX
}


extension Int {
    /// 模型里面的宽换算到屏幕里
    func ff_widthTransform(templateWidth: CGFloat = 375) -> CGFloat {
        VV_screenWidth * (CGFloat(self) / templateWidth)
    }
    
    /// 模型里面的高换算到屏幕里
    func ff_heitghTransform(templateHeigh: CGFloat = 812) -> CGFloat {
        VV_screenHeight * (CGFloat(self) / templateHeigh)
    }
    
}
