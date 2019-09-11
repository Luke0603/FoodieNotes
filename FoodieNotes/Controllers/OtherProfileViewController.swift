//
//  OtherProfileViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/10.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GoogleMaps

class OtherProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addBlacklistButton: UIButton!
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
        userTableView.estimatedRowHeight = 44.0
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.contentInsetAdjustmentBehavior = .never
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            userTableView.register(UINib(nibName:"StoreTableViewCell", bundle:nil),forCellReuseIdentifier:"StoreTableViewCell")
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            userTableView.register(UINib(nibName:"UserTableViewCell", bundle:nil),forCellReuseIdentifier:"UserTableViewCell")
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            if let storeTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as? StoreTableViewCell {
                
                storeTableViewCell.storeNameLabel.text = "Luke Chen"
                storeTableViewCell.storeFansCountLabel.text = "10000"
                storeTableViewCell.storeFollowCountLabel.text = "20000"
                storeTableViewCell.storeSummaryLabel.text = "hello everyone my name is XXX\n i like XXX\n i want be a XXX\n nice to meet you!!!!!!!!!!!!!!!!!!!!!\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX!!!!!!!!!!!!!"
                storeTableViewCell.storePriceLabel.text = "平均價位:1000"
                
                print("GMSCameraPosition<============ Start!!!!!")
                // 將視角切換至台北 101
                let camera = GMSCameraPosition.camera(withLatitude: 25.033671, longitude: 121.564427, zoom: 15.0)
                storeTableViewCell.storeMapView.camera = camera
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427)
                marker.title = "Taiwan"
                marker.snippet = "Taipei101"
                marker.map = storeTableViewCell.storeMapView
                print("GMSCameraPosition<============ End!!!!!")
                
                storeTableViewCell.frame = tableView.bounds
                storeTableViewCell.layoutIfNeeded()
                
                //重新加载单元格数据
                storeTableViewCell.reloadData()
                
                cell = storeTableViewCell
            }
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            if let userTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell {
                
                userTableViewCell.userNameLabel.text = "Luke Chen"
                userTableViewCell.userFansCountLabel.text = "10000"
                userTableViewCell.userFollowCountLabel.text = "20000"
                userTableViewCell.userSummaryLabel.text = "hello everyone my name is XXX\n i like XXX\n i want be a XXX\n nice to meet you!!!!!!!!!!!!!!!!!!!!!\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX!!!!!!!!!!!!!"
                
                userTableViewCell.frame = tableView.bounds
                userTableViewCell.layoutIfNeeded()
                
                //重新加载单元格数据
                userTableViewCell.reloadData()
                
                cell = userTableViewCell
            }
        }
        return cell
    }
    
    @IBAction func backToIndexPage(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func addBlacklistDidTouch(_ sender: Any) {
        
        
        if (addBlacklistButton.titleLabel?.textColor.isEqual(UIColor.black))! {
            print("=============addBlacklistDidTouch=============")
            addBlacklistButton.setTitle("已封鎖",for: .normal)
            addBlacklistButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
}
