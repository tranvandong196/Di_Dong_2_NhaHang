//
//  Food.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
class Food{
    var MaMon:Int?
    var TenMon:String!
    var Gia:Double!
    var HinhAnh:String!
    var MoTa:String!
    var Loai:Int!
    var Icon:String!
    init(MaMon:Int,TenMon:String,Gia:Double,HinhAnh:String,MoTa:String,Loai:Int,Icon:String) {
        update(MaMon: MaMon, TenMon: TenMon, Gia: Gia, HinhAnh: HinhAnh, MoTa: MoTa, Loai: Loai, Icon: Icon)
    }
    func update(MaMon:Int,TenMon:String,Gia:Double,HinhAnh:String,MoTa:String,Loai:Int,Icon:String) {
        self.MaMon = MaMon
        self.TenMon = TenMon
        self.Gia = Gia
        self.HinhAnh = HinhAnh
        self.MoTa = MoTa
        self.Loai = Loai
        self.Icon = Icon
    }
}
