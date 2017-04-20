//
//  FoodsList_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class FoodsList_ViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate{

    public static var listFoods = [Food]()
    
    public static var Add_New_Item = false;
    public static var Edit_Item_Index = -1;
    var Edit_Mode = true //0=hide_nav_btn    1=edit
    var listFoodTypes:[String]! = ["Tất cả", "Đồ ăn", "Đồ uống"]
    
    
    @IBOutlet weak var pickerFoodType: UIPickerView!
    @IBOutlet weak var FoodsList_TableView: UITableView!
    @IBOutlet weak var Edit_Btn_Outlet: UIBarButtonItem!
    @IBOutlet weak var Add_Btn_Outlet: UIBarButtonItem!
 
    @IBAction func Add_Btn_Action(_ sender: Any) {
        FoodsList_ViewController.Add_New_Item = true;
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_Edit_Food") as? newFood_ViewController{
            
            //viewController.newsObj = newsObj
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }

    }
 

    
    override func viewWillAppear(_ animated: Bool) {
        FoodsList_ViewController.Add_New_Item = false;
        FoodsList_ViewController.Edit_Item_Index = -1;
        reloadDbData()
        FoodsList_TableView.reloadData()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerFoodType.delegate=self
        pickerFoodType.dataSource=self
        
        
        FoodsList_TableView.delegate = self
        FoodsList_TableView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        FoodsList_ViewController.Add_New_Item = false;
        FoodsList_ViewController.Edit_Item_Index = -1;
        
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
    
    func reloadDbData(){
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "pickerViewRow") != nil)
        {
            pickerFoodType.selectRow(0, inComponent: 0, animated: true)
        }
        
        FoodsList_ViewController.listFoods.removeAll()
        
        //sqlite
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        
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
            
            FoodsList_ViewController.listFoods.append(food)
            
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listFoodTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listFoodTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str:String
        if row == 0{//select all
            str = "SELECT * FROM MonAn"
        }
        else{
            str = "SELECT * FROM MonAn WHERE Loai = " + "\(row)"
        }
        
        //sqlite
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        
        
        FoodsList_ViewController.listFoods.removeAll()
        
        
        
        //Lay data
        let statement:OpaquePointer = Select(query: str, database: database!)
        
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
            
            FoodsList_ViewController.listFoods.append(food)
            
            //let rowData = sqlite3_column_text(statement, 1)
            // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
            //let fieldValue = String(cString: rowData!)
            // Them Vao mang da co
            //mang.append(fieldValue!)
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        FoodsList_TableView.reloadData()

    }

    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodsList_ViewController.listFoods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodCell_TableViewCell
        
        cell.Name.text = FoodsList_ViewController.listFoods[indexPath.row].TenMon
        cell.Price.text = String(format:"%.1f", FoodsList_ViewController.listFoods[indexPath.row].Gia)
        cell.Description.text = FoodsList_ViewController.listFoods[indexPath.row].MoTa
        cell._Image.image = UIImage(named: FoodsList_ViewController.listFoods[indexPath.row].HinhAnh)
        
        return cell
    }
    
    //select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.isEditing == true
        {
            //if Area_TableViewController.Edit_Mode == true {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_Edit_Food") as? newFood_ViewController
            {
                //viewController.newsObj = newsObj
                if let navigator = navigationController {
                    
                    FoodsList_ViewController.Edit_Item_Index = indexPath.row;
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        }
        else{
            if Edit_Mode == false
            {
                //updateRow(Tables[indexSelected_tables])
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
        
        return .none
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
//            
//            let str = "DELETE FROM KhuVuc WHERE MaKV=" + "\(Area_TableViewController.listArea[indexPath.row].MaKV!)"
//            Query(sql: str, database: database!)
//            
//            sqlite3_close(database)
//            
//            Area_TableViewController.listArea.remove(at: indexPath.row)
//            
//            sqlite3_close(database)
//            tableView.deleteRows(at: [indexPath], with: .fade)
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
