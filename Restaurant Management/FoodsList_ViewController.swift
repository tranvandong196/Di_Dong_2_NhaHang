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
    
    var listFoodTypes:[String]! = ["Tất cả", "Đồ ăn", "Đồ uống"]
    
    
    @IBOutlet weak var pickerFoodType: UIPickerView!
    @IBOutlet weak var FoodsList_TableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerFoodType.delegate=self
        pickerFoodType.dataSource=self
        
        
        FoodsList_TableView.delegate = self
        FoodsList_TableView.dataSource = self
        
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
