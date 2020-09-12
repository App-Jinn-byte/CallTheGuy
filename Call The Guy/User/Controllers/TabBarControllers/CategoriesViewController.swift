//
//  CategoriesViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 21/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public var categoryList: [CategoriesListModelResponse] = []
    lazy var  refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadApi), for: .valueChanged)
        return refresh
    }()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self
       // setNavigationBar()
       
       CollectionView.refreshControl = refresher
       navigationController?.navigationBar.titleTextAttributes =  [.foregroundColor: UIColor.init(named: "bgDark")]
        
         self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        if Reachability.isConnectedToNetwork(){
        activityIndicator.startAnimating()
        APIRequest.GetAllCategories(completion: APIRequestCompleted)
        }
        else {
            activityIndicator.stopAnimating()
            //print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    @IBAction func chatBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Inbox") as! InboxViewController
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func logOutbtn(_ sender: Any) {
   Constants.Alert1(title: "LogOut", message: "Are You sure to want to logout", controller: self, action: handlerSuccess())
        
    }
    @objc func reloadApi(){
        print("helloWorld")
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            if Reachability.isConnectedToNetwork(){
                self.activityIndicator.startAnimating()
                APIRequest.GetAllCategories(completion: self.APIRequestCompleted)
            }
            else {
                self.activityIndicator.stopAnimating()
                //print("Internet connection not available")
                
                Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
            }
            self.refresher.endRefreshing()
        }
    }
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let list = try decoder.decode([CategoriesListModelResponse].self, from: data)
                categoryList = list
                Constants.catList = self.categoryList
            
                print(categoryList)
                
                print(list)
//                print(list.Name)
//                print(list.Image)
                
                //Constants.Alert(title: "Success", message: "\(loginResponse.UserName)Successfully LoggedIn", controller: self)
                self.CollectionView.reloadData()
                activityIndicator.stopAnimating()
            }
            catch {
            
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Hello", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Error", controller: self)
        }
    }
    
    //Mark:- Stubs for Collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.categoryList = categoryList[indexPath.row]
        cell.setData()
        //performSegue(withIdentifier: "BlogDetail", sender: self)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categoryList[indexPath.row].Name!)
        Constants.catId = categoryList[indexPath.row].CategoryId
        Constants.catName = categoryList[indexPath.row].Name!
        print(Constants.catId)
        performSegue(withIdentifier: "Contractors", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc  = segue.destination as! ContractersViewController
        vc.catId = Constants.catId
    }
    //MarK-: Custom Navigation Bar
    func setNavigationBar(){
//        let chatIcon = UIImageView.init(image: UIImage.init(named: "chatIcon"))        // Do any additional setup after loading the view.
//        chatIcon.frame = CGRect(x: 0 , y:0 , width:34, height:34)
//        chatIcon.contentMode = .scaleAspectFit
//        navigationItem.titleView = chatIcon
//
//        let exitButton = UIButton(type: .system)
//        exitButton.setImage(UIImage.init(named: "exitIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        exitButton.frame = CGRect(x: 0 , y:0 , width:34, height:34)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
//
//        let chatButton = UIButton(type: .system)
//        chatButton.setImage(UIImage.init(named: "chatIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        chatButton.frame = CGRect(x: 0 , y:0 , width:34, height:34)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: chatButton)
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
