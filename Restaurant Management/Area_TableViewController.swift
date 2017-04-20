//
//  Area_TableViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//
import UIKit

class Area_TableViewController: UITableViewController {
    
    public static var listArea = [Area]()
    public static var Add_New_Item = false;
    public static var Edit_Item_Index = -1;
    
    var Edit_Mode = true //0=hide_nav_btn    1=edit
    @IBOutlet var MyTableView: UITableView!
    @IBOutlet weak var Edit_Btn_Outlet: UIBarButtonItem!
    @IBOutlet weak var Add_Btn_Outlet: UIBarButtonItem!
    @IBAction func Edit_Btn(_ sender: Any) {
    }
    @IBAction func Add_Btn(_ sender: Any) {
        Area_TableViewController.Add_New_Item = true;
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddArea") as? Area_Add_Edit_ViewController {
            //viewController.newsObj = newsObj
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Area_TableViewController.Add_New_Item = false;
        Area_TableViewController.Edit_Item_Index = -1;
        reloadDbData()
        MyTableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        Area_TableViewController.Add_New_Item = false;
        Area_TableViewController.Edit_Item_Index = -1;
        
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
        reloadDbData()
        
    }

    //Load data from dbs
    func reloadDbData()
    {
        Area_TableViewController.listArea.removeAll()
        
        //sqlite
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        
        //Lay data
        let statement:OpaquePointer = Select(query: "SELECT * FROM KhuVuc", database: database!)
        
        // Do du lieu vao mang
        while sqlite3_step(statement) == SQLITE_ROW {
            // Do ra tung cot tuong ung voi no
            let area = Area()
            
            if(sqlite3_column_text(statement, 0) != nil)
            {
                area.MaKV = Int(sqlite3_column_int(statement, 0))
                if(sqlite3_column_text(statement, 1) != nil)
                {
                    area.TenKV = String(cString: sqlite3_column_text(statement, 1))
                }
                if(sqlite3_column_text(statement, 2) != nil)
                {
                    area.MoTa = String(cString: sqlite3_column_text(statement, 2))
                }
                if(sqlite3_column_text(statement, 3) != nil)
                {
                    area.HinhAnh = String(cString: sqlite3_column_text(statement, 3))
                    
                }
            }
            
            Area_TableViewController.listArea.append(area)
            
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Area_TableViewController.listArea.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_table", for: indexPath) as! Area_TableViewCell
        cell.Area_Lable.text = Area_TableViewController.listArea[indexPath.row].TenKV
        cell.Area_Image.image = UIImage(named: Area_TableViewController.listArea[indexPath.row].HinhAnh!)
        cell.Area_Description.text = Area_TableViewController.listArea[indexPath.row].MoTa

    
        return cell

    }
 
    //select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.isEditing == true
        {
            //if Area_TableViewController.Edit_Mode == true {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddArea") as? Area_Add_Edit_ViewController
                {
                    //viewController.newsObj = newsObj
                    if let navigator = navigationController {
                        
                        Area_TableViewController.Edit_Item_Index = indexPath.row;
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            
        }
        else{
            if Edit_Mode == false
            {
                Tables[indexSelected_tables].MaKV =  Area_TableViewController.listArea[indexPath.row].MaKV
                updateRow(Tables[indexSelected_tables])
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
            
            let str = "DELETE FROM KhuVuc WHERE MaKV=" + "\(Area_TableViewController.listArea[indexPath.row].MaKV!)"
            Query(sql: str, database: database!)
            
            sqlite3_close(database)
            
            Area_TableViewController.listArea.remove(at: indexPath.row)
            
            sqlite3_close(database)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }


    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
