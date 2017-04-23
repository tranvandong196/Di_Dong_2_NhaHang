//
//  Area.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
class Area{
    var MaKV:Int!
    var TenKV:String!
    var MoTa:String!
    var HinhAnh:String!
    
    init(MaKV:Int,TenKV:String, MoTa:String,HinhAnh:String) {
        update(MaKV: MaKV, TenKV: TenKV, MoTa: MoTa, HinhAnh: HinhAnh)
    }
    func update(MaKV:Int,TenKV:String, MoTa:String,HinhAnh:String){
        self.MaKV = MaKV
        self.TenKV = TenKV
        self.MoTa = MoTa
        self.HinhAnh = HinhAnh
    }
    init(){
        
    }
}
