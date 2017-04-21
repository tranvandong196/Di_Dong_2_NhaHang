//
//  SQLite.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
import  UIKit
// MARK: *** Global Variable

var database:OpaquePointer?

var Tables = [Table]()
var Foods = [Food]()
var Areas = [Area]()

var Parent_dir_data:String = "Resources"
var Sub_folder_data:[String] = ["Table","Food","Area"]
let DBName = "QuanLyNhaHang"
let DBType = "sqlite"

// MARK: *** SQLite3 function
//Database pointer
func Connect_DB_SQLite( dbName:String, type:String)->OpaquePointer{
    var database:OpaquePointer? = nil
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let storePath : String = documentURL.appendingPathComponent("\(dbName).\(type)").path
    let dbPath = Bundle.main.path(forResource: dbName , ofType:type)!
    do {
        try FileManager.default.copyItem(atPath: dbPath, toPath: storePath)
    } catch{
        //print("File exists! Can not copy file")
    }
    if sqlite3_open(storePath, &database) == SQLITE_OK{
        print("Opened < \(dbName).\(type) > from storePath")
    }else{
        sqlite3_close(database)
        print("Failed to open database -> Created \(dbName).\(type) but it wasn't set a valid structure/table!")
        //createdTable(database: database, query: String) to create any table
    }
    //print("\nDatabase has been stored at: \(storePath)\n")
    return database!
}
func createTable(database: OpaquePointer?,query: String) {
    var statement : OpaquePointer?
    if sqlite3_prepare_v2(database, query,-1, &statement, nil) == SQLITE_OK{
        if sqlite3_step(statement) == SQLITE_DONE{
            print("Table created!")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
        }
    }else{
        let errmsg = String(cString: sqlite3_errmsg(database))
        print(errmsg)
    }
}
func edit(query: String)-> Bool{
    var result:Bool = false
    var insertStatement : OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &insertStatement, nil) == SQLITE_OK{
        if sqlite3_step(insertStatement) == SQLITE_DONE{
            result = true
        }else{
            result = false
        }
    }else{
        print("Edit statement could not be prepared.")
        result = false
    }
    sqlite3_finalize(insertStatement)
    return result
}

// MARK: *** Tran Van Dong
func GetTablesFromSQLite(query: String) -> [Table]{
     database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    var Tables = [Table]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
             let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
            let SoBan = Int(sqlite3_column_int(queryStatement, 0))
            let TinhTrang = Int(sqlite3_column_int(queryStatement, 1))
            let HinhAnh = String(cString: queryResultCol2!)
            let GhiChu = String(cString: queryResultCol3!)
            let MaKV = Int(sqlite3_column_int(queryStatement, 4))
            let MaHD = Int(sqlite3_column_int(queryStatement, 5))
            let table = Table(SoBan: SoBan, TinhTrang: TinhTrang, HinhAnh: HinhAnh, GhiChu: GhiChu, MaKV: MaKV, MaHD: MaHD)
            Tables.append(table)
            //print("Query result: \(mssv): \(fname) \(lname) - \(classID) - \(birthday) - \(otherInfo)")

        }
    }
    sqlite3_close(database)
    return Tables
}
func GetFoodsFromSQLite(query: String) -> [Food]{
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    var Foods = [Food]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            let MaMon = Int(sqlite3_column_int(queryStatement, 0))
            let TenMon = String(cString: sqlite3_column_text(queryStatement, 1))
            let Gia = Double(sqlite3_column_double(queryStatement, 2))
            let HinhAnh = String(cString: sqlite3_column_text(queryStatement, 3))
            let MoTa = String(cString: sqlite3_column_text(queryStatement, 4))
             let Loai = Int(sqlite3_column_int(queryStatement, 5))
            let Icon = String(cString: sqlite3_column_text(queryStatement, 6))
            let food = Food(MaMon: MaMon, TenMon: TenMon, Gia: Gia, HinhAnh: HinhAnh, MoTa: MoTa, Loai: Loai, Icon: Icon)
            Foods.append(food)
            //print("Query result: \(mssv): \(fname) \(lname) - \(classID) - \(birthday) - \(otherInfo)")
            
        }
    }
    sqlite3_close(database)
    return Foods
}

