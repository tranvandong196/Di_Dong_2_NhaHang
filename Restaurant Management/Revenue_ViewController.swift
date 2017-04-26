//
//  Revenue_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/27/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class Revenue_ViewController: UIViewController {

    @IBOutlet weak var datePickerTxt: UITextField!
    
    
    @IBOutlet weak var datePicker1Txt: UITextField!
    
    @IBOutlet weak var Result_txt: UILabel!
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    var date1 = String("")
    var date2 = String("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
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
                date2 = date1
            }
            
            
            if (date1! > date2!){
                let dateTemp = date1
                date1 = date2
                date2 = dateTemp
            }
            
            date2 =  date2! + " 23:59:59"
            //sqlite
            
            
            //Bills.removeAll()
            
            let str = "Select * From HoaDon Where ThoiGian >= '" + date1! + "' AND ThoiGian <= '" + date2! + "'"
            print(str)
            //Lay data
            let statement:OpaquePointer = Select(query: str, database: database!)
            var Result = Double()
            // Do du lieu vao mang
            while sqlite3_step(statement) == SQLITE_ROW {
                // Do ra tung cot tuong ung voi no
                
                if(sqlite3_column_text(statement, 0) != nil)//có mã hóa đơn
                {
                    if(sqlite3_column_text(statement, 3) != nil)
                    {
                        Result = Result + Double(sqlite3_column_double(statement, 3))//chỉ cần lấy tổng tiền
                    }
                }
                
                
                //let rowData = sqlite3_column_text(statement, 1)
                // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
                //let fieldValue = String(cString: rowData!)
                // Them Vao mang da co
                //mang.append(fieldValue!)
            }
            sqlite3_finalize(statement)
            let p = Result.getCurrencyValue(Currency: Currency)
            Result_txt.text = p.0.toCurrencyString(Currency: Currency) + p.1
            return true
        }
    
        Result_txt.text = "-"
        return false
    }
}
