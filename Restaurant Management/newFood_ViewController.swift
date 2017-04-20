//
//  newFood_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/20/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class newFood_ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    // MARK: *** Variable
    let Kinds = GetKindsFromSQLite(query: "SELECT * FROM Loai")
    var kind_selected:Int?
    // MARK: *** UIOulet
    
    @IBOutlet weak var imageFood_ImageView: UIImageView!
    @IBOutlet weak var KindofFood_PickerView: UIPickerView!
    @IBOutlet weak var Show_Hide_PickerView_Button: UIButton!

    @IBOutlet weak var NameKindFood_Label: UILabel!
    @IBOutlet weak var otherInfo: UITextView!
    @IBOutlet weak var nameOfFood_TextField: UITextField!
    
    @IBOutlet weak var priceOfFood_TextField: UITextField!
    
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
        
        imageFood_ImageView.image = #imageLiteral(resourceName: "Add_image_icon")
        
        addDoneButton(otherInfo)
        KeyboardShow(self,open_Func:  #selector(self.keyboardWillShow(_:)))
        KeyboardHide(self, open_Func: #selector(self.keyboardWillHide(_:)))
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupDisplayBegin()
        
    }
    func setupDisplayBegin(){
    if indexSelected_foods > -1{
        let kind_tmp = GetKindsFromSQLite(query: "SELECT * FROM Loai WHERE Ma = \(Foods[indexSelected_foods].Loai!)")
        imageFood_ImageView.image = UIImage(named: Foods[indexSelected_foods].HinhAnh)
        nameOfFood_TextField.text = Foods[indexSelected_foods].TenMon
        priceOfFood_TextField.text = String(Foods[indexSelected_foods].Gia!)
        NameKindFood_Label.text = " " + kind_tmp[0].Ten
        
        let number: Int = Kinds.count
        for i in 0..<number{
            if kind_tmp[0].Ma == Kinds[i].Ma {
                KindofFood_PickerView.selectRow(i, inComponent: 0, animated: true)
                kind_selected = kind_tmp[0].Ma
                break
            }
        }
    }
        
    }
    // MARK: *** UIEvent
    @IBAction func SaveChanged_Button(_ sender: Any) {
        saveToDB()
        navigationController!.popViewController(animated: true)
    }
    @IBAction func Show_Hide_PickerView_Button_Tapped(_ sender: Any) {
        KindofFood_PickerView.isHidden = false
        Show_Hide_PickerView_Button.isEnabled = false
        NameKindFood_Label.text = ""
    }
    //  Thêm Action khi ẩn/hiện bàn phím
    func keyboardWillShow(_ notification: NSNotification){
        //Reserve fouth in code vs ViewController
        var keyboardHeight:Float = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Float(keyboardSize.height)
        }
        
        if otherInfo.isEditable{
            self.view.frame.origin.y = 0
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
    }
    // MARK: *** Data
    
    func saveToDB(){
        let food = Food(MaMon: -1, TenMon: nameOfFood_TextField.text!, Gia: Double(priceOfFood_TextField.text!)!, HinhAnh: "Chưa có", MoTa: otherInfo.text, Loai: kind_selected!, Icon: "Chưa có")
        if indexSelected_foods > -1{
            food.MaMon = Foods[indexSelected_foods].MaMon
            food.HinhAnh = Foods[indexSelected_foods].HinhAnh
            food.Icon = Foods[indexSelected_foods].Icon
            updateRow(food)
        }else{
            addRow(food)
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
