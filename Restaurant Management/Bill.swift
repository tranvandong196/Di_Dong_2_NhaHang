//
//  Bill_detail.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
struct Detail{
    var MaMon:Int?
    var SoLuong:Int!
}
class Bill{
    var MaHD: Int?
    var ThoiGian:Date!
    var SoBan:Int!
    var ThanhTien:Double!
    var Bill_details:[Detail]!
    
//    func update(MaHD: Int,ThoiGian:Date,SoBan:Int,Bill_details:[Detail]){
//        MaHD
//    }
    init(){
        
    }
}
