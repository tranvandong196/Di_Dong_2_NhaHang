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
    // MARK: *** UIOulet
    
    @IBOutlet weak var imageFood_ImageView: UIImageView!
    @IBOutlet weak var KindofFood_PickerView: UIPickerView!
    @IBOutlet weak var Show_Hide_PickerView_Button: UIButton!

    @IBOutlet weak var NameKindFood_Label: UILabel!
    @IBOutlet weak var otherInfo: UITextView!
    @IBOutlet weak var nameOfFood_TextField: UITextField!
    
    @IBOutlet weak var priceOfFood_TextField: UITextField!
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
        
        
    }
    
    // MARK: *** UIEvent
    @IBAction func SaveChanged_Button(_ sender: Any) {
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
        
        NameKindFood_Label.text = " " + Kinds[row].Ten
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
