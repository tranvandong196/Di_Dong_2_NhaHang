//
//  AreaDetail_ViewController.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AreaDetail_ViewController: UIViewController {

    @IBOutlet weak var AreaName_Label: UILabel!
    @IBOutlet weak var AreaPicture_ImageView: UIImageView!
    
    @IBOutlet weak var AreaDes_TextView: UITextView!
     let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[2])")
    override func viewDidLoad() {
        super.viewDidLoad()
        if Areas.count == 1{
            AreaName_Label.text = Areas[0].TenKV!
            AreaPicture_ImageView.image = UIImage(contentsOfFile: localURL.appendingPathComponent(Areas[0].HinhAnh!).path) ?? #imageLiteral(resourceName: "Image-Not-Found-img")
            AreaDes_TextView.text = Areas[0].MoTa!
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
