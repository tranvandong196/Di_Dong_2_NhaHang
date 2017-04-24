//
//  newFood_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/20/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class newFood_ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // MARK: *** Variable
    let Kinds = GetKindsFromSQLite(query: "SELECT * FROM Loai")
    var kind_selected:Int?
    var newImage:UIImage?
    var newImageFormat:String?
    var isDeleting:Bool = false
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[1])")
    
    // MARK: *** UIOulet
    
    @IBOutlet weak var imageFood_ImageView: UIImageView!
    @IBOutlet weak var KindofFood_PickerView: UIPickerView!
    @IBOutlet weak var Show_Hide_PickerView_Button: UIButton!
    
    @IBOutlet weak var NameKindFood_Label: UILabel!
    @IBOutlet weak var otherInfo: UITextView!
    @IBOutlet weak var nameOfFood_TextField: UITextField!
    
    @IBOutlet weak var priceOfFood_TextField: UITextField!
    
    @IBOutlet weak var Currency_Label: UILabel!
    // MARK: *** Display show
    override func viewDidLoad() {
        super.viewDidLoad()
        Show_Hide_PickerView_Button.layer.cornerRadius = 5
        Show_Hide_PickerView_Button.layer.borderColor = UIColor.lightGray.cgColor
        Show_Hide_PickerView_Button.layer.borderWidth = 0.3
        
        KindofFood_PickerView.delegate = self
        KindofFood_PickerView.dataSource = self
        self.nameOfFood_TextField.delegate = self; nameOfFood_TextField.tag = 0
        self.priceOfFood_TextField.delegate = self; priceOfFood_TextField.tag = 1
        
        
        addDoneButton(otherInfo)
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if indexSelected_tables > -1{
            print("\n 🍉✂️ Sửa món ăn =========================")
        }else{
            print("\n 🍉 Thêm món ăn mới =========================")
        }
        setupDisplayBegin()
        
        Currency_Label.text = Currency
    }
    func setupDisplayBegin(){
        if indexSelected_foods > -1{
            let kind_tmp = GetKindsFromSQLite(query: "SELECT * FROM Loai WHERE Ma = \(Foods[indexSelected_foods].Loai!)")
            imageFood_ImageView.image = newImage ?? UIImage(contentsOfFile: localURL.appendingPathComponent(Foods[indexSelected_foods].HinhAnh).path) ?? #imageLiteral(resourceName: "Add_image_icon")
            nameOfFood_TextField.text = Foods[indexSelected_foods].TenMon
            let p = Foods[indexSelected_foods].Gia!.getCurrencyValue(Currency: Currency)
            priceOfFood_TextField.text = p.0.toCurrencyString(Currency: Currency)
            NameKindFood_Label.text = " " + kind_tmp[0].Ten
            
            let number: Int = Kinds.count
            for i in 0..<number{
                if kind_tmp[0].Ma == Kinds[i].Ma {
                    KindofFood_PickerView.selectRow(i, inComponent: 0, animated: true)
                    kind_selected = kind_tmp[0].Ma
                    break
                }
            }
        }else{
            imageFood_ImageView.image = newImage ?? #imageLiteral(resourceName: "Add_image_icon")
        }
        
    }
    // MARK: *** IBAction
    @IBAction func SaveChanged_Button(_ sender: Any) {
        if saveToDB(){
            navigationController!.popViewController(animated: true)
        }
        else{
            func status(_ textField: UITextField){
                if textField.isEmpty(){
                    textField.layer.backgroundColor = UIColor.red.cgColor
                }else{
                    textField.layer.backgroundColor = UIColor.white.cgColor
                }
                textField.resignFirstResponder()
            }
            
            status(priceOfFood_TextField)
            status(nameOfFood_TextField)
            if NameKindFood_Label.isEmpty(){
                self.Show_Hide_PickerView_Button.layer.borderColor = UIColor.red.cgColor
            }else{
                self.Show_Hide_PickerView_Button.layer.borderColor = UIColor.lightGray.cgColor
            }
            alert(title: "⚠️", message: "Bạn chưa nhập đầy đủ thông tin", titleAction: "Nhập lại"){
                _ in
            }
        }
    }
    
    @IBAction func PicturePickerTapped_TapGesture(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            (ACTION) in pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        let photosLibraryAction = UIAlertAction(title: "Photo Library", style: .default){
            (ACTION) in pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let deletePhoto = UIAlertAction(title: "Delete", style: .default){ (ACTION) in
            let alert = UIAlertController(title: "❌", message: "Delete this photo?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default){_ in
                _ = self.imageFood_ImageView.image = #imageLiteral(resourceName: "Add_image_icon")
                _ = self.newImage = nil
                _ = self.isDeleting = true
            })
            alert.addAction(UIAlertAction(title: "NO", style: .default){_ in
                
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        if imageFood_ImageView.image != #imageLiteral(resourceName: "Add_image_icon"){
            alertController.addAction(deletePhoto)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func Show_Hide_PickerView_Button_Tapped(_ sender: Any) {
        KindofFood_PickerView.isHidden = false
        Show_Hide_PickerView_Button.isEnabled = false
        NameKindFood_Label.text = ""
        
        nameOfFood_TextField.resignFirstResponder()
        priceOfFood_TextField.resignFirstResponder()
        otherInfo.isEditable = false
    }
    // MARK: *** Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            newImage = image
            let newImageName:String = (info[UIImagePickerControllerReferenceURL] as! NSURL).lastPathComponent!
            newImageFormat = String(newImageName.characters.suffix(4))
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    //  Thêm Action khi ẩn/hiện bàn phím
    func keyboardWillShow(_ notification: NSNotification){
        //Reserve fouth in code vs ViewController
        var keyboardHeight:Float = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Float(keyboardSize.height)
        }
        
        self.view.frame.origin.y = 0
        if nameOfFood_TextField.isEditing || priceOfFood_TextField.isEditing{
            view.frame.origin.y -= 40
        }else if otherInfo.isEditable{
            view.frame.origin.y -= CGFloat(keyboardHeight)
        }
    }
    func keyboardWillHide(_ notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    //Hide or switch next keyboard when user Presses "return" key (for textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: *** UIPickerView
    //==========: Picker View :=============
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Kinds.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Kinds[row].Ten
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.NameKindFood_Label.isHidden = false
        self.KindofFood_PickerView.isHidden = true
        Show_Hide_PickerView_Button.isEnabled = true
        kind_selected = Kinds[row].Ma
        NameKindFood_Label.text = " " + Kinds[row].Ten
        otherInfo.isEditable = true
    }
    // MARK: *** Data
    
    func saveToDB() -> Bool{
        if nameOfFood_TextField.isEmpty() || priceOfFood_TextField.isEmpty() || NameKindFood_Label.isEmpty(){
            return false
        }else{
            let newImageName = newImage == nil ? nil:nameOfFood_TextField.text! + newImageFormat!
            var price = Double(priceOfFood_TextField.text!)!
            if Currency == "USD"{
                price = price.getCurrencyValue(Currency: "USDVND").0
            }
            let newfood = Food(MaMon: -1, TenMon: nameOfFood_TextField.text!, Gia: price, HinhAnh: "", MoTa: otherInfo.text, Loai: kind_selected!, Icon: "")
            
            if indexSelected_foods > -1{
                newfood.MaMon = Foods[indexSelected_foods].MaMon
                newfood.HinhAnh = Foods[indexSelected_foods].HinhAnh
                newfood.Icon = Foods[indexSelected_foods].Icon
            }
            
            if newImage != nil{
                if newfood.HinhAnh! != ""{
                    FileManager.default.remoremoveItem(at: localURL, withName: newfood.HinhAnh!)
                }
                newImage?.saveImageToDir(at: localURL, name: newImageName!)
                
                newfood.HinhAnh = newImageName!
            }else if isDeleting{
                if newfood.HinhAnh != ""{
                    FileManager.default.remoremoveItem(at: localURL, withName: newfood.HinhAnh!)
                    newfood.HinhAnh = ""
                }
            }
            
            if indexSelected_foods > -1{
                Foods[indexSelected_foods] = newfood
                updateRow(newfood)
            }else{
                addRow(newfood)
            }
            
            return true
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
