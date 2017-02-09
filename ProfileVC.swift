//
//  ProfileVC.swift
//  Sapy
//
//  Created by Matteo Cesari on 09/02/17.
//  Copyright © 2017 Matteo Cesari. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var switcher: UISwitch!
    let uid = FIRAuth.auth()?.currentUser?.uid
    let channelRef = FIRDatabase.database().reference()
    let utente = FIRAuth.auth()?.currentUser?.displayName
   
    @IBAction func tutorchanged(_ sender: Any) {
        
        if switcher.isOn {
            
            self.channelRef.updateChildValues(["users/\(uid)/tutor":true,"tutor/\(uid)":true])
            
        }else {
            
            self.channelRef.updateChildValues(["users/\(uid)/tutor":false,"tutor/\(uid)":false])
        }
    }
    
    
    
    
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Profilo"
    
        username.text = utente
        
        
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
