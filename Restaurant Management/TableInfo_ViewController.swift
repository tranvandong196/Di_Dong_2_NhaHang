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
var list_BookedFoods = [Food]()

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
        addDoneButton(otherInfo)
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
        
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        print("ViewDidLoad")
    }
    override func viewWillAppear(_ animated: Bool) {
        foods_TableView.delegate = self
        foods_TableView.dataSource = self
        
        
        
        Areas = GetAreasFromSQLite(query: "SELECT * FROM KhuVuc WHERE MaKV = \(Tables[indexSelected_tables].MaKV!)")
        
        
        if(Tables[indexSelected_tables].MaHD != nil){
            let str = "SELECT * FROM MonAn NATURAL JOIN (SELECT * FROM ChiTietHoaDon WHERE MaHD = " + "\(Tables[indexSelected_tables].MaHD!)" + ")"
            
            //list_BookedFoods = GetFoodsFromSQLite(query:  str)
            
            list_BookedFoods.removeAll()
            
            //sqlite
            database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            
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
                    if(sqlite3_column_text(statement, 8) != nil)
                    {
                        food.SoLuong = Int(sqlite3_column_int(statement, 8))
                    }
                }
                
                list_BookedFoods.append(food)
                
                
                //let rowData = sqlite3_column_text(statement, 1)
                // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
                //let fieldValue = String(cString: rowData!)
                // Them Vao mang da co
                //mang.append(fieldValue!)
            }
            sqlite3_finalize(statement)
            sqlite3_close(database)
            
            
        }
        
        foods_TableView.reloadData()
        setup_displayBegin()
        print("ViewWillAppear")
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
        self.navigationController?.popViewController(animated: true)
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
            return list_BookedFoods.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! foods_TableViewCell
        
        cell.nameOfFood_Label.text = "\(list_BookedFoods[indexPath.row].SoLuong!)‣ " + list_BookedFoods[indexPath.row].TenMon
        let IconURL = DocURL().appendingPathComponent("\(Parent_dir_data)/\(Sub_folder_data[1])/\(list_BookedFoods[indexPath.row].Icon!)")
        //print("IconURL: \(IconURL.path)")
        cell.food_ImageView.image = UIImage(contentsOfFile: IconURL.path )
        cell.priceOfFood.text = "\(Int((list_BookedFoods[indexPath.row].Gia)!).stringFormattedWithSeparator)đ"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected_foods = indexPath.row
        //performSegue(withIdentifier: "seque_foodDetal", sender: nil)
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == .delete {
    //                // Xoá món trong hoá đơn (Ko phải trong Database)
    //            /*
    //                //Xoá trong database
    //                let tenmon:String = Foods[indexPath.row].TenMon
    //                if edit(query: "DELETE FROM MonAn WHERE MaMon = \(Foods[indexPath.row].MaMon!)"){
    //                    Foods.remove(at: indexPath.row)
    //                    print("Đã xoá \(tenmon)")
    //                    self.foods_TableView.reloadData()
    //                }
    //            */
    //
    //        }
    //    }
    
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
    //Edit Area
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_PickArea")
        {
            let dest = segue.destination as! Area_TableViewController
            dest.Edit_Mode = false
        }
        if(segue.identifier == "Segue_Add_Foods")
        {
            let dest = segue.destination as! FoodsList_ViewController
            dest.Edit_Mode = false
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
