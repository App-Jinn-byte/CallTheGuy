//
//  DisputeViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/11/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class DisputeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    lazy var  refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadApi), for: .valueChanged)
        return refresh
    }()
    
    @IBOutlet weak var disputeTableView: UITableView!
    
    var disputes = [disputeList]()
     private var emptyView: EmptyView?
    override func viewDidLoad() {
        super.viewDidLoad()
        disputeTableView.refreshControl = refresher
        emptyView = UINib(nibName: "NoDataView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! EmptyView
        disputeTableView.frame = self.view.bounds
         self.navigationItem.title = "DISPUTES"
        disputeTableView.delegate = self

       APIRequest.Disputes(completion: APIRequestCompleted)
        
        // Do any additional setup after loading the view.
    }
    @objc func reloadApi(){
        print("helloWorld")
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            
            APIRequest.Disputes(completion: self.APIRequestCompleted)
            self.refresher.endRefreshing()
        }
    }
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let disputesData = try decoder.decode(DisputeModelResponse.self, from: data)
               disputes = disputesData.DisputesList
                print(disputes.count)
             disputeTableView.reloadData()
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
        return disputes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisputeCell") as! DisputeTableViewCell
       cell.disputeStatusLabel.text = disputes[indexPath.row].Detail
       cell.disputeDescLabel.text = disputes[indexPath.row].Disputes.Description
        cell.disputeTitleLabel.text = disputes[indexPath.row].Disputes.Title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DisputeDetail") as! DisputeDetailViewController
        //viewController.jobDetail = jobDetail
        vc.disputeDetail = self.disputes[indexPath.row].Detail
        vc.disputeList = self.disputes[indexPath.row].Disputes
        navigationController!.pushViewController(vc, animated: true)
    }

}