func GetAreasFromSQLite(query: String) -> [Area]{
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    var Areas = [Area]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            let MaKV = Int(sqlite3_column_int(queryStatement, 0))
            let TenKV = String(cString: sqlite3_column_text(queryStatement, 1))
            
            let MoTa = String(cString: sqlite3_column_text(queryStatement, 2))
            let HinhAnh = String(cString: sqlite3_column_text(queryStatement, 3))
            let area = Area(MaKV: MaKV, TenKV: TenKV, MoTa: MoTa, HinhAnh: HinhAnh)
            Areas.append(area)
            //print("Query result: \(mssv): \(fname) \(lname) - \(classID) - \(birthday) - \(otherInfo)")
        }
    }
    sqlite3_close(database)
    return Areas
}
func GetKindsFromSQLite(query: String) -> [Kind]{
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    var Kinds = [Kind]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            let Ma = Int(sqlite3_column_int(queryStatement, 0))
            let Ten = String(cString: sqlite3_column_text(queryStatement, 1))
            Kinds.append(Kind(Ma: Ma,Ten: Ten))
        }
    }
    sqlite3_close(database)
    return Kinds
}
func addRow(_ T: Table){
     database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    let query = "INSERT INTO BanAn VALUES(\(T.SoBan!),\(T.TinhTrang!),'\(T.HinhAnh!)','\(T.GhiChu!)',\(T.MaKV!),\(T.MaHD!))"
    print(query)
    if edit(query: query){
        print("Thêm bàn số \(T.SoBan!)")
    }else{
        print("Không thể thêm bàn số \(T.SoBan!)")
    }
    sqlite3_close(database)
}
func addRow(_ F: Food){
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    let query = "INSERT INTO MonAn VALUES(null,'\(F.TenMon!)', \(F.Gia!), '\(F.HinhAnh!)','\(F.MoTa!)', \(F.Loai!), '\(F.Icon!)')"
    print(query)
    if edit(query: query){
        print("Thêm món: \(F.TenMon!)")
    }else{
        print("Không thể thêm món: \(F.TenMon!)")
    }
    sqlite3_close(database)
}
func updateRow( _ T: Table){
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    let query = "UPDATE BanAn SET TinhTrang = \(T.TinhTrang!), HinhAnh = '\(T.HinhAnh!)', GhiChu = '\(T.GhiChu!)', MaKV = \(T.MaKV!), MaHD = \(T.MaHD!) WHERE SoBan = \(T.SoBan!)"
    print(query)
    if edit(query: query){
        print("Cập nhât bàn số \(T.SoBan!)")
    }else{
        print("Không thể cập nhật bàn số \(T.SoBan!)")
    }
    sqlite3_close(database)
}
func updateRow( _ F: Food){
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    let query = "UPDATE MonAn SET TenMon = '\(F.TenMon!)', Gia = \(F.Gia!), HinhAnh = '\(F.HinhAnh!)', MoTa = '\(F.MoTa!)', Loai = \(F.Loai!), Icon = '\(F.Icon!)' WHERE MaMon = \(F.MaMon!)"
    print(query)
    if edit(query: query){
        print("Cập nhât món: \(F.TenMon!)")
    }else{
        print("Không thể cập nhật món:  \(F.TenMon!)")
    }
    sqlite3_close(database)
}
func createDirectoryStoreData(ParentDir: String,SubFolder:[String]) -> Bool{
    let fileManager = FileManager.default
    let ParentDirURL = DocURL().appendingPathComponent(ParentDir)
    print("\nDataStoreURL: \(ParentDirURL.path)\n")
    
    if !fileManager.fileExists(atPath: ParentDirURL.path){
        // Tạo các thư mục chứa data vào DocURL
        fileManager.createDirectory(at: DocURL(), withName: ParentDir)
        for i in 0..<SubFolder.count{
            fileManager.createDirectory(at: ParentDirURL, withName: SubFolder[i])
        }
        return true
    }else{
        print("Directory Database is exists!")
        return false
    }
    
}
func copyDataToDocumentURL(ParentDir: String,SubFolder:[String]){
    let ParentDirURL = DocURL().appendingPathComponent(ParentDir)
    let result = createDirectoryStoreData(ParentDir: Parent_dir_data,SubFolder: Sub_folder_data)
    if result{
        Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        Areas = GetAreasFromSQLite(query: "SELECT * FROM KhuVuc")
        for i in 0..<Tables.count{
            let iName:String = Tables[i].HinhAnh
            let img:UIImage = UIImage(named: iName) ?? #imageLiteral(resourceName: "Ban")
            img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[0]), name: iName)
        }
        for i in 0..<Foods.count{
            let imName:String = Foods[i].HinhAnh
            let icName:String = Foods[i].Icon
            let img:UIImage = UIImage(named: imName) ?? #imageLiteral(resourceName: "Not-Found-icon")
            let icon:UIImage = UIImage(named: icName) ?? #imageLiteral(resourceName: "Not-Found-icon")
            img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[1]), name: imName)
            icon.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[1]), name: icName)
        }
        for i in 0..<Areas.count{
            let iName:String = Areas[i].HinhAnh
            let img:UIImage = UIImage(named: Areas[i].HinhAnh) ?? #imageLiteral(resourceName: "tang1")
            img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[2]), name: iName)
        }
    }
    

    
}
//func saveImageToDir(image: UIImage,at: URL,name: String){
//    do{
//        
//        if name.characters.count == name.trim(".png").characters.count + 3{
//            try UIImagePNGRepresentation(image)?.write(to: ParentDirURL.appendingPathComponent("/Area/" + name))
//        }else{
//            try UIImageJPEGRepresentation(img, 1.0)?.write(to: ParentDirURL.appendingPathComponent("/Area/" + iName))
//        }
//    }catch{
//        print("Can not save image: \(iName)")
//    }
//}
// END DONG

