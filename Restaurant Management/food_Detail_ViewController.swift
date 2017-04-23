//
//  food_Detail_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/16/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class food_Detail_ViewController: UIViewController {
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[1])")
    // MARK: *** UIOutlet
    @IBOutlet weak var foodImage_ImageView: UIImageView!
    @IBOutlet weak var foodName_Label: UILabel!
    @IBOutlet weak var foodPrice_Label: UILabel!
    @IBOutlet weak var foodInfo_TextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\n 🍉🔎 Thông tin món ăn =========================")
        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
        let ImgURL = localURL.appendingPathComponent(Foods[indexSelected_foods].HinhAnh!)
        foodImage_ImageView.image = UIImage(contentsOfFile: ImgURL.path ) ?? #imageLiteral(resourceName: "Image-Not-Found-img")
        foodName_Label.text = Foods[indexSelected_foods].TenMon
        foodPrice_Label.text = "\(Int(Foods[indexSelected_foods].Gia!).stringFormattedWithSeparator)đ"
        foodInfo_TextView.text = Foods[indexSelected_foods].MoTa
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
