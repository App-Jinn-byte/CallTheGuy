//
//  ContractorJobsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 16/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ContractorJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var availableJobs = [AvailableJobsForContractor]()
    
    lazy var  refresher:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadApi), for: .valueChanged)
        return refresh
    }()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jobsTableView: UITableView!
    private var emptyView: EmptyView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
         jobsTableView.refreshControl = refresher
        emptyView = UINib(nibName: "NoDataView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! EmptyView
        jobsTableView.frame = self.view.bounds
        jobsTableView.delegate = self
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.GetAvailableJobs(completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.jobsTableView.reloadData()
    }
    
    @objc func reloadApi(){
        print("helloWorld")
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            if Reachability.isConnectedToNetwork(){
                self.activityIndicator.startAnimating()
                
                APIRequest.GetAvailableJobs(completion: self.APIRequestCompleted)
            }
            else {
                print("Internet connection not available")
                
                Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
            }
            self.refresher.endRefreshing()
        }
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let jobs = try decoder.decode([AvailableJobsForContractor].self, from: data)
                print(jobs)
                availableJobs = jobs
                if (availableJobs.count == 0){
                    jobsTableView.backgroundView = emptyView
                    jobsTableView.separatorColor = .clear
                    activityIndicator.stopAnimating()
                }
                else{
                    jobsTableView.reloadData()
                    activityIndicator.stopAnimating()
                }
               
            }
            catch {
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Catch", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Not Valid Response", controller: self)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsCell") as! ContractorJobsTableViewCell
        cell.jobObject = availableJobs[indexPath.row]
        //cell.delegate = self
        cell.setData()
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc1 = UIStoryboard.init(name: "Contracter", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobDetail") as? AppointmentDetailViewController
        //        vc1?.appointmentDetail = self.appointments[indexPath.row]
        //        navigationController!.pushViewController(vc!, animated: true)
        
        let vc = UIStoryboard.init(name: "Contracter", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobDetail") as! ApplyJobDetailViewController
        //viewController.jobDetail = jobDetail
        vc.jobObject = self.availableJobs[indexPath.row]
        vc.jobId = self.availableJobs[indexPath.row].JobId
        navigationController!.pushViewController(vc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc  = segue.destination as! ApplyJobDetailViewController
    }
}
