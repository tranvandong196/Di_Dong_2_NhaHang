//
//  Area_Add_Edit_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/18/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class Area_Add_Edit_ViewController: UIViewController {

    @IBOutlet weak var edt_Name: UITextField!
    @IBOutlet weak var edt_Description: UITextView!
    @IBOutlet weak var edt_Image: UITextField!
    
    var isAddNew = false
    let area = Area()
    
    @IBAction func btn_Done(_ sender: Any) {
        //sqlite
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        
        
        area.TenKV = edt_Name.text
        area.MoTa = edt_Description.text
        area.HinhAnh = edt_Image.text
        
        if(isAddNew)
        {
            //add
            let str = "INSERT INTO KhuVuc VALUES (null,'" + area.TenKV + "','" + area.MoTa + "','" + area.HinhAnh + "')"
            Query(sql: str, database: database!)
            
        }
        else
        {
            //update
            let str = "UPDATE KhuVuc SET TenKV = '" + area.TenKV + "', MoTa = '" + area.MoTa + "', HinhAnh = '" + area.HinhAnh + "' WHERE MaKV = " + "\(area.MaKV!)";
            Query(sql: str, database: database!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        loadToEdit(Area_TableViewController.Add_New_Item)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadToEdit(_ addNewItem: Bool)
    {
        isAddNew = addNewItem
        if isAddNew == false{
            area.MaKV = Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].MaKV
            edt_Name.text = Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].TenKV
            edt_Description.text = Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].MoTa
            edt_Image.text = Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].HinhAnh
        }
        
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
