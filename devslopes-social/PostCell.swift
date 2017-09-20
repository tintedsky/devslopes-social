//
//  PostCell.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-18.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg:  UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post){
        self.post = post
        self.caption.text =  post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if let url = NSURL(string: post.imageUrl){
            if let data = NSData(contentsOf: url as URL){
                postImg.image = UIImage(data: data as Data)
            }
        }
    }
}
