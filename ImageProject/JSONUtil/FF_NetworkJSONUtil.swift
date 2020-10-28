//
//  FF_JsonCodable.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/14.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FF_Link {
    static func ff_dacodeImageCollectJsonData(domain: String, parameters: [String: Int], cb: @escaping(_ iamgepath: [String], _ coverPath: [String], _ pageTotal: Int, _ idAY: [Int], _ nameAY: [String], _ lbAY: [String] ) -> Void, failure: @escaping() -> Void) {
        print(domain)
        var lbArr: [String] = []
        var iamgePathArray: [String] = []
        var coverPathArray: [String] = []
        var pageTotal = 0
        var idArr: [Int] = []
        var naArr: [String] = []
        AF.request(domain, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, requestModifier: {$0.timeoutInterval = 5}).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                if let allPagr = json["data"]["pageTotal"].int{
                    pageTotal = allPagr
                }
                if let list = json["data"]["list"].array {
                    for dexc in 0 ..< list.count{
                        if let str = list[dexc]["image_source_url"].string {
                            iamgePathArray.append(str)
                        }
                        if let str = list[dexc]["cover_source_url"].string {
                            coverPathArray.append(str)
                        }
                        if let b = list[dexc]["id"].int{
                            idArr.append(b)
                        }
                        if let c = list[dexc]["name"].string{
                            naArr.append(c)
                        }
                        if let d = list[dexc]["tag"][0]["label"].string{
                            lbArr.append(d)
                        }
                    }
                }
                cb(iamgePathArray, coverPathArray, pageTotal, idArr, naArr, lbArr)
            case .failure(let enrro):
                failure()
                debugPrint(enrro)
            }
        }
    }
    
    static func ff_creatSaveImagePathDocument() {
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
    
    static func ff_getDickImagePathArr() -> [String] {
        let vv_imageDocumentsPath = NSHomeDirectory()+"/Documents" + "/image.text"
        let url = URL(fileURLWithPath: vv_imageDocumentsPath)
        let JSONdata = try! Data(contentsOf: url)
        let iamgePathArr = try! JSONSerialization.jsonObject(with: JSONdata, options: .mutableContainers) as! NSArray as! Array<String>
        return iamgePathArr
    }
    
    static func ff_numberSort(end: Int) -> [Int] {
          var startArr = Array(1...end)
        var resultArr = Array(repeating: 0, count: end)
          for i in 0..<startArr.count {
              let currentCount = UInt32(startArr.count - i)
              let index = Int(arc4random_uniform(currentCount))
              resultArr[i] = startArr[index]
              startArr[index] = startArr[Int(currentCount) - 1]
          }
          return resultArr
      }
    
    static func numberPro(start: Int, end: Int) -> [Int] {
        let scope = end - start
        var startArr = Array(1...scope)
        var resultArr = Array(repeating: 0, count: scope)
        for i in 0..<startArr.count {
            let currentCount = UInt32(startArr.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[Int(currentCount) - 1]
        }
        return resultArr.map { $0 + start }
    }

}