//====================Nguyễn Đình Sơn

//SQLITE func

func Select( query:String, database:OpaquePointer)->OpaquePointer{
    var statement:OpaquePointer? = nil
    sqlite3_prepare_v2(database, query, -1, &statement, nil)
    return statement!
}

func Query( sql:String, database:OpaquePointer){
    var errMsg:UnsafeMutablePointer<Int8>? = nil
    let result = sqlite3_exec(database, sql, nil, nil, &errMsg);
    
    
    print(sql)
    if (result != SQLITE_OK) {
        sqlite3_close(database)
        print("Cau truy van bi loi!")
        return
    }
}


//====================Nguyễn Đình Sơn

//func insert_row(stu: Studentx) -> Bool {
//    let bd: String = dateFormatter.string(from: stu.m_birthday)
//    let query = "INSERT INTO Student(mssv,firstName,lastName,classID,birthday,otherInfo) VALUES (\(stu.m_mssv!),'\(stu.m_fName!)','\(stu.m_lName!)','\(stu.m_classID!)','\(bd)','\(stu.m_otherInfo!)')"
//    return edit(query: query)
//}
//func delete_row(stu: Studentx) -> Bool {
//    let query = "DELETE FROM Student WHERE mssv = \(stu.m_mssv!)"
//    return edit(query: query)
//}
//func update_row(stu: Studentx) -> Bool {
//    let bd = dateFormatter.string(from: stu.m_birthday)
//    let query = "UPDATE Student SET firstName = '\(stu.m_fName!)', lastName = '\(stu.m_lName!)', classID = '\(stu.m_classID!)', birthday = '\(bd)', otherInfo = '\(stu.m_otherInfo!)' WHERE mssv = \(stu.m_mssv!)"
//    return edit(query: query)
//}

//func GetdataFromSQLite(query: String) -> [Studentx]{
//    var Studentsx = [Studentx]()
//    var queryStatement:OpaquePointer? = nil
//    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
//        while sqlite3_step(queryStatement) == SQLITE_ROW{
//            let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
//            let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
//            let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
//            let queryResultCol4 = sqlite3_column_text(queryStatement,4)
//            let queryResultCol5 = sqlite3_column_text(queryStatement,5)
//            let mssv = Int(sqlite3_column_int(queryStatement, 0))
//            let fname = String(cString: queryResultCol1!)
//            let lname = String(cString: queryResultCol2!)
//            let classID = String(cString: queryResultCol3!)
//            let birthday = String(cString: queryResultCol4!)
//            let otherInfo = String(cString: queryResultCol5!)
//            let stu = Studentx(mssv: mssv, firstName: fname,lastName: lname,classID: classID,birthday: birthday,otherInfo: otherInfo)
//            Studentsx.append(stu)
//            if MSSV_last <= mssv{
//                MSSV_last = mssv
//            }
//            //print("Query result: \(mssv): \(fname) \(lname) - \(classID) - \(birthday) - \(otherInfo)")
//            
//        }
//    }
//    if Studentsx.count != 0{
//        MSSV_last = Studentsx[Studentsx.count - 1].m_mssv
//    }
//    return Studentsx
//}
//func updateData() {
//    Studentsx.removeAll()
//    Studentsx = GetdataFromSQLite(query: "SELECT* FROM Student")
//    print("Data updated")
//}
