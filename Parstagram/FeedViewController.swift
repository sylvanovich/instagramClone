//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Joseph Sylvanovich on 3/16/19.
//  Copyright © 2019 Joseph Sylvanovich. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var numberofPosts: Int!
    let myrefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        myrefreshControl.addTarget(self, action: #selector(viewDidAppear(_:)), for: .valueChanged)
        tableView.refreshControl = myrefreshControl
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo")
        imageView.image = image
        
        self.navigationItem.titleView = imageView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        numberofPosts = 10
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = numberofPosts
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground{ ( posts, error ) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myrefreshControl.endRefreshing()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        cell.captionViewLabel.text = post["caption"] as! String
 //       cell.userNameLabel.text = user.username
  //      cell.captionViewLabel.text = post["caption"] as! String
        
        tableView.allowsSelection = false
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
