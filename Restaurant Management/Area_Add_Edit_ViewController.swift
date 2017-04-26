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
        area.HinhAnh = newImageName
        if area.HinhAnh == nil{
            area.HinhAnh = ""
        }
        if area.HinhAnh! != ""{
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
                _ = self.Image_Area.image = #imageLiteral(resourceName: "Add_image_icon")
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
        if Image_Area.image != #imageLiteral(resourceName: "Add_image_icon"){
            alertController.addAction(deletePhoto)
        }
        alertController.addAction(cancelAction)
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
