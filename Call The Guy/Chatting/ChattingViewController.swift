//
//  ChattingViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 12/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit
import IQKeyboardManagerSwift

struct MyMessage {
    var id: String
    var content: String
}

struct FireBaseMessages {
    var id:Int
    var content:String
    var date_Time:String
}

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userName: String?
    let myId = "123"
    var messages = [MyMessage]()
    var contracterProfilePic = ""
    var userProfilePic = ""
    
    var firebaseMessage_struct_Array = [FireBaseMessages]()
    
    var ref:DatabaseReference!
    
    @IBOutlet weak var messageScrollView: UIScrollView!
    @IBOutlet weak var nameHeadingLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var chattingController: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Constants.userId)
        ref = Database.database().reference()
        dismissKeyboard()
        fetchImagesForContracter()
        fetchImagesForUser()
        //self.messageTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        //self.messageTableView.scrollToLastRow(animated: true)
       // self.scrollToLast()
       // self.messageScrollView.scrollToBottom(animated: true)
        //nameHeadingLabel.text = ChattingHelper.senderName
        //self.navigationItem.title = ChattingHelper.senderName
        
        self.chattingController.topItem?.title = ChattingHelper.senderName
        
        //self.title = ChattingHelper.senderName
        //self.chattingController.bart = ChattingHelper.senderName
        UITextField.appearance().tintColor = .black 
        ref = Database.database().reference()
        //        let msg0 = MyMessage(id: "123", content: "This is.")
        //        let msg1 = MyMessage(id: "223", content: "This is message This is message This is message This is message This is messageThis is message This is message This is message This is message")
        
        
        //        messages.append(msg0)
        //        messages.append(msg1)
        
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.register(UINib(nibName: "RightTableViewCell", bundle: nil), forCellReuseIdentifier: "message_cell")
        messageTableView.register(UINib(nibName: "LeftTableViewCell", bundle: nil), forCellReuseIdentifier: "message_cell")
        
        messageTableView.separatorStyle = .none
        
//        let child_Added_Reference = self.ref.child("messages").child("\(Constants.userId)")
//
//
//        child_Added_Reference.observe(.childAdded) { (snapshot) in
//            print("printing snapshot of messages",snapshot)
//
//            print("child is adding bro")
//            //            below for loop code is just for the notification handing purpose
//            var senderid = 0
//            var query_created_by = 0
//
//
//            self.LoadOldMessages()
//            print(Constants.userId)
        
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
//                self.scrollToLast()
//                self.messageScrollView.scrollToBottom(animated: true)
//            })
       // }
        //self.setTable()
    }
    
    func fetchImagesForContracter(){
        
        self.ref.child("users").child("\(ChattingHelper.contractorId)").observeSingleEvent(of: .value) { (snapshot) in
            
            
            print(snapshot.children)
            
            for child in snapshot.children{
                
                print(child)
                
                let dict = snapshot.value as! [String: Any]
                
                let imagePath = dict["profileImage"] as? String
                //                    let time = dict["timeStamp"] as? String
                //                    let senderId = dict["senderId"] as? String
                //                    let senderName = dict["senderName"] as? String
                
                self.contracterProfilePic = imagePath!
                // self.timestampArray.append(time!)
                //                    self.senderIdArray.append(Int(senderId!)!)
                //                    self.senderNameArray.append(senderName!)
                //                    self.contIdArray.append(lastmsg_snap.key)
            }
          //  self.LoadOldMessages()
        }
    }
    
    func fetchImagesForUser(){
        
        self.ref.child("users").child("\(Constants.userId)").observeSingleEvent(of: .value) { (snapshot) in
            
            
            print(snapshot.children)
            
            for child in snapshot.children{
                
                print(child)
                
                let dict = snapshot.value as! [String: Any]
                
                let imagePath = dict["profileImage"] as? String
                //                    let time = dict["timeStamp"] as? String
                //                    let senderId = dict["senderId"] as? String
                //                    let senderName = dict["senderName"] as? String
                
                self.userProfilePic = imagePath!
                // self.timestampArray.append(time!)
                //                    self.senderIdArray.append(Int(senderId!)!)
                //                    self.senderNameArray.append(senderName!)
                //                    self.contIdArray.append(lastmsg_snap.key)
            }
            self.LoadOldMessages()
        }
    }
    
