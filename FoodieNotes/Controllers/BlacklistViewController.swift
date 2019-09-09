//
//  BlacklistViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/10.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class BlacklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var blacklistTableView: UITableView!
    
    let model = generateRandomData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blacklistTableView.delegate = self
        blacklistTableView.dataSource = self
        blacklistTableView.separatorStyle = .none
        blacklistTableView.estimatedRowHeight = 44.0
        blacklistTableView.rowHeight = UITableView.automaticDimension
        blacklistTableView.contentInsetAdjustmentBehavior = .never
        
        blacklistTableView.register(UINib(nibName:"BlacklistTableViewCell", bundle:nil),forCellReuseIdentifier:"BlacklistTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToSetUpPag(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if let blacklistTableViewCell = blacklistTableView.dequeueReusableCell(withIdentifier: "BlacklistTableViewCell") as? BlacklistTableViewCell {
            
            blacklistTableViewCell.blacklistUserName.text = "Luke Chen"
            blacklistTableViewCell.blacklistRemoveButton.addTarget(self,action: #selector(BlacklistViewController.removeBlacklist(_:)), for: .touchUpInside)
            cell = blacklistTableViewCell
        }
        
        return cell
    }
    
    @IBAction func removeBlacklist(_ sender:UIButton) {
        print("============REMOVE!!!!===============")
        
        blacklistTableView.reloadData()
    }

}
