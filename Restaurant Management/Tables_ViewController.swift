//
//  Tables_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/15/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
var indexSelected_tables = 0
var isAdded:Bool = false

class Tables_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Tables_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Tables_TableView.delegate = self
        Tables_TableView.dataSource = self
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
        Tables_TableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewTable_Button(_ sender: Any) {
        isAdded = true
        
        print("isAdded: \(isAdded)")
        pushToVC(withIdentifier: "table_detail")
        //moveToVC(withIdentifier: "table_detail", animated: true)
    }
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tables.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_table", for: indexPath) as! Table_TableViewCell
        cell.TableName_Label.text = "Bàn số \(Tables[indexPath.row].SoBan!)"
        
        cell.TableThumnail_ImageView.image = UIImage(named: Tables[indexPath.row].HinhAnh)
       
        let  NotSetupColor  = UIColor.init(red: 0/255.0, green: 128.0/255.0, blue: 1.0, alpha: 0.5)
        let didSetupColor = UIColor.init(red: 1.0, green: 128.0/255.0, blue: 0, alpha: 0.7)
        cell.backgroundColor = Tables[indexPath.row].TinhTrang == 1 ? didSetupColor:NotSetupColor
        cell.selectionStyle = .none
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected_tables = indexPath.row
        //let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.red
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Title = Tables[indexPath.row].TinhTrang  == 1 ? "Thanh toán":"Đặt bàn"
        let payAction = UITableViewRowAction(style: .normal, title: Title) { (rowAction, indexPath) in
      
          self.performSegue(withIdentifier: "Seque_detailTable", sender: nil)
            //TODO: edit the row at indexPath here
        }
        let delAction = UITableViewRowAction(style: .normal, title: "Xoá") { (rowAction, indexPath) in
            let soban:Int = Tables[indexPath.row].SoBan!
            if edit(query: "DELETE FROM BanAn WHERE SoBan = \(soban)"){
                Tables.remove(at: indexPath.row)
                print("Đã xoá bàn số \(soban)")
                self.Tables_TableView.reloadData()
            }
            //TODO: edit the row at indexPath here
        }
        payAction.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        delAction.backgroundColor = UIColor.red
        return [payAction,delAction]
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //No action!
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "table_detail" {
            
            isAdded = true
            print("isAdded: \(isAdded)")
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 */
    
}
