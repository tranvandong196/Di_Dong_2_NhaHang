//
//  TableInfo_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/14/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
    // MARK: *** Global Variable
var indexSelected_foods = 0
class TableInfo_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    // MARK: *** IBOutlet
    @IBOutlet weak var title_navi: UINavigationItem!
    @IBOutlet weak var listFoods_View: UIView!
    @IBOutlet weak var foods_TableView: UITableView!
    @IBOutlet weak var picture_UIImageView: UIImageView!
    @IBOutlet weak var TotalPrice_Label: UILabel!
    @IBOutlet weak var otherInfo_Label: UITextView!
    @IBOutlet weak var tableInfo_View: UIView!
    @IBOutlet var viewMain_View: UIView!
    @IBOutlet weak var PositionTable_Button: UIButton!
    @IBOutlet weak var saveChanged_Button: UIBarButtonItem!
    @IBOutlet weak var otherInfo: UITextView!
      @IBOutlet weak var payTable_Button: UIButton!
    // MARK: *** Display view
    override func viewDidLoad() {
        super.viewDidLoad()
        foods_TableView.delegate = self
        foods_TableView.dataSource = self
        
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        Areas = GetAreasFromSQLite(query: "SElECT * FROM KhuVuc WHERE MaKV = \(Tables[indexSelected_tables].MaKV! )")
        
        setup_displayBegin()
        // Create notification for two func keyboardWillShow/Hide
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func setup_displayBegin(){
        setupUI_PositionTable()
        setupUI_foodsList()
        if id_ban >= 0 && Tables[indexSelected_tables].TinhTrang == 1{
           self.navigationItem.rightBarButtonItem = nil
            self.picture_UIImageView.image = UIImage(named: Tables[indexSelected_tables].HinhAnh)
            TotalPrice_Label.text = "195.000đ"
            otherInfo_Label.text = Tables[indexSelected_tables].GhiChu
            title_navi.title = "Bàn số \(Tables[indexSelected_tables].SoBan!)"
            PositionTable_Button.setTitle(Areas[0].TenKV, for: .normal)
            
        }else{
            id_ban = 0
            self.picture_UIImageView.image = #imageLiteral(resourceName: "Add_image_icon")
            TotalPrice_Label.text = "0đ"
            otherInfo_Label.text = ""
            payTable_Button.isEnabled = false
            PositionTable_Button.setTitle(Areas[0].TenKV, for: .normal)
        }
    }
    // MARK: *** UIEvent

  
    // MARK: *** UIDesign
    func setupUI_foodsList(){
        listFoods_View.layer.cornerRadius = 5
    }
    func setupUI_PositionTable(){
        PositionTable_Button.layer.cornerRadius = 5
    }
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if id_ban >= 0 && Tables[indexSelected_tables].TinhTrang == 1{
            return Foods.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! foods_TableViewCell

        cell.nameOfFood_Label.text = Foods[indexPath.row].TenMon
        cell.food_ImageView.image = UIImage(named: Foods[indexPath.row].Icon)
        cell.priceOfFood.text = "\(Int(Foods[indexPath.row].Gia!).stringFormattedWithSeparator)đ"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected_foods = indexPath.row
        //performSegue(withIdentifier: "seque_foodDetal", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            
           //No action!
            
        }
    }
    // MARK: *** My function
    func keyboardWillShow(_ notification: NSNotification){
        //Reserve fouth in code vs ViewController
        var keyboardHeight:Float = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Float(keyboardSize.height)
        }
        if otherInfo.isEditable{
                view.frame.origin.y -= CGFloat(keyboardHeight)
            }
    }
    func keyboardWillHide(_ notification: NSNotification){
        self.tableInfo_View.frame.origin.y = 0
    }
    /*
    // MARK: *** Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
