//
//  FoodsList_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class FoodsList_ViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {

    var listFoodTypes:[String]! = nil
    
    @IBOutlet weak var pickerFoodType: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerFoodType.delegate=self
        pickerFoodType.dataSource=self
        // Do any additional setup after loading the view.
        listFoodTypes = ["Tất cả", "Đồ ăn", "Đồ uống"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listFoodTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listFoodTypes[row]
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
