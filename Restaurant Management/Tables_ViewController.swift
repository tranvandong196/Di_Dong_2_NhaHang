//
//  Tables_ViewController.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/15/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
var indexSelected_tables = 0
var Currency:String = "VNĐ"

class Tables_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    enum selectedScope:Int{
        case all = 0
        case set = 1
        case notset = 2
    }
    var tablesOrigial = [Table]()
    let localURL = DocURL().appendingPathComponent(Parent_dir_data + "/\(Sub_folder_data[0])")
    
    @IBOutlet var Tables_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Tables_TableView.delegate = self
        Tables_TableView.dataSource = self
        
        
        copyDataToDocumentURL(ParentDir: Parent_dir_data, SubFolder: Sub_folder_data)
        
        if UserDefaults.standard.value(forKey: "Currency") != nil{
            Currency = UserDefaults.standard.value(forKey: "Currency") as! String
            print("Lấy loại tiền tệ: \(Currency)")
        }
        
        
    }
    // MARK: *** SearchBar
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        //searchBar.scopeButtonTitles = ["Tất cả","Đã đặt","Chưa đặt"]
        searchBar.scopeButtonTitles = [NSLocalizedString("All", comment: " "),NSLocalizedString("Booked", comment: " "),NSLocalizedString("Not booked", comment: " ")]
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.selectedScopeButtonIndex = 0
        self.Tables_TableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterTableView(ind: selectedScope,searchText: nil)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
        filterTableView(ind: searchBar.selectedScopeButtonIndex, searchText: nil)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        //self.searchDisplayController?.setActive(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(ind: searchBar.selectedScopeButtonIndex,searchText: searchBar.text)
    }
    func filterTableView(ind:Int,searchText: String?){
            switch ind {
            case selectedScope.all.rawValue:
                Tables = tablesOrigial
            case selectedScope.set.rawValue:
                Tables = tablesOrigial.filter({(mod) -> Bool in
                    return mod.TinhTrang == 1
                })
            case selectedScope.notset.rawValue:
                Tables = tablesOrigial.filter({(mod) -> Bool in
                    return mod.TinhTrang == 0
                })
            default:
                print("Search...")
            }
        if searchText != nil{
            Tables = Tables.filter({(mod) -> Bool in
                let x = String(mod.SoBan!).contains(searchText!) ? true:searchText!.lowercased().contains(String(mod.SoBan!))
                let y = mod.GhiChu!.lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(mod.GhiChu!.lowercased())
                var z = false
                for i in 0..<Areas.count{
                    if Areas[i].MaKV! == mod.MaKV!{
                        z = Areas[i].TenKV!.lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(Areas[i].TenKV!.lowercased())
                        break;
                    }
                }
                
                return (x || y || z)
            })
        }
        Tables_TableView.reloadData()
    }
   
    //MARK: *** Action
    override func viewWillAppear(_ animated: Bool) {
        self.searchBarSetup()
        print("\n 🚦 Danh sách bàn =========================")
        tablesOrigial = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
        Tables = tablesOrigial
        Areas = GetAreasFromSQLite(query: "SELECT * FROM KhuVuc")
        if tablesOrigial.count == 0{
            tablesOrigial = Tables
        }
        Tables_TableView.reloadData()
        Foods.removeAll()
    }
    
    @IBAction func Mageger_Button_Tapped(_ sender: Any) {
        Foods.removeAll()
        pushToVC(withIdentifier: "Manager_VC")
    }
    @IBAction func addNewTable_Button(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("Add new table", comment: " "), message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default){_ in
            _ = self.addNewTable()
            _ = Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
            _ = self.Tables_TableView.reloadData()
            _ = self.tablesOrigial = Tables
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){_ in
            
        }
        let setupNow = UIAlertAction(title: NSLocalizedString("Add new table and book", comment: " "), style: .default){_ in
            _ = indexSelected_tables = self.addNewTable() - 1
            _ = Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
            _ = self.tablesOrigial = Tables
            _ = self.pushToVC(withIdentifier: "table_detail")
            
        }
        alert.addAction(yesAction)
        alert.addAction(setupNow)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        //moveToVC(withIdentifier: "table_detail", animated: true)
    }
    // MARK: *** Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tables.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_table", for: indexPath) as! Table_TableViewCell
        cell.TableName_Label.text = NSLocalizedString("Table num", comment: " ") + "\(Tables[indexPath.row].SoBan!)"
        
        let ImageURL = localURL.appendingPathComponent(Tables[indexPath.row].HinhAnh!)
        cell.TableThumnail_ImageView.image = UIImage(contentsOfFile: ImageURL.path)
        
        for i in 0..<Areas.count{
            if Areas[i].MaKV! == Tables[indexPath.row].MaKV!{
                cell.Position_Label.text = Areas[i].TenKV
                break;
            }
        }

        
        
        
        let  NotSetupColor  = UIColor.init(red: 0/255.0, green: 128.0/255.0, blue: 1.0, alpha: 0.5)
        let didSetupColor = UIColor.init(red: 1.0, green: 128.0/255.0, blue: 0, alpha: 0.7)
        cell.backgroundColor = Tables[indexPath.row].TinhTrang == 1 ? didSetupColor:NotSetupColor
        //cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected_tables = indexPath.row
        //let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.red
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Title = Tables[indexPath.row].TinhTrang  == 1 ? "Thanh toán":"Đặt bàn"
        let payAction = UITableViewRowAction(style: .normal, title: Title) { (rowAction, indexPath) in
            Tables[indexPath.row].TinhTrang = 0
            updateRow(Tables[indexPath.row])
            self.performSegue(withIdentifier: "Seque_detailTable", sender: nil)
        }
        let delAction = UITableViewRowAction(style: .normal, title: "Xoá") { (rowAction, indexPath) in
            let soban:Int = Tables[indexPath.row].SoBan!
            if edit(query: "DELETE FROM BanAn WHERE SoBan = \(soban)"){
                Tables.remove(at: indexPath.row)
                print("Đã xoá bàn số \(soban)")
                self.Tables_TableView.reloadData()
            }
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
    
    // MARK: *** Function
    func addNewTable()->Int{
        var num:Int = Tables.count + 1
        for i in 1...Tables.count{
            if Tables[i - 1].SoBan != i{
                num = i
                break;
            }
        }
        let T = Table(SoBan: num, TinhTrang: 0, HinhAnh: "", GhiChu: "", MaKV: 1, MaHD: num)
        addRow(T)
        return num
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "Seque_detailTable" {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
     }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
