//
//  SelectCategoriesViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 21/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol categoriesProtocol {
    func sendName(catNames: [String])
    func sendId(catId: [Int])
}
class SelectCategoriesViewController: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesTableView: UITableView!
    var delegate: categoriesProtocol?
    var categoryList = [CategoriesListModelResponse]()
    var categoriesId = [Int]()
    var categoriesName = [String]()
    //var delegate: categoriesProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = .clear
        categoriesTableView.delegate = self
        if Reachability.isConnectedToNetwork(){
        APIRequest.GetAllCategories(completion: APIRequestCompleted)
        activityIndicator.startAnimating()
        }
        else{
            Constants.Alert(title: "Connection Error", message: "Plz make sure you are connected to internet", controller: self)
        }
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height/2
        doneBtn.clipsToBounds = true
       
        
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
                self.categoriesTableView.reloadData()
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
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getId(_ sender: Any) {
        for cats in categoryList {
            if cats.isCheck == true{
            self.categoriesId.append(cats.CategoryId)
            }
        }
        for cats in categoryList{
            if cats.isCheck == true{
                self.categoriesName.append(cats.Name ?? "nil")
            }
        }
      helloPrint()
        self.delegate?.sendId(catId: categoriesId)
        self.delegate?.sendName(catNames: categoriesName)
        
        self.dismiss(animated: true, completion: nil)
//        let vc = RegisterationViewController()
//        vc.categoriesId = categoriesId
//        vc.categoriesName = categoriesName
 //       self.performSegue(withIdentifier: "Back", sender: nil)
    }
    func helloPrint(){
        print(categoriesId)
        print(categoriesName)
//        let vc = RegisterationViewController()
//        vc.categoriesId = self.categoriesId
//        vc.categoriesName = self.categoriesName
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        let vc = segue.destination as? RegisterationViewController
//        vc?.categoriesName = self.categoriesName
//        vc?.categoriesId = self.categoriesId
//        vc?.controller = "categories"
//    }
}
extension SelectCategoriesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell") as! SelectCategoryTableViewCell
        
        cell.categoriesdata = categoryList[indexPath.row]
        cell.count = indexPath.row
        cell.setData()
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
    }
}
extension SelectCategoriesViewController: indexPathdelegate{
    func onClick(indexPath: Int) {
        categoryList[indexPath].isCheck = !categoryList[indexPath].isCheck
        self.categoriesTableView.reloadRows(at: [IndexPath.init(row: indexPath, section: 0)], with: .automatic)
    }
}
