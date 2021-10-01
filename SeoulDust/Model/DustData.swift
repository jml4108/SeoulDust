//
//  DustData.swift
//  SeoulDust
//
//  Created by jmlee on 2021/09/05.
//

import Foundation

struct DustData : Codable {
    let response : Response
}
struct Response : Codable {
    let body : Body
}
struct Body : Codable {
    let items : [Items]
}
struct Items : Codable {
    let pm10Value   : String?
    let stationName : String?
    let pm10Grade   : String?
    let khaiGrade   : String?
}
