//
//  Area_Add_Edit_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/18/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class Area_Add_Edit_ViewController: UIViewController,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var newImage:UIImage?
    var newImageFormat:String?
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[2])")
    
    var isDeleting:Bool = false
    @IBOutlet weak var Image_Area: UIImageView!
    @IBOutlet weak var edt_Name: UITextField!
    @IBOutlet weak var edt_Description: UITextView!
    
    var isAddNew = false
    let area = Area()
    
    @IBAction func btn_Done(_ sender: Any) {
        //sqlite
        database = Connect_DB_SQLite(dbName: "QuanLyNhaHang", type: "sqlite")
        
        
        area.TenKV = edt_Name.text
        area.MoTa = edt_Description.text
        let newImageName = newImage == nil ? nil:area.TenKV! + newImageFormat!
        
        
        if newImageName == nil{
            if (Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].HinhAnh == nil)
            {
                area.HinhAnh = ""
            }
            else{
                area.HinhAnh = Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].HinhAnh
            }
        }
        else{
            area.HinhAnh = newImageName
        }
        
        if (area.HinhAnh! != "" && newImageName != nil){
            FileManager.default.remoremoveItem(at: localURL, withName: area.HinhAnh!)
        }
        newImage?.saveImageToDir(at: localURL, name: newImageName!)
        
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        if isAddNew == true{
            Image_Area.image = newImage ?? #imageLiteral(resourceName: "Add_image_icon")
        }
        else{
            Image_Area.image = newImage ?? UIImage(contentsOfFile: localURL.appendingPathComponent(Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].HinhAnh).path) ?? #imageLiteral(resourceName: "Add_image_icon")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Image_Area.image = #imageLiteral(resourceName: "Add_image_icon")
        
        // Do any additional setup after loading the view.
        loadToEdit(Area_TableViewController.Add_New_Item)
        addDoneButton(edt_Description)
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
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
            Image_Area.image = newImage ?? UIImage(contentsOfFile: localURL.appendingPathComponent(Area_TableViewController.listArea[Area_TableViewController.Edit_Item_Index].HinhAnh).path) ?? #imageLiteral(resourceName: "Add_image_icon")
        }
        
    }
    
    @IBAction func PicturePickerTapped_TapGesture(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = self.AlertPickerImage(pickerController: pickerController)
        
        let deletePhoto = UIAlertAction(title: NSLocalizedString("Delete", comment: " "), style: .default){ (ACTION) in
            let alert = UIAlertController(title: "❌", message: NSLocalizedString("Delete this photo?", comment: " ") , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: " "), style: .default){_ in
                _ = self.Image_Area.image = #imageLiteral(resourceName: "Add_image_icon")
                _ = self.newImage = nil
                _ = self.isDeleting = true
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: " "), style: .default){_ in
                
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        if Image_Area.image != #imageLiteral(resourceName: "Add_image_icon"){
            alertController.addAction(deletePhoto)
        }
        alertController.addAction(GetCancelAction())
        
        present(alertController, animated: true, completion: nil)
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
    
    // MARK: *** Keyboard Setup
    //  Thêm Action khi ẩn/hiện bàn phím
    func keyboardWillShow(_ notification: NSNotification){
        //Reserve fouth in code vs ViewController
        var keyboardHeight:Float = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Float(keyboardSize.height)
        }
        
        self.view.frame.origin.y = 0
        if edt_Name.isEditing{
            view.frame.origin.y -= 50
        }else if edt_Description.isEditable{
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
