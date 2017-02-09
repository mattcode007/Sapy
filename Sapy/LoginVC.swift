//
//  ViewController.swift
//  StudIO
//
//  Created by Matteo Cesari on 30/01/17.
//  Copyright © 2017 Matteo Cesari. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftKeychainWrapper


class LoginVC: UIViewController {
    let loginButton = FBSDKLoginButton()
    var senderDisplayName: String? // 1
    var newChannelTextField: UITextField? // 2
   
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference()
    private var channelRefHandle: FIRDatabaseHandle?

    
    
    
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
         let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // Present the main view
                let Name = FIRAuth.auth()?.currentUser?.displayName
                print("JESS\(Name)")
                let uid = FIRAuth.auth()?.currentUser?.uid
                self.channelRef.child("users/"+(uid)!).setValue(["name": Name])
                
                let keychainResult = KeychainWrapper.standard.set(Name!, forKey: KEY_UID)
                
                print("JESS: Data saved to keychain \(keychainResult)")
                
                
                
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }   
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
         if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
          print("JESS: ID found in keychain")
        
         performSegue(withIdentifier: "LoginToChat", sender: nil)
            
          
         }
    }
    
    
    // MARK: Navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController // 1
        let channelVc = navVc.viewControllers.first as! ChannelListViewController // 2
        
        channelVc.senderDisplayName = nameField?.text // 3
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

