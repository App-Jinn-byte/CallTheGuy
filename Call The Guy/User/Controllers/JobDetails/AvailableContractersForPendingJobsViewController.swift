//
//  AvailableContractersForPendingJobsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 06/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class AvailableContractersForPendingJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    public typealias Parameters = [String: Any]
    var cellBtn: UIButton?
    @IBOutlet weak var availableContractorsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var jobDetail: jobs?
    private var emptyView: EmptyView?
    var contractorsApplied = [GetAppliedJobContractors]()
    override func viewDidLoad() {
        super.viewDidLoad()
        availableContractorsTableView.delegate = self
        emptyView = UINib(nibName: "NoDataView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! EmptyView
        availableContractorsTableView.frame = self.view.bounds
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            let jobId = jobDetail?.JobId
            APIRequest.GetJobAppliedContractors(jobValue: jobId!, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let count = try decoder.decode([GetAppliedJobContractors].self, from: data)
                print(count)
                if (count.count == 0){
                    availableContractorsTableView.backgroundView = emptyView
                    availableContractorsTableView.separatorColor = .clear
                    activityIndicator.stopAnimating()
                }
                else{
                contractorsApplied = count
                availableContractorsTableView.reloadData()
                activityIndicator.stopAnimating()
                //    Constants.Alert1(title: "Success", message: "Job Closed Successfully", controller: self, action: handlerSuccessAlert())
                }
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractorsApplied.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableContracters") as! AvailableContractersFor_PendingJobTableViewCell
        cell.contObject = contractorsApplied[indexPath.row]
        cell.delegate = self
        
        //cellBtn = cell.acceptBtn
        cell.configureCell()
        
        return cell
    }
}

extension AvailableContractersForPendingJobsViewController: onAcceptJobProtocol{
    
    func onAcceptButtonPressed(cell: AvailableContractersFor_PendingJobTableViewCell) {
        
        guard let cellIndex = availableContractorsTableView.indexPath(for: cell) else {return}
        let detail = contractorsApplied[cellIndex.row]
        let jobId = jobDetail?.JobId
        let contId = detail.UserId
        let userId = Constants.userId
        let jobstatusId = jobDetail?.JobStatusId
        cellBtn = cell.acceptBtn
        print(detail)
        
       
        print(cellIndex)
        
        let param:[String:Any] = ["JobId":jobId!,"ContractorId": contId, "userId": userId,"JobStatusId":jobstatusId!]
        
        if Reachability.isConnectedToNetwork(){
            //activityIndicator.startAnimating()
            Constants.Alert1(title: "Confirm", message: "Are you sure to assign Job to \(detail.UserName ?? "anonymous")", controller: self , action: confirm(parameter: param))
            
            }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    func confirm(parameter: Parameters) -> (UIAlertAction) -> () {
        return { action in
            APIRequest.AcceptJob(parameters: parameter, completion: self.APIRequestCompletedFOrAcceptJob)
        }
    }

    
    fileprivate func APIRequestCompletedFOrAcceptJob(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                
                self.cellBtn?.backgroundColor =  UIColor(red: 16/255, green: 102/255, blue: 16/255, alpha: 1)
                
                let accept = try decoder.decode(AcceptJobModelResponse.self, from: data)
                print(accept)
                cellBtn?.setTitle("Applied", for:.disabled)
                cellBtn?.setTitle("Applied", for:.normal)
                availableContractorsTableView.isUserInteractionEnabled = false
                availableContractorsTableView.reloadData()
                
                //activityIndicator.stopAnimating()
                
                //    Constants.Alert1(title: "Success", message: "Job Closed Successfully", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
}


