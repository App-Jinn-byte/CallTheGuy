//
//  MainTabBarController.swift
//  Call The Guy
//
//  Created by JanAhmad on 21/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor.init(named: "bgDark")
        self.tabBar.tintColor = .white
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.tabBar.selectionIndicatorImage = getImageWithColorPosition(color: UIColor.init(named: "TabBarUnderline")!, size: CGSize(width:(appDelegate.window?.frame.size.width)!/5 - 20,height: 49), lineSize: CGSize(width:(appDelegate.window?.frame.size.width)!/5 - 20, height:2))
        
//        if let tabBarItems = self.tabBar.items {
//            
//            for (_,item) in tabBarItems.enumerated() {
//                item.image = item.image?.withRenderingMode(.alwaysOriginal)
//                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
//            }
//        }
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x: 0, y: size.height-lineSize.height, width: lineSize.width, height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

