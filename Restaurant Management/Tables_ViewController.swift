//
//  Tables_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/15/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
var indexSelected = 0
var id_ban = 0
class Tables_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   var colorcell = true
    @IBOutlet var Tables_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addNewTable_Button(_ sender: Any) {
        id_ban = -1
        pushToVC(withIdentifier: "table_detail")
        //moveToVC(withIdentifier: "table_detail", animated: true)
    }
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_table", for: indexPath) as! Table_TableViewCell
        cell.TableName_Label.text = "Bàn số \(indexPath.row + 1)"
        cell.TableThumnail_ImageView.image = #imageLiteral(resourceName: "Ban1")
        
        cell.backgroundColor = colorcell == true ? UIColor.lightGray:UIColor.orange
        cell.selectionStyle = .none
        colorcell = !colorcell
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = indexPath.row
        //let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.red
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let payAction = UITableViewRowAction(style: .normal, title: "Thanh toán") { (rowAction, indexPath) in
          self.performSegue(withIdentifier: "Seque_detailTable", sender: nil)
            //TODO: edit the row at indexPath here
        }
        let delAction = UITableViewRowAction(style: .normal, title: "Xoá") { (rowAction, indexPath) in
            
            //TODO: edit the row at indexPath here
        }
        payAction.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        delAction.backgroundColor = UIColor.red
        return [payAction,delAction]
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //No action!
            
        }
    }
    
    func moveToVC(withIdentifier: String,animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.present(objSomeViewController, animated: animated, completion: nil)
    }
    func pushToVC(withIdentifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        //let newViewController = NewViewController()
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
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
