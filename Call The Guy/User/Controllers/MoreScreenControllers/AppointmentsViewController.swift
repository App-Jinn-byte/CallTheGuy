//
//  AppointmentsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 04/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var apointmentsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var appointments = [appointmentsList]()
    private var emptyView: EmptyView?
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView = UINib(nibName: "NoDataView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! EmptyView
        apointmentsTableView.frame = self.view.bounds
        
        apointmentsTableView.delegate = self
        self.title = "Appointments"
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.GetAllAppointments(completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
     self.apointmentsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
         self.apointmentsTableView.reloadData()
    }
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let appoint = try decoder.decode(AppointmentsListModelResponse.self, from: data)
                print(appoint.AppointmentsList)
               appointments = appoint.AppointmentsList
                if (appointments.count == 0){
                    apointmentsTableView.backgroundView = emptyView
                    apointmentsTableView.separatorColor = .clear
                    activityIndicator.stopAnimating()
                }
                else{
                    apointmentsTableView.reloadData()
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
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell") as! AppointmentsTableViewCell
        cell.appointmenObject = appointments[indexPath.row]
        //cell.delegate = self
        cell.setCell()
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppointmentDetail") as? AppointmentDetailViewController
        vc?.appointmentDetail = self.appointments[indexPath.row]
        navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addAppointment(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Appointment") as! CreateAppointmentViewController
     navigationController!.pushViewController(vc, animated: true)
    }
}
