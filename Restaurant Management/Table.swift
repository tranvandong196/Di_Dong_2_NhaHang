//
//  Table.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

class Table{
    var SoBan:Int!
    var TinhTrang:Int!
    var HinhAnh:String!
    var GhiChu:String?
    var MaKV:Int!
    var MaHD:Int?
    
    init(SoBan:Int,TinhTrang:Int,HinhAnh:String,GhiChu:String,MaKV:Int,MaHD:Int) {
        self.SoBan = SoBan
        self.TinhTrang = TinhTrang
        self.HinhAnh = HinhAnh
        self.GhiChu = GhiChu
        self.MaKV = MaKV
        self.MaHD = MaHD
        //update(SoBan: SoBan, TinhTrang: TinhTrang, HinhAnh: HinhAnh, GhiChu: GhiChu, MaKV: MaKV, MaHD: MaHD)
    }
    init(){
        
    }
    func update(SoBan:Int,TinhTrang:Int,HinhAnh:String,GhiChu:String,MaKV:Int,MaHD:Int) {
        self.SoBan = SoBan
        self.TinhTrang = TinhTrang
        self.HinhAnh = HinhAnh
        self.GhiChu = GhiChu
        self.MaKV = MaKV
        self.MaHD = MaHD
    }
}
