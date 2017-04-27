//
//  Manager_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/18/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
class Manager_ViewController: UIViewController,UISearchControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var Default_Currency: UIButton!
    @IBOutlet weak var ChooseLanguage_Button: UIButton!
    
    @IBOutlet weak var Currency_Segment: UISegmentedControl!
    
    @IBOutlet weak var exchange_rate_TextField: UITextField!
    
    @IBOutlet weak var save_Button: UIButton!
    
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    @IBAction func save_Button_Tapped(_ sender: Any) {
        if exchange_rate_TextField.text! != ""{
            ExRate = Double(exchange_rate_TextField.text!)!
        }else{
            ExRate = oldExRate
        }
        exchange_rate_TextField.resignFirstResponder()
    }
    @IBAction func ChooseLanguage_Button_Tapped(_ sender: Any) {
        let message = "Change language of this app including its content."
        let sheetCtrl = UIAlertController(title: "Choose language", message: message, preferredStyle: .actionSheet)
        
        for languageCode in Bundle.main.localizations.filter({ $0 != "Base" }) {
            let langName = Locale.current.localizedString(forLanguageCode: languageCode)
            let action = UIAlertAction(title: langName, style: .default) { _ in
                self.changeToLanguage(languageCode) // see step #2
            }
            sheetCtrl.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetCtrl.addAction(cancelAction)
        
        sheetCtrl.popoverPresentationController?.sourceView = self.view
        sheetCtrl.popoverPresentationController?.sourceRect = self.changeLanguageButton.frame
        present(sheetCtrl, animated: true, completion: nil)
    }
    
    private func changeToLanguage(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let message = "In order to change the language, the App must be closed and reopened by you."
            let confirmAlertCtrl = UIAlertController(title: "App restart required", message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Close now", style: .destructive) { _ in
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            present(confirmAlertCtrl, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exchange_rate_TextField.delegate = self
        exchange_rate_TextField.text = String(ExRate)
        
        save_Button.layer.cornerRadius = 4
        save_Button.setTitle(NSLocalizedString("Save", comment: " "), for: .normal)
        //save_Button.isEnabled = true
        Currency_Segment.selectedSegmentIndex = Currency == "VNĐ" ? 0:1
        ChooseLanguage_Button.layer.cornerRadius = 5
        ChooseLanguage_Button.setTitle(NSLocalizedString("English", comment: " ") , for: .normal)
        Currency_Segment.addTarget(self, action: #selector(CurrencySegmentDidChange(segment:)), for: .valueChanged)
        addDoneButton2(to: exchange_rate_TextField)
        
        // Do any additional setup after loading the view.
    }
    
    func CurrencySegmentDidChange(segment: UISegmentedControl){
        if segment.selectedSegmentIndex == 0{
            Currency = "VNĐ"
        }else if segment.selectedSegmentIndex == 1{
            Currency = "USD"
        }
        UserDefaults.standard.setValue(Currency, forKey: "Currency")
        print(Currency)
    }
    func addDoneButton2(to control: UITextField){
        let toolbar = UIToolbar()
        //let leftBarButtonName = NSLocalizedString("Cancel", comment: " ")
        let rightBarButtonName = NSLocalizedString("Done", comment: " ")

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: rightBarButtonName, style: .done, target: control,
                            action: #selector(UITextField.resignFirstResponder))
        ]
        
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
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
