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

class TableInfo_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var newImage:UIImage?
    var priceTotal:Double = 0
    let localURLtable = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[0])")
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[1])")
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
    @IBOutlet weak var otherInfo: UITextView!
    @IBOutlet weak var payTable_Button: UIButton!
    
    var total:Double = 0
    
    @IBAction func Pay_Btn_Action(_ sender: Any) {
        func PAY(){
            
            if(Tables[indexSelected_tables].MaHD != nil){
                //Loại bỏ hóa đơn của bàn + cập nhật tình trạng
                var strQuery = "UPDATE BanAn SET MaHD = null, TinhTrang = 0 WHERE SoBan = \(Tables[indexSelected_tables].SoBan!)"
                Query(sql: strQuery, database: database!)
                
                //Cập nhật Thời gian + thành tiền hóa đơn
                strQuery = "UPDATE HoaDon SET ThoiGian = datetime('now', 'localtime'), ThanhTien = \(total)" + " WHERE MaHD = \(Tables[indexSelected_tables].MaHD!) AND " + "SoBan = \(Tables[indexSelected_tables].SoBan!)"
                Query(sql: strQuery, database: database!)
                Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
            }
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Pay for this table?", comment: " "), message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default){_ in
            PAY()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){_ in
            
        }
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

        
    }
    // MARK: *** Display view
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButton(otherInfo)
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
        
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        TotalPrice_Label.text = Currency == "VNĐ" ? "0đ":"0$"
    }
    override func viewWillAppear(_ animated: Bool) {
        foods_TableView.delegate = self
        foods_TableView.dataSource = self
        
        priceTotal = 0
        total = 0
        print("\n 💛 Thông tin bàn =========================")
        
        Areas = GetAreasFromSQLite(query: "SELECT * FROM KhuVuc WHERE MaKV = \(Tables[indexSelected_tables].MaKV!)")
        
        
        Foods.removeAll()
        if(Tables[indexSelected_tables].MaHD != nil){
            let str = "SELECT * FROM MonAn NATURAL JOIN (SELECT * FROM ChiTietHoaDon WHERE MaHD = \(Tables[indexSelected_tables].MaHD!))"
            Foods = GetFoodsFromSQLite(query: str)
            //let rowData = sqlite3_column_text(statement, 1)
            // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
            //let fieldValue = String(cString: rowData!)
            // Them Vao mang da co
            //mang.append(fieldValue!)
        }
        
        foods_TableView.reloadData()
        setup_displayBegin()
    }
    
    func setup_displayBegin(){
        setupUI_PositionTable()
        setupUI_foodsList()
        //self.navigationItem.rightBarButtonItem = nil
        self.picture_UIImageView.image = newImage ?? UIImage(contentsOfFile: localURLtable.appendingPathComponent(Tables[indexSelected_tables].HinhAnh).path) ?? #imageLiteral(resourceName: "Add_image_icon")
        otherInfo.text = Tables[indexSelected_tables].GhiChu
        title_navi.title = NSLocalizedString("Table num", comment: " ") + "\(Tables[indexSelected_tables].SoBan!)"
        if (Areas.count != 0){
            PositionTable_Button.setTitle(Areas[0].TenKV, for: .normal)
        }
        else{
            PositionTable_Button.setTitle("", for: .normal)
        }
        payTable_Button.isEnabled = Foods.count == 0 ? false:true
    }
    // MARK: *** IBAction
    
    @IBAction func PicturePickerTapped_TapGesture(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = self.AlertPickerImage(pickerController: pickerController)
        //let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let deletePhoto = UIAlertAction(title: NSLocalizedString("Delete", comment: " "), style: .default){ (ACTION) in
            let alert = UIAlertController(title: "❌", message: NSLocalizedString("Delete this photo?", comment: " ") , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: " "), style: .default){_ in
                _ = self.picture_UIImageView.image = #imageLiteral(resourceName: "Add_image_icon")
                _ = self.newImage = nil
                if Tables[indexSelected_tables].HinhAnh != ""{
                    FileManager.default.remoremoveItem(at: self.localURLtable, withName: Tables[indexSelected_tables].HinhAnh!)
                    Tables[indexSelected_tables].HinhAnh = ""
                }
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: " "), style: .default){_ in
                
            })
            self.present(alert, animated: true, completion: nil)
        }
        

        if picture_UIImageView.image != #imageLiteral(resourceName: "Add_image_icon"){
            alertController.addAction(deletePhoto)
        }
        alertController.addAction(GetCancelAction())
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARKL: *** functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let pickerImageName:String = (info[UIImagePickerControllerReferenceURL] as! NSURL).lastPathComponent!
            
            let newImageName:String = "Ban\(Tables[indexSelected_tables].SoBan!)\(String(pickerImageName.characters.suffix(4)))"
            
            if Tables[indexSelected_tables].HinhAnh != ""{
                FileManager.default.remoremoveItem(at: localURLtable, withName: Tables[indexSelected_tables].HinhAnh!)
            }
            
            image.saveImageToDir(at: localURLtable, name:newImageName)
            Tables[indexSelected_tables].HinhAnh = newImageName
            
            newImage = image
            updateRow(Tables[indexSelected_tables])
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
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
        if Foods.count == 0 && Tables[indexSelected_tables].TinhTrang == 1{
            TotalPrice_Label.text = Currency == "VNĐ" ? "0đ":"0$"
            Tables[indexSelected_tables].TinhTrang = 0
            updateRow(Tables[indexSelected_tables])
        }
        if Foods.count != 0 && Tables[indexSelected_tables].TinhTrang == 0{
            Tables[indexSelected_tables].TinhTrang = 1
            updateRow(Tables[indexSelected_tables])
        }
        priceTotal = 0
        total = 0
        for i in 0..<Foods.count{
            let p = (Foods[i].Gia)!.getCurrencyValue(Currency: Currency)
            total += (Double(Foods[i].SoLuong!))*(Foods[i].Gia)!
            priceTotal += (Double(Foods[i].SoLuong!))*p.0
        }
        TotalPrice_Label.text = priceTotal.toCurrencyString(Currency: Currency) + (Currency == "VNĐ" ? "đ":"$")
        return Foods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! foods_TableViewCell
        
        cell.nameOfFood_Label.text = "\(Foods[indexPath.row].SoLuong!)‣ " + Foods[indexPath.row].TenMon
        let ImgURL = localURL.appendingPathComponent(Foods[indexPath.row].Icon!)
        //print("IconURL: \(IconURL.path)")
        cell.food_ImageView.image = UIImage(contentsOfFile: ImgURL.path)  ?? #imageLiteral(resourceName: "Image-Not-Found-icon")
        let p = (Foods[indexPath.row].Gia)!.getCurrencyValue(Currency: Currency)
        cell.priceOfFood.text = p.0.toCurrencyString(Currency: Currency) + p.1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected_foods = indexPath.row
        //performSegue(withIdentifier: "seque_foodDetal", sender: nil)
    }
     //Thêm tuỳ chọn khi vuốt cell trừ phải qua trái
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Increase = UITableViewRowAction(style: .normal, title: "➕") { (rowAction, indexPath) in
            //Cập nhật Thời gian + thành tiền hóa đơn
            Foods[indexPath.row].SoLuong = Foods[indexPath.row].SoLuong! + 1
            self.foods_TableView.reloadData()
            let strQuery = "UPDATE ChiTietHoaDon SET SoLuong = \(Foods[indexPath.row].SoLuong!) WHERE MaHD = \(Tables[indexSelected_tables].MaHD!) AND " + "MaMon = \(Foods[indexPath.row].MaMon!)"
            
            edit(query: strQuery)
            
        }
        let Decrease = UITableViewRowAction(style: .normal, title: "➖") { (rowAction, indexPath) in
            //Cập nhật Thời gian + thành tiền hóa đơn
            Foods[indexPath.row].SoLuong = Foods[indexPath.row].SoLuong! - 1
            self.foods_TableView.reloadData()
            let strQuery = "UPDATE ChiTietHoaDon SET SoLuong = \(Foods[indexPath.row].SoLuong!) WHERE MaHD = \(Tables[indexSelected_tables].MaHD!) AND " + "MaMon = \(Foods[indexPath.row].MaMon!)"
            
            edit(query: strQuery)
        }
        let delAction = UITableViewRowAction(style: .normal, title: NSLocalizedString("Delete", comment: " ")) { (rowAction, indexPath) in
            
            // Xoá món trong hoá đơn của bàn này
            let tenmon:String = Foods[indexPath.row].TenMon
            if edit(query: "DELETE FROM ChiTietHoaDon WHERE MaMon = \(Foods[indexPath.row].MaMon!)"){
                Foods.remove(at: indexPath.row)
                print("Đã huỷ < \(tenmon) > từ bàn số \(Tables[indexSelected_tables].SoBan!)")
                self.foods_TableView.reloadData()
            }
        }
        Increase.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        delAction.backgroundColor = UIColor.red
        if Foods[indexPath.row].SoLuong! > 1{
            return [Increase,Decrease,delAction]
        }else{
            return [Increase,delAction]
        }
}

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            // Xoá món trong hoá đơn của bàn này
//            let tenmon:String = Foods[indexPath.row].TenMon
//            if edit(query: "DELETE FROM ChiTietHoaDon WHERE MaMon = \(Foods[indexPath.row].MaMon!)"){
//                Foods.remove(at: indexPath.row)
//                print("Đã huỷ < \(tenmon) > từ bàn số \(Tables[indexSelected_tables].SoBan!)")
//                self.foods_TableView.reloadData()
//            }
//        }
//    }
    
    // MARK: *** Function
    func saveToDB(){
        Tables[indexSelected_tables].GhiChu = otherInfo.text
        updateRow(Tables[indexSelected_tables])
    }
    
    
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
        if otherInfo.text != Tables[indexSelected_tables].GhiChu{
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
