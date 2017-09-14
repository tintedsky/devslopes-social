//
//  ViewController.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-12.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("JESSHB: Unable to authenticate with Facebook - \(String(describing: error))")
            }else if result?.isCancelled == true{
                print("JESSHB: User cancelled Facebook authentication")
            }else{
                print("JESSHB: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("JESSHB: Unable to authenticate with Firebase - \(String(describing: error))")
            } else{
                print("JESSHB: Successfully authenticated with Firebase")
            }
        }
    }

}