//    func setTable(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//            self.scrollToLast()
//            self.messageScrollView.scrollToBottom(animated: true)
//        })
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.LoadOldMessages()
        //setTable()
       // self.messageScrollView.scrollToBottom(animated: true)
       //self.messageTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
       // self.messageTableView.scrollToLastRow(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
      //  self.messageScrollView.scrollToBottom(animated: true)
      //self.messageTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        //self.messageTableView.scrollToLastRow(animated: true)
        //self.setTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseMessage_struct_Array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = firebaseMessage_struct_Array[indexPath.row]
        if msg.id == Constants.userId {
            
            let cell = Bundle.main.loadNibNamed("RightTableViewCell", owner: self, options: nil)?.first as! RightTableViewCell
            cell.contentTV.text = msg.content
            return cell
        }
        else {
            let cell = Bundle.main.loadNibNamed("LeftTableViewCell", owner: self, options: nil)?.first as! LeftTableViewCell
            cell.contentTV.text = msg.content
            return cell
        }
    }
    
    @IBAction func sendMessageBtnAction(_ sender: Any) {
        if self.messageTF.text == "" || (messageTF?.text!.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            return
        }
        var userId = 3
        var contracterId = 4
        if userId == 3 {
            // Mark:- user loogedin as user not contracter
            let timeStamp = ServerValue.timestamp()
            self.ref.child("messages").child("\(Constants.userId)").child("\(ChattingHelper.contractorId)").childByAutoId().setValue([
                "timeStamp":timeStamp,
                "message":messageTF.text!,
                "senderId":"\(Constants.userId)",
                //"senderId":"2345",
                //                "categoryId":"\(Constants.catId)",
                
                "senderName":"\(Constants.userName)"
                ])
            
            
            // the second message is for the mirrored chatting from the user.! to whom the lawyer messsaged ...
            // change user id with the query created by id
            
            self.ref.child("messages").child("\(ChattingHelper.contractorId)").child("\(Constants.userId)").childByAutoId().setValue(["timeStamp":timeStamp,
                                                                                                                                      "message":messageTF.text!,
                                                                                                                                      "senderId":"\(Constants.userId)",
                //"senderId":"2345",
                "categoryId":"\(Constants.catId)",
                
                "senderName":"\(ChattingHelper.senderName)",
                ])
            
            //BELOW FIREBSAE REERENCES ARE JUST TO FETCH THE LAT MESSAGE OF USER
            self.ref.child("chats").child("\(Constants.userId)").child("\(ChattingHelper.contractorId)").setValue([
                "timeStamp":timeStamp,
                "message":messageTF.text!,
                "senderId":"\(ChattingHelper.contractorId)",
                //"senderId":"2345",
                //                "categoryId":"\(Constants.catId)",
                
                "senderName":"\(ChattingHelper.senderName)",
                "profileImage":"\(contracterProfilePic)"
                ])
            
            self.ref.child("chats").child("\(ChattingHelper.contractorId)").child("\(Constants.userId)").setValue([
                "timeStamp":timeStamp,
                "message":messageTF.text!,
                "senderId":"\(Constants.userId)",
                //"senderId":"2345",
                //                "categoryId":"\(Constants.catId)",
                "senderName":"\(Constants.userName)",
                "profileImage":"\(userProfilePic)"
                //"sendToName": "\(Constants.userId)"
                ])
            
        }
        
        //        else if contracterId == 4 {
        //            // Mark:- user loogedin as contracter not user
        //            let timeStamp = ServerValue.timestamp()
        //            self.ref.child("messages").child("\(Constants.userId)").child("\(ChattingHelper.senderId)").childByAutoId().setValue([
        //                "timeStamp":timeStamp,
        //                "message":messageTF.text!,
        //                "senderId":"\(Constants.userId)",
        //                //"senderId":"2345",
        //                "categoryId":"\(Constants.catId)",
        //
        //                "senderName":"\(Constants.userId)"
        //                ])
        //
        //
        //            // the second message is for the mirrored chatting from the user.! to whom the lawyer messsaged ...
        //            // change user id with the query created by id
        //
        //            self.ref.child("messages").child("\(ChattingHelper.senderId)").child("\(Constants.userId)").childByAutoId().setValue([
        //                "timeStamp":timeStamp,
        //                "message":messageTF.text!,
        //                "senderId":"\(Constants.userId)",
        //                //"senderId":"2345",
        //                "categoryId":"\(Constants.catId)",
        //
        //                "senderName":"\(Constants.userId)",
        //                ])
        //
        //
        //            self.ref.child("chats").child("\(Constants.userId)").child("\(ChattingHelper.senderId)").childByAutoId().setValue([
        //                "timeStamp":timeStamp,
        //                "message":messageTF.text!,
        //                "senderId":"\(Constants.userId)",
        //                //"senderId":"2345",
        //                "categoryId":"\(Constants.catId)",
        //
        //                "senderName":"\(ChattingHelper.senderName)"
        //                ])
        //            self.ref.child("chats").child("\(ChattingHelper.senderId)").child("\(Constants.userId)").setValue([
        //                "timeStamp":timeStamp,
        //                "message":messageTF.text!,
        //                "senderId":"\(ChattingHelper.contractorId)",
        //                //"senderId":"2345",
        //                "categoryId":"\(Constants.catId)",
        //
        //                "senderName":"\(Constants.userName)"
        //                ])
        //        }
        messageTF.text = ""
        self.LoadOldMessages()
//        self.messageTableView.scrollToLastRow(animated: true)
//        self.messageTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
    }
