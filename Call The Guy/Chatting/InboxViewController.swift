//
//  ChatListViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 12/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit
import Kingfisher
class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    var lastMsgArray = [String]()
    var timestampArray = [String]()
    var senderIdArray = [Int]()
    var contIdArray = [String]()
    var senderNameArray = [String]()
    var userLabel = [String]()
     var profilePic = [String]()
    //var userName:String?
    var imagestr = URL(string: "")
    
    @IBOutlet weak var chatListTableView: UITableView!
    var ref:DatabaseReference!
    //Inview DidLOAD
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UITextField.appearance().tintColor = .white
        //  self.firebaseChatTestingLawyer()
        
        chatListTableView.delegate = self
        ref = Database.database().reference()
        firebaseChatTestingLawyer()
        // self.ref.child("users").child("Mamoon").setValue(["CNIC": "1234"])
        
//        ref.child("chats").child("\(Constants.userId)").observe(.childChanged) { (snapshot) in
//            print("child changed")
//
//            if Constants.userTypeId == 3{
//                self.fetchImages()
//                self.fetchImages()
//
//
//            }else if Constants.userTypeId == 4{
//                self.fetchImages()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UITextField.appearance().tintColor = .white
        firebaseChatTestingLawyer()
    }
    override func viewWillAppear(_ animated: Bool) {
        
   // firebaseChatTestingLawyer()
    
    }
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func firebaseChatTestingLawyer(){
        
        self.lastMsgArray.removeAll()
        self.timestampArray.removeAll()
        self.senderIdArray.removeAll()
        self.senderNameArray.removeAll()
        self.profilePic.removeAll()
        
        self.ref.child("chats").child("\(Constants.userId)").observeSingleEvent(of: .value) { (snapshot) in
            
            self.lastMsgArray.removeAll()
            self.timestampArray.removeAll()
            self.senderIdArray.removeAll()
            self.senderNameArray.removeAll()
            self.profilePic.removeAll()
            
            print(snapshot.children)
            
            for child in snapshot.children{
                
                print(child)
                
                let lastmsg_snap = child as! DataSnapshot
                print(lastmsg_snap.key)
                // print(lastmsg_snap.key,"mamoon is the key to success.")
                let dict = lastmsg_snap.value as! [String: Any]
                
                let msg = dict["message"] as? String
                let time = dict["timeStamp"] as? String
                let senderId = dict["senderId"] as? String
                let senderName = dict["senderName"] as? String
                let profilePic = dict["profileImage"] as? String
                self.lastMsgArray.append(msg!)
                // self.timestampArray.append(time!)
                self.senderIdArray.append(Int(senderId!)!)
                self.senderNameArray.append(senderName!)
                self.contIdArray.append(lastmsg_snap.key)
                self.profilePic.append(profilePic!)
                
                if self.lastMsgArray.count == 0{
                    //    self.noRecordFoundView.isHidden = false
                    
                }else{
                    // self.noRecordFoundView.isHidden = true
                    self.chatListTableView.reloadData()
                }
                
            }
            
            
            print("mamoon")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastMsgArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meassgaeListCell") as! InboxTableViewCell
        
        
//        let nameLabel = cell?.viewWithTag(111) as? UILabel
//        let dateLabel = cell?.viewWithTag(222) as? UILabel
//        let msgLabel = cell?.viewWithTag(333) as? UILabel
//        let img = cell?.viewWithTag(444) as? UIImageView
        
        cell.usernameLabel.text = senderNameArray[indexPath.row]
        cell.lastmessageLabel.text = lastMsgArray[indexPath.row]
        //nameLabel?.text = senderNameArray[indexPath.row]
        // dateLabel?.text = timestampArray[indexPath.row]
        //msgLabel?.text = lastMsgArray[indexPath.row]
        
        
        let urlString = profilePic[indexPath.row].addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
       let url  = URL(string: urlString!)
        // userImageView.kf.setImage(with: url)
        //img?.kf.setImage(with: url)
        cell.userIV.kf.setImage(with: url)
        //userImageView.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if Constants.userTypeId == 3{
            print(contIdArray)
            let intArrayContId = contIdArray.map { Int($0)!}
            print(intArrayContId)
            //         ChattingHelper.contractorId = senderIdArray[indexPath.row]
            
            ChattingHelper.senderName = senderNameArray[indexPath.row]
            ChattingHelper.contractorId = intArrayContId[indexPath.row]
            
            let chattingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ChatBox") as! ChattingViewController
            chattingViewController.userName = ChattingHelper.senderName
            self.present(chattingViewController, animated: true, completion: nil)
        }
            
        else if Constants.userTypeId == 2{
            
            ChattingHelper.contractorId = senderIdArray[indexPath.row]
            ChattingHelper.senderName = senderNameArray[indexPath.row]
            
            let chattingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ChatBox") as! ChattingViewController
            chattingViewController.userName = ChattingHelper.senderName
            self.present(chattingViewController, animated: true, completion: nil)
        }
        
    }
    
}
