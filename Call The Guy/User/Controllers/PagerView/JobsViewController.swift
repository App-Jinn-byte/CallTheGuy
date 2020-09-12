//
//  JobsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 30/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import PageMenu

class JobsViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    
    @IBOutlet weak var parentView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
            
        let navBar = self.navigationController?.navigationBar
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "bgDark")]
        
        var controllerArray : [UIViewController] = []
        if (Constants.userTypeId == 3){
        let vc1 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompletedJobsViewController") as? CompletedJobsViewController
        vc1?.navController = self.navigationController
        vc1?.title = "Completed"
        
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InProgressJobsViewController") as? InProgressJobsViewController
        vc2?.navController = self.navigationController
        vc2?.title = "In-Progress"
        let vc3 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PendingJobsViewController") as? PendingJobsViewController
        vc3?.navController = self.navigationController
        vc3?.title = "Pending"
        let vc4 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RejectedJobsViewController") as? RejectedJobsViewController
        vc4?.title = "Rejected"
        vc4?.navController = self.navigationController
        controllerArray.append(vc1!)
        controllerArray.append(vc2!)
        controllerArray.append(vc3!)
        controllerArray.append(vc4!)
        }
        else if (Constants.userTypeId == 4){
            let vc1 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompletedJobsViewController") as? CompletedJobsViewController
            vc1?.navController = self.navigationController
            vc1?.title = "Completed"
            
            let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InProgressJobsViewController") as? InProgressJobsViewController
            vc2?.navController = self.navigationController
            vc2?.title = "In-Progress"
            let vc3 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PendingJobsViewController") as? PendingJobsViewController
            vc3?.navController = self.navigationController
            vc3?.title = "Pending"
            let vc4 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RejectedJobsViewController") as? RejectedJobsViewController
            vc4?.title = "Rejected"
            vc4?.navController = self.navigationController
            controllerArray.append(vc1!)
            controllerArray.append(vc2!)
            controllerArray.append(vc3!)
            controllerArray.append(vc4!)
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorPercentageHeight(0.3),
            .selectionIndicatorColor(UIColor(named: "bgDark")!),
            //            .bottomMenuHairlineColor(.clear),
            .menuItemFont(UIFont.init(name: "Montserrat", size: 11)!),
            .scrollMenuBackgroundColor(.clear),
            .viewBackgroundColor(.clear),
            .selectedMenuItemLabelColor(.black),
            //            .addBottomMenuHairline(true),
            .scrollAnimationDurationOnMenuItemTap(5),
            .unselectedMenuItemLabelColor(.darkGray),
            //.menuMargin(4.0),
            .menuItemWidth(80.0),
            .enableHorizontalBounce(true),
            .centerMenuItems(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.parentView.addSubview(pageMenu!.view)
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func logOutButton(_ sender: Any) {
          Constants.Alert1(title: "LogOut", message: "Are You sure to want to logout", controller: self, action: handlerSuccess())
    }
    
    @IBAction func msgActionBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Inbox") as! InboxViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func handlerSuccess() -> (UIAlertAction) -> (){
        
        return { action in
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            //                let nextViewController =  self.storyboard!.instantiateViewController(withIdentifier: "LoginAs")       as! LoginAsViewController
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginAs") as! LoginAsViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootViewController
        }
    }
    

}