//
//    func scrollToLast() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(5)) {
//            let lastIndex = IndexPath(row: self.messageTableView.numberOfRows(inSection: 0) - 1, section: 0)
//            if lastIndex.row != -1 {
//                self.messageTableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
//            }
//        }
//    }
    
    private func LoadOldMessages(){
        
        self.firebaseMessage_struct_Array.removeAll()
        let reference_To_Database = ref.child("messages").child("\(Constants.userId)")
        reference_To_Database.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.childrenCount > 0{
                
                if Constants.userTypeId == 3{
                    self.ref.child("messages").child("\(Constants.userId)").child("\(ChattingHelper.contractorId)").observeSingleEvent(of: .value, with: { (snapshot) in
                        print(ChattingHelper.contractorId)
                        print(Constants.userId)
                        self.firebaseMessage_struct_Array.removeAll()
                        
                        for child in snapshot.children{
                            
                            let user_snap = child as! DataSnapshot
                            let dict = user_snap.value as! [String: Any]
                            
                            let msg = dict["message"] as? String
                            let time = dict["timeStamp"] as? String
                            let senderids = dict["senderId"] as? String
                            let senderid = Int(senderids!)
                            let the_Message = FireBaseMessages(id: senderid!,content: msg!, date_Time: "10 may 2019")
                            self.firebaseMessage_struct_Array.append(the_Message)
                            //
                        }
                        self.messageTableView.reloadData()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                            self.scrollToLast()
//                            self.messageScrollView.scrollToBottom(animated: true)
//                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                            
                            if  self.firebaseMessage_struct_Array.count == 0{
                                print("Empty")
                            }else{
                                                            let indexPath = IndexPath(row: self.firebaseMessage_struct_Array.count-1, section: 0)
                                                            self.messageTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                            }
                            
                        })
                        
                        
                        
                    })
                    
                }
                    
                else if Constants.userTypeId == 2 {
                    
                    self.ref.child("messages").child("\(Constants.userId)").child("\(ChattingHelper.contractorId)").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.firebaseMessage_struct_Array.removeAll()
                        
                        
                        for child in snapshot.children{
                            
                            let user_snap = child as! DataSnapshot
                            let dict = user_snap.value as! [String: Any]
                            
                            let msg = dict["message"] as? String
                            let time = dict["timeStamp"] as? String
                            let senderids = dict["senderId"] as? String
                            let senderid = Int(senderids!)
                            let the_Message = FireBaseMessages(id: senderid!,content: msg!, date_Time: "10 may 2019")
                            self.firebaseMessage_struct_Array.append(the_Message)
                            //
                        }
                        self.messageTableView.reloadData()
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                            
                            if  self.firebaseMessage_struct_Array.count == 0{
                                print("Empty")
                            }else{
                                                            let indexPath = IndexPath(row: self.firebaseMessage_struct_Array.count-1, section: 0)
                                                            self.messageTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                            }
                            
                        })
                        
                        
                        
                    })
                    
                }
                
                
            }
            
            
            
            
        }
        //        self.messageTableView.scrollToLastRow(animated: true)
        //        self.messageTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
       // self.setTable()
        
    }
  
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UITableView {
    //    func setOffsetToBottom(animated: Bool) {
    //        self.setContentOffset(CGPointMake(0, self.contentSize.height - self.frame.size.height), animated: true)
    //    }
    
    func scrollToLastRow(animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: NSIndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
        }
    }
    
}
//extension UIScrollView {
//
//    func scrollToBottom(animated: Bool) {
//        var y: CGFloat = 0.0
//        let HEIGHT = self.frame.size.height
//        if self.contentSize.height > HEIGHT {
//            y = self.contentSize.height - HEIGHT
//        }
//        self.setContentOffset(CGPointMake(0, y), animated: animated)
//    }
//}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.size.height else { return }
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
