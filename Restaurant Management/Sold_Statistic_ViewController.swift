    //
    //  Revenue_ViewController.swift
    //  Restaurant Management
    //
    //  Created by Windy on 4/27/17.
    //  Copyright © 2017 Tran Van Dong. All rights reserved.
    //
    
    import UIKit
    
    class Sold_Statistic_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{//.....
        
        @IBOutlet weak var datePickerTxt: UITextField!
        
        
        @IBOutlet weak var datePicker1Txt: UITextField!
        
        
        let datePicker = UIDatePicker()
        let datePicker1 = UIDatePicker()
        
        var date1 = String("")
        var date2 = String("")
        
        @IBOutlet weak var myTableView: UITableView!
        
        var foodsDeTail_List = [Detail()]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            myTableView.delegate = self
            myTableView.dataSource = self
            
            foodsDeTail_List.removeAll()
            database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            
            createDatePicker()
            createDatePicker1()
        }
        // tạo chọn ngày: Từ ngày
        func createDatePicker()
        {
            // format for picker
            datePicker.datePickerMode = .date
            
            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: false)
            
            datePickerTxt.inputAccessoryView = toolbar
            datePickerTxt.inputView = datePicker
            
        }
        
        // tạo chọn ngày: Tới ngày
        func createDatePicker1()
        {
            // format for picker
            datePicker1.datePickerMode = .date
            
            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed1))
            toolbar.setItems([doneButton], animated: false)
            
            datePicker1Txt.inputAccessoryView = toolbar
            datePicker1Txt.inputView = datePicker
            
        }
        
        // nút done 1
        func donePressed()
        {
            // format date
            let dateFormattor = DateFormatter()
            
            dateFormattor.dateFormat = "yyyy-MM-dd"
            
            //        dateFormattor.dateStyle = .long
            //        dateFormattor.timeStyle = .none
            
            datePickerTxt.text = dateFormattor.string(from: datePicker.date)
            date1 = dateFormattor.string(from: datePicker.date)
            
            showRevenue()
            
            self.view.endEditing(true)
        }
        
        // nút done 2
        func donePressed1()
        {
            // format date
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            
            //dateFormattor.dateStyle = .medium
            //dateFormattor.timeStyle = .none
            datePicker1Txt.text = dateFormattor.string(from: datePicker.date)
            date2 = dateFormattor.string(from: datePicker.date)
            
            showRevenue()
            
            self.view.endEditing(true)
        }
        
        func showRevenue() -> Bool {
            
            if(date1 != "" || date2 != ""){//Đã chọn 1 trong 2 mốc date
                
                
                if (date1 == ""){
                    date1 = date2
                }
                else{
                    if(date2 == ""){
                        date2 = date1
                    }
                }
                
                
                if (date1! > date2!){
                    let dateTemp = date1
                    date1 = date2
                    date2 = dateTemp
                    
                }
                
                date2 =  date2! + " 23:59:59"
                //sqlite
                
                
                foodsDeTail_List.removeAll()
                
                let str = "Select * From (SELECT MaMon, Sum(SoLuong) FROM ChiTietHoaDon NATURAL JOIN (SELECT * FROM HoaDon WHERE ThanhTien > 0 And ThanhTien != \"\") Where ThoiGian Between '" + date1! + "' AND '" + date2! + "' GROUP BY MaMon ORDER BY  Sum(SoLuong) DESC) NATURAL JOIN  (Select MaMon, TenMon From MonAn)"
                
                print(str)
                //Lay data
                let statement:OpaquePointer = Select(query: str, database: database!)
                // Do du lieu vao mang
                while sqlite3_step(statement) == SQLITE_ROW {
                    // Do ra tung cot tuong ung voi no
                    var detail = Detail()
                    
                    if(sqlite3_column_text(statement, 0) != nil)//Mã Món
                    {
                        detail.MaMon = Int(sqlite3_column_int(statement, 10))
                        if(sqlite3_column_text(statement, 1) != nil)
                        {
                            detail.SoLuong = Int(sqlite3_column_int(statement, 1))//Số lượng
                        }
                        if(sqlite3_column_text(statement, 2) != nil)
                        {
                            detail.TenMon = String(cString: sqlite3_column_text(statement, 2))//Tên Món
                        }
                    }
                    foodsDeTail_List.append(detail)
                }
                sqlite3_finalize(statement)
                myTableView.reloadData()
                return true
            }
            
            return false
        }
        
        //Các hàm hỗ trợ table view
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return foodsDeTail_List.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! foodStatistic
            
            cell.FoodNameTxt.text = foodsDeTail_List[indexPath.row].TenMon
            cell.SoLuongTxt.text = "(" + "\(foodsDeTail_List[indexPath.row].SoLuong!)" + ")"
            return cell
        }
        
        
}

    class foodStatistic: UITableViewCell {
        
        @IBOutlet weak var FoodNameTxt: UILabel!
        @IBOutlet weak var SoLuongTxt: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
    }
