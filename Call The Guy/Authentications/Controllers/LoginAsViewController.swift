//
//  LaginAsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 13/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class LoginAsViewController: UIViewController {

    
    
    @IBAction func userButton(_ sender: Any) {
        Constants.userTypeId = 3
        performSegue(withIdentifier: "User2Login", sender: self)
    }
    
    @IBAction func contractorButton(_ sender: Any) {
        Constants.userTypeId = 4
        performSegue(withIdentifier: "User2Login", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc  = segue.destination as! LogInViewController
        vc.userTypeId1 = Constants.userTypeId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    

}

