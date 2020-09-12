//
//  ContractersViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 10/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class ContractersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var catId = 0
    var thisId = 0
    var contList1:[ContractorsModelResponse] = []
    @IBOutlet weak var contractersTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        contractersTableView.delegate = self
        
        let param:[String:Any] = ["catId":catId]
        
        if Reachability.isConnectedToNetwork(){
           activityIndicator.startAnimating()
        APIRequest.GetAllContractors(completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let contractors = try decoder.decode([ContractorsModelResponse].self, from: data)
                contList1 = contractors
                contractersTableView.reloadData()
                print(contList1.count)
//                print(contractors.list[0].UserName)
//                print(contList1[0].UserId)
//                print(contList1[0])
//                print(contList1.count)
                activityIndicator.stopAnimating()
                //                let nextViewController =  self.storyboard!.instantiateViewController(withIdentifier: "SearchContractors") as! SearchContractorsListViewController
                //                nextViewController.modalTransitionStyle = .partialCurl
                //                self.present(nextViewController,animated:true,completion:nil)
               // performSegue(withIdentifier: "Search", sender: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contList1.count
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contractors") as! ContractersTableViewCell
        
        
         cell.usernameLabel.text = contList1[indexPath.row].UserName
        cell.categoryNameLabel.text = Constants.catName
        self.thisId = contList1[indexPath.row].UserId
        //cell.profileBtn.tag = indexPath.row
        //cell.profileBtn.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        // print(contList1)
        var imagePaths = contList1[indexPath.row].ImagePath ?? ""
//        print (imagePaths)

        if (imagePaths == ""){
            let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            if  let url = URL(string: urlString!)  {
                print(url)
                cell.profileImageView.kf.setImage(with: url)
            }

            else{
                print(imagePaths)
                let url1 = URL(string: "https://www.growthengineering.co.uk/wp-content/uploads/2014/05/Interaction-design-user-experience.png")
                cell.profileImageView.kf.setImage(with: url1)
            }
        }
        else{
            imagePaths = String(imagePaths.dropFirst(3))
            print(imagePaths)
            imagePaths = "https://www.calltheguy.co.za/"+imagePaths
            print(imagePaths)
            let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print(urlString)

            if  let url = URL(string: urlString!)  {
                print(url)
                cell.profileImageView.downloadImage(from: url)
            }

            else{
                print(imagePaths)
                let url1 = URL(string: "https://www.growthengineering.co.uk/wp-content/uploads/2014/05/Interaction-design-user-experience.png")
                cell.profileImageView.downloadImage(from: url1!)
            }
        }
        
        let answerButton:UIButton = cell.viewWithTag(111) as! UIButton
        answerButton.addTarget(self, action: #selector(Chat_actionButton(sender:)), for: .touchUpInside)
        
        let profileButton:UIButton = cell.viewWithTag(12345) as! UIButton
        profileButton.addTarget(self, action: #selector(profile_Button(sender:)), for: .touchUpInside)
        return cell
    }
    
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            indexPath1 = indexPath.row
//            print(indexPath)
//            performSegue(withIdentifier: "contractorProfile", sender: self)
//        }
    
//    @objc func buttonClicked(sender:UIButton) {
//            performSegue(withIdentifier: "contractorProfile", sender: self)
//            //let buttonRow = sender.tag
//        }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc  = segue.destination as! ContractorProfileViewController
//        vc.userId = thisId
//    }
    
    @objc func Chat_actionButton(sender: UIButton){
        
        let position: CGPoint = sender.convert(.zero, to: self.contractersTableView)
        let indexPath = self.contractersTableView.indexPathForRow(at:position)
        let cell: UITableViewCell = self.contractersTableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        ChattingHelper.contractorId = contList1[indexPath!.row].UserId
        ChattingHelper.senderName = contList1[indexPath!.row].UserName ?? "Anonymous"
        print(ChattingHelper.contractorId)
        print(ChattingHelper.senderName)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatBox") as! ChattingViewController
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func profile_Button(sender: UIButton){
        
        let position: CGPoint = sender.convert(.zero, to: self.contractersTableView)
        let indexPath = self.contractersTableView.indexPathForRow(at:position)
        let cell: UITableViewCell = self.contractersTableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //ChattingHelper.contractorId = contList1[indexPath!.row].UserId
        print(ChattingHelper.contractorId)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContracterProfile") as? ContractorProfileViewController
        vc?.userId = contList1[indexPath!.row].UserId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
