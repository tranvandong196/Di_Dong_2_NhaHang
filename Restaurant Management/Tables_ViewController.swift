//
//  Tables_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/15/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
var indexSelected = 0
var id_ban = 0
var Tables = [Table]()
class Tables_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Tables_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addNewTable_Button(_ sender: Any) {
        id_ban = -1
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
        indexSelected = indexPath.row
        //let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.red
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let payAction = UITableViewRowAction(style: .normal, title: "Thanh toán") { (rowAction, indexPath) in
          self.performSegue(withIdentifier: "Seque_detailTable", sender: nil)
            //TODO: edit the row at indexPath here
        }
        let delAction = UITableViewRowAction(style: .normal, title: "Xoá") { (rowAction, indexPath) in
            
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
    
    func moveToVC(withIdentifier: String,animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.present(objSomeViewController, animated: animated, completion: nil)
    }
    func pushToVC(withIdentifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        //let newViewController = NewViewController()
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
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
