//
//  AppointmentDetailViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 05/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class AppointmentDetailViewController: UIViewController {
    @IBOutlet weak var closeAppointmentButton: UIButton!
    @IBOutlet weak var appointmentId: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var appointmentTitle: UILabel!
    @IBOutlet weak var appointmentAddress: UILabel!
    var appointmentDetail: appointmentsList?
    @IBOutlet weak var appointmentDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeAppointmentButton.layer.cornerRadius = closeAppointmentButton.frame.height/2
        closeAppointmentButton.clipsToBounds = true
        if let id = appointmentDetail?.AppointmentId {
            appointmentId.text = String(id)
        }
        else{
            appointmentId.text = ""
        }
        appointmentAddress.text = appointmentDetail?.Address
        appointmentTitle.text = appointmentDetail?.Title
        nameLabel.text = appointmentDetail?.Name
        var date = appointmentDetail?.CreatedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
        let date1 = dateFormatter.date(from: date!)
        //        print(blogDate!)
        //        print(date!)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MMM/yyyy"
        var createdDate = dateFormatterPrint.string(from: date1!)
        appointmentDate.text = createdDate
    
        guard let imagePath = appointmentDetail?.URL else{ return}
        setImage(image: imagePath)
    }
    
    @IBAction func appointmentClose(_ sender: Any) {
        Constants.Alert1(title: "Close Appointment", message: "Are you sure to want to close the appointment", controller: self, action: handlerSuccess())
    }
    func setImage(image: String){
        print (image)
        var imagePaths = String(image.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(urlString!)
        if  let url = URL(string: urlString!)  {
            print(url)
            self.userImageView.kf.setImage(with: url)
        }
    }

    func handlerSuccess() -> (UIAlertAction) -> (){
        
        return { action in
            var empty = ""
            let param:[String:Any] = ["":empty]
            let value = self.appointmentDetail?.AppointmentId
            //let id:Int = self.appointmentDetail!.AppointmentId
            APIRequest.CloseAppointment(value:value!,parameters: param , completion: self.APIRequestCompletedForAppointment)
        }
    }
    
    public func APIRequestCompletedForAppointment(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data.description)
                print(data,"PRinting the data here.")
                
                let list = try decoder.decode(CloaseAppointmentModelResponse.self, from: data)
                let response = list
                print(list)
                self.navigationController?.popViewController(animated: true)
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
}
