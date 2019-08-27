//
//  IndexViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/20.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //    var model: IndexTableViewModel?
    
    let model = generateRandomData()
    
    @IBOutlet weak var indexTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexTableView.delegate = self
        indexTableView.dataSource = self
        indexTableView.estimatedRowHeight = 200
        indexTableView.rowHeight = UITableView.automaticDimension
        indexTableView.contentInsetAdjustmentBehavior = .never
        //        model = getModel()
        // Do any additional setup after loading the view.
    }
    
    func getModel() -> IndexTableViewModel {
        
        let date: IndexTableViewModel
        var postLives: [PostLive] = []
        var posts: [Post] = []
        
        postLives.append(PostLive(PostAddUserId: "123", PostDate: "20190825"))
        posts.append(Post(StoreName: "Luke", StoreAddress: "Taiwan", PostImg: [], PostContent: "TEST POST", PostTag: "Good Goods", PostDate: "20190825", PostAddUserId: "123", LikeCount: 1, MessageCount: 2))
        
        date = IndexTableViewModel(PostLives: postLives, Posts: posts)
        
        return date
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        //        if let liveCell = indexTableView.dequeueReusableCell(withIdentifier: "LiveTableCell") as? LiveTableViewCell {
        //            cell = liveCell
        //        }
        
        if indexPath.item == 0 {
            if let liveCell = indexTableView.dequeueReusableCell(withIdentifier: "LiveTableCell") as? LiveTableViewCell {
                cell = liveCell
            }
        } else {
            if let postCell = indexTableView.dequeueReusableCell(withIdentifier: "PostTableCell") as? PostTableViewCell {
//                postCell.contentLB.text = "快樂的一刻\n勝過永恆的難過\n黑夜過後就有日出和日落\n兩個人走不會寂寞\n幸有你愛我"
                postCell.contentLB.text = "快樂的一刻\n勝過永恆的難過\n黑夜過後就有日出和日落\n兩個人走不會寂寞\n幸有你愛我\n快樂的一刻\n勝過永恆的難過\n黑夜過後就有日出和日落\n兩個人走不會寂寞\n幸有你愛我\n快樂的一刻\n勝過永恆的難過\n黑夜過後就有日出和日落\n兩個人走不會寂寞\n幸有你愛我"
                postCell.likeCountLB.text = "100000000"
                postCell.messageCountLB.text = "10000"
                cell = postCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? LiveTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    //
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return 100
    //    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return UITableView.automaticDimension
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        let imageRatio: CGFloat
    //
    //        if indexPath.item == 0 {
    //            imageRatio = CGFloat(100)
    //        } else {
    //            imageRatio = CGFloat(550)
    //        }
    //
    //        return imageRatio
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//extension UIImage {
//    func getImageRatio() -> CGFloat {
//        
//        let imageRatio = CGFloat(80 / 80)
//        
//        return imageRatio
//    }
//}

extension IndexViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionCell", for: indexPath)
        
        return cell
    }
}

