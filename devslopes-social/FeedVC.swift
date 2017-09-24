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
    @IBOutlet weak var captionField: FancyField!
    
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
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
            imageSelected = true
        }else{
            print("JESSHB: A valid image wasn't selected")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //guard body cannot be fall through
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("JESSHB: Caption must be entered")
            return
        }
        
        guard let img = imageAddIcon.image, imageSelected else {
            print("JESS: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            //Use NSUUID to get an unique id for image in Firebase Storage
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("JESSHB: Unable to upload image to Firebases storage")
                }else{
                    print("JESSHB: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFirebase(imgUrl: url)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, Any> = [
            "caption" : captionField.text!,
            "imageUrl" : imgUrl,
            "likes" : 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //Reset the field
        captionField.text = ""
        imageSelected = false
        imageAddIcon.image = UIImage(named: "add-image")
        
        self.tableView.reloadData()
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}
