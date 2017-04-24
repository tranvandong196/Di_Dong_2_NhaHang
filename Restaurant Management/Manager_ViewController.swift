//
//  Manager_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/18/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
class Manager_ViewController: UIViewController,UISearchControllerDelegate {

    @IBOutlet weak var Currency_Segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        Currency_Segment.selectedSegmentIndex = Currency == "VNĐ" ? 0:1
        
        
        Currency_Segment.addTarget(self, action: #selector(CurrencySegmentDidChange(segment:)), for: .valueChanged)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
