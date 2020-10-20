//
//  FF_JsonCodable.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/14.
//

import Foundation

struct FF_JsonResult: Codable {
    
    var code: Int
    var data: FF_Data
    var message: String

}

struct FF_JsonList: Codable {
    var image_id: Int
    var image_source_url: String
    var image_description: String
    
}

struct FF_Data: Codable {
    var list: [FF_JsonList]
    var current: Int
    var counts: Int
    var pageTotal: Int
}

