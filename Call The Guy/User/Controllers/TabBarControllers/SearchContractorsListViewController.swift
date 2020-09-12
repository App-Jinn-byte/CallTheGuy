//
//  SearchContractorsListViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 05/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Cosmos

class SearchContractorsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var contractorsTableView: UITableView!
    var user = 0
    var contList = [contractorsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
       print(contList.count)
        contractorsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contList.count
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchContractor") as! SearchContractorTableViewCell
        
        
        cell.usernameLabel.text = contList[indexPath.row].UserName
        cell.categoryNameLabel.text = contList[indexPath.row].CategoryName
        print(contList)
        var imagePaths = contList[indexPath.row].ImagePath ?? ""
        print (imagePaths)
        
        if (imagePaths == ""){
            let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
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
        
        //chat button action
        let answerButton:UIButton = cell.viewWithTag(111) as! UIButton
        answerButton.addTarget(self, action: #selector(Chat_actionButton(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func Chat_actionButton(sender: UIButton){
        
        let position: CGPoint = sender.convert(.zero, to: self.contractorsTableView)
        let indexPath = self.contractorsTableView.indexPathForRow(at:position)
        let cell: UITableViewCell = self.contractorsTableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        ChattingHelper.contractorId = contList[indexPth!.row].UserId
        ChattingHelper.senderName = contList[indexPath!.row].UserName ?? "anonymous"
        print(ChattingHelper.contractorId)
        print(ChattingHelper.senderName)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatBox") as! ChattingViewController
        self.present(controller, animated: true, completion: nil)
        
    }
        
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        indexPath1 = indexPath.row
//        print(indexPath)
//        performSegue(withIdentifier: "BlogDetail", sender: self)
//    }


}
