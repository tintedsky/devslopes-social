//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-15.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAddIcon: CircleView!
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                       let key = snap.key
                       let post = Post(postKey: key, postData: postDict)
                       self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    //Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
            }else{
                cell.configureCell(post: post)
            }
            return cell
        }else{
            return PostCell()
        }
}
    
    @IBAction func signOutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESSHB: keychain removed ")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Hongbo: Here we need to pay attention to, to get the selected image from imagePicker
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAddIcon.image = image
        }else{
            print("JESSHB: A valid image wasn't selected")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}
