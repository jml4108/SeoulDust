//
//  DustData.swift
//  dustLjm
//
//  Created by 이정민 on 2021/09/05.
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
    let khaiGrade   : String
    let stationName : String
    let pm10Value   : String
    let pm10Grade   : String
}
