//
//  FoodsList_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class FoodsList_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{

    
    public static var Add_New_Item = false;
    var Edit_Mode = true //0=hide_nav_btn    1=edit
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[1])")
    enum selectedScope:Int{
        case all = 0
        case food = 1
        case drink = 2
    }
    @IBOutlet weak var FoodsList_TableView: UITableView!
    @IBOutlet weak var Edit_Btn_Outlet: UIBarButtonItem!
    @IBOutlet weak var Add_Btn_Outlet: UIBarButtonItem!
    var FoodsOriginal = [Food]()
    @IBAction func Add_Btn_Action(_ sender: Any) {
        FoodsList_ViewController.Add_New_Item = true;
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_Edit_Food") as? newFood_ViewController{
            
            //viewController.newsObj = newsObj
            if let navigator = navigationController {
                indexSelected_foods = -1
                navigator.pushViewController(viewController, animated: true)
            }
        }

    }
 

    
    override func viewWillAppear(_ animated: Bool) {
        FoodsList_ViewController.Add_New_Item = false;
        reloadDbData()
        FoodsList_TableView.reloadData()
        
        FoodsOriginal = Foods
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        
        
        FoodsList_TableView.delegate = self
        FoodsList_TableView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        FoodsList_ViewController.Add_New_Item = false;
        
        if(Edit_Mode == false){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            Add_Btn_Outlet.isEnabled = false
            Add_Btn_Outlet.tintColor = UIColor.clear
            
        }
        else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = self.view.tintColor
            
            Add_Btn_Outlet.isEnabled = true
            Add_Btn_Outlet.tintColor = view.tintColor
        }

    }
    // MARK: *** SearchBar
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 34))
        searchBar.showsScopeBar = true
        //searchBar.scopeButtonTitles = ["Tất cả","Đã đặt","Chưa đặt"]
        searchBar.scopeButtonTitles = [NSLocalizedString("All", comment: " "),NSLocalizedString("Food", comment: " "),NSLocalizedString("Drink", comment: " ")]
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.selectedScopeButtonIndex = 0
        self.FoodsList_TableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterTableView(ind: selectedScope,searchText: searchBar.text!)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
        filterTableView(ind: searchBar.selectedScopeButtonIndex, searchText: nil)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        //self.searchDisplayController?.setActive(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(ind: searchBar.selectedScopeButtonIndex,searchText: searchBar.text)
    }
    func filterTableView(ind:Int,searchText: String?){
        switch ind {
        case selectedScope.all.rawValue:
            Foods = FoodsOriginal
        case selectedScope.food.rawValue:
            Foods = FoodsOriginal.filter({(mod) -> Bool in
                return mod.Loai == selectedScope.food.rawValue
            })
        case selectedScope.drink.rawValue:
            Foods = FoodsOriginal.filter({(mod) -> Bool in
                return mod.Loai == selectedScope.drink.rawValue
            })
        default:
            print("Search...")
        }
        if searchText != nil && searchText! != ""{
            Foods = Foods.filter({(mod) -> Bool in
                let x = String(mod.TenMon!).lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(String(mod.TenMon!).lowercased())
                let y = mod.MoTa!.lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(mod.MoTa!.lowercased())
                
                return (x || y)
            })
        }
        FoodsList_TableView.reloadData()
    }

    func reloadDbData(){
        
        Foods.removeAll()
        
        //sqlite
        database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        
        //Lay data
        let statement:OpaquePointer = Select(query: "SELECT * FROM MonAn", database: database!)
        
        // Do du lieu vao mang
        while sqlite3_step(statement) == SQLITE_ROW {
            // Do ra tung cot tuong ung voi no
            let food = Food()
            
            if(sqlite3_column_text(statement, 0) != nil)
            {
                food.MaMon = Int(sqlite3_column_int(statement, 0))
                if(sqlite3_column_text(statement, 1) != nil)
                {
                    food.TenMon = String(cString: sqlite3_column_text(statement, 1))
                }
                if(sqlite3_column_text(statement, 2) != nil)
                {
                    food.Gia = Double(sqlite3_column_double(statement, 2))
                }
                if(sqlite3_column_text(statement, 3) != nil)
                {
                    food.HinhAnh = String(cString: sqlite3_column_text(statement, 3))
                    
                }
                if(sqlite3_column_text(statement, 3) != nil)
                {
                    food.HinhAnh = String(cString: sqlite3_column_text(statement, 3))
                }
                if(sqlite3_column_text(statement, 4) != nil)
                {
                    food.MoTa = String(cString: sqlite3_column_text(statement, 4))
                }
                if(sqlite3_column_text(statement, 5) != nil)
                {
                    food.Loai = Int(sqlite3_column_int(statement, 5))
                }
                if(sqlite3_column_text(statement, 6) != nil)
                {
                    food.Icon = String(cString: sqlite3_column_text(statement, 6))
                }
            }
            
            Foods.append(food)
            
            //let rowData = sqlite3_column_text(statement, 1)
            // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
            //let fieldValue = String(cString: rowData!)
            // Them Vao mang da co
            //mang.append(fieldValue!)
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Foods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodCell_TableViewCell
        
        let sPrice =  Foods[indexPath.row].Gia!.getCurrencyValue(Currency: Currency)
        
        cell.Name.text = Foods[indexPath.row].TenMon
        cell.Price.text = sPrice.0.toCurrencyString(Currency: Currency) + sPrice.1
        cell.Description.text = Foods[indexPath.row].MoTa
        
        let ImgURL = localURL.appendingPathComponent(Foods[indexPath.row].HinhAnh!)
        cell._Image.image = UIImage(contentsOfFile: ImgURL.path)  ?? #imageLiteral(resourceName: "Image-Not-Found-icon")
        
        return cell
    }
    
    //select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if FoodsList_TableView.isEditing == true
        {
            //if Area_TableViewController.Edit_Mode == true {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_Edit_Food") as? newFood_ViewController
            {
                //viewController.newsObj = newsObj
                if let navigator = navigationController {
                    indexSelected_foods = indexPath.row;
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        }
        else{
            if Edit_Mode == false // on
            {
                database = Connect_DB_SQLite(dbName: DBName, type: DBType)
                if(Tables[indexSelected_tables].MaHD == nil){//Chưa có hóa đơn
                    var strQuery = "INSERT INTO HoaDon VALUES (null, " + "datetime('now', 'localtime')" + ",\(Tables[indexSelected_tables].SoBan!)" + ", 0)"
                    print(strQuery)
                    Query(sql: strQuery, database: database!)
                    
                    let bill = Bill()
                    //sqlite
                    
                    
                    let statement:OpaquePointer = Select(query: "SELECT LAST_INSERT_ROWID() FROM HoaDon", database: database!)
                    
                    if sqlite3_step(statement) == SQLITE_ROW {
                        // Do ra tung cot tuong ung voi no
                        
                        
                        if(sqlite3_column_text(statement, 0) != nil)
                        {
                            bill.MaHD = Int(sqlite3_column_int(statement, 0))
                        }
                    }
                    
                    sqlite3_finalize(statement)
                    
                    //set MaHD cho BanAn
                    strQuery = "UPDATE BanAn SET MaHD = \(bill.MaHD!) WHERE SoBan = \(Tables[indexSelected_tables].SoBan!)"
                    Query(sql: strQuery, database: database!)
                    Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
                    
                }
                if(Tables[indexSelected_tables].MaHD != nil){// ban co ma hoa don (Da dat mon)
                    //Kiểm tra món đó đã có trong hóa đơn chưa (có thì + 1 SL, không thì thêm)
                    let str = "SELECT * FROM MonAn NATURAL JOIN (SELECT * FROM ChiTietHoaDon WHERE MaHD = \(Tables[indexSelected_tables].MaHD!)) WHERE MaMon = \(Foods[indexPath.row].MaMon!)"
                    var Foods_temp = [Food]()
                    Foods_temp = GetFoodsFromSQLite(query: str)
                    
                    if(Foods_temp.count != 0){//Món vừa chọn đã có trong hóa đơn
                        Foods_temp[0].SoLuong = Foods_temp[0].SoLuong! + 1
                        let strQuery = "UPDATE ChiTietHoaDon SET SoLuong = \( Foods_temp[0].SoLuong!) WHERE MaHD = \(Tables[indexSelected_tables].MaHD!) AND MaMon = \(Foods[indexPath.row].MaMon!)"
                        Query(sql: strQuery, database: database!)
                    }
                    else{//thêm mới
                        //add
                        sqlite3_close(database)
                        database = Connect_DB_SQLite(dbName: DBName, type: DBType)
                        let strQuery = "INSERT INTO ChiTietHoaDon VALUES (\(Tables[indexSelected_tables].MaHD!)" + ", \(Foods[indexPath.row].MaMon!)" + ", 1)"
                        Query(sql: strQuery, database: database!)

                    }
                    
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
    }
    //edit
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none//không cho vuốt để xóa
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            
            let str = "DELETE FROM MonAn WHERE MaMon=" + "\(Foods[indexPath.row].MaMon!)"
            Query(sql: str, database: database!)
            
            sqlite3_close(database)
            
            Foods.remove(at: indexPath.row)
            
            sqlite3_close(database)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.FoodsList_TableView.setEditing(editing, animated: animated)
    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
