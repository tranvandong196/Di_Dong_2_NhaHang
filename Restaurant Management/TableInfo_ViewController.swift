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
    var isAdded2 = false
    // MARK: *** IBOutlet
    @IBOutlet weak var title_navi: UINavigationItem!
    @IBOutlet weak var listFoods_View: UIView!
    @IBOutlet weak var foods_TableView: UITableView!
    @IBOutlet weak var picture_UIImageView: UIImageView!
    @IBOutlet weak var TotalPrice_Label: UILabel!
    @IBOutlet weak var tableInfo_View: UIView!
    @IBOutlet var viewMain_View: UIView!
    @IBOutlet weak var ChangePosition_Button: UIButton!
    @IBOutlet weak var PositionTable_Button: UIButton!
    @IBOutlet weak var saveChanged_Button: UIBarButtonItem!
    @IBOutlet weak var otherInfo: UITextView!
      @IBOutlet weak var payTable_Button: UIButton!
    // MARK: *** Display view
    override func viewDidLoad() {
        super.viewDidLoad()
        isAdded2 = isAdded
        foods_TableView.delegate = self
        foods_TableView.dataSource = self
        addDoneButton(otherInfo)
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        Areas = GetAreasFromSQLite(query: "SElECT * FROM KhuVuc WHERE MaKV = \(Tables[indexSelected_tables].MaKV!)")
        
        setup_displayBegin()
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
        
    }
    func setup_displayBegin(){
        setupUI_PositionTable()
        setupUI_foodsList()
        if isAdded{
            self.picture_UIImageView.image = #imageLiteral(resourceName: "Add_image_icon")
            TotalPrice_Label.text = "Ko hoá đơn"
            payTable_Button.isEnabled = false
            PositionTable_Button.setTitle(Areas[0].TenKV, for: .normal)
            
        }else{
            //self.navigationItem.rightBarButtonItem = nil
            otherInfo.text = Tables[indexSelected_tables].GhiChu
            self.picture_UIImageView.image = UIImage(named: Tables[indexSelected_tables].HinhAnh)
            TotalPrice_Label.text = "Ko hoá đơn"
            title_navi.title = "Bàn số \(Tables[indexSelected_tables].SoBan!)"
            PositionTable_Button.setTitle(Areas[0].TenKV, for: .normal)
        }
        

        self.navigationItem.rightBarButtonItem?.customView?.isHidden = isAdded ? false:true
    }
    // MARK: *** UIEvent

    @IBAction func Save_Button_Clicked(_ sender: Any, forEvent event: UIEvent) {
        saveToDB()
    }
    func saveToDB(){
        if isAdded2 {
            var num:Int = Tables.count + 1
            for i in 1...Tables.count{
                if Tables[i - 1].SoBan != i{
                    num = i
                    break;
                }
            }
            let T = Table(SoBan: num, TinhTrang: 1, HinhAnh: "Ban.png", GhiChu: otherInfo.text, MaKV: 1, MaHD: 0)
            addRow(T)
            Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
            isAdded2 = false
        }else{
            Tables[indexSelected_tables].GhiChu = otherInfo.text
            updateRow(Tables[indexSelected_tables])
        }
    }
    // MARK: *** UIDesign
    func setupUI_foodsList(){
        listFoods_View.layer.cornerRadius = 5
    }
    func setupUI_PositionTable(){
        PositionTable_Button.layer.cornerRadius = 5
        ChangePosition_Button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdded2 || Tables[indexSelected_tables].TinhTrang == 0{
           isAdded = false
            return 0
        }
        else{
            return Foods.count
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
                // Xoá món trong hoá đơn (Ko phải trong Database)
            /* 
                //Xoá trong database
                let tenmon:String = Foods[indexPath.row].TenMon
                if edit(query: "DELETE FROM MonAn WHERE MaMon = \(Foods[indexPath.row].MaMon!)"){
                    Foods.remove(at: indexPath.row)
                    print("Đã xoá \(tenmon)")
                    self.foods_TableView.reloadData()
                }
            */
            
        }
    }
    // MARK: *** Function
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //  Thêm Action khi ẩn/hiện bàn phím
    func keyboardWillShow(_ notification: NSNotification){
        //Reserve fouth in code vs ViewController
        var keyboardHeight:Float = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Float(keyboardSize.height)
        }
        if otherInfo.isEditable{
            // self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
            view.frame.origin.y -= CGFloat(keyboardHeight)
        }
    }
    func keyboardWillHide(_ notification: NSNotification){
        self.view.frame.origin.y = 0
        if !isAdded2 && otherInfo.text != Tables[indexSelected_tables].GhiChu{
            saveToDB()
        }
    }
    
    /*
    // MARK: *** Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seque_saveChanged"{
            //Do anthing....
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
