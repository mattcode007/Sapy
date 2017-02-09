//
//  TutorVC.swift
//  Sapy
//
//  Created by Matteo Cesari on 09/02/17.
//  Copyright © 2017 Matteo Cesari. All rights reserved.
//

import UIKit

class TutorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 8
        self.view.layer.masksToBounds = true;
        self.view.layer.borderColor = UIColor.gray.cgColor;
        self.view.layer.borderWidth = 0;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
