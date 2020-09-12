//
//  MoreViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 22/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBAction func appointmentBtn(_ sender: Any) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Appointment") as! CreateAppointmentViewController
//       
//        navigationController!.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
     navigationController?.navigationBar.titleTextAttributes =  [.foregroundColor: UIColor.init(named: "bgDark")]
    }
    
    @IBAction func chatBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Inbox") as! InboxViewController
        self.present(controller, animated: true, completion: nil)
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
