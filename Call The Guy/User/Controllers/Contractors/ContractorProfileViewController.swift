//
//  ContractorProfileViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 12/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Cosmos
class ContractorProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var reviewsList = [arrayList]()
    var userId: Int?
    @IBOutlet weak var certificateImageView: UIImageView!
    @IBOutlet weak var skillSetLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var cosmosRatingView: CosmosView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userId)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
        self.navigationItem.title = "PROFILE"
        APIRequest.GetReviews1(id: userId!, completion: APIRequestCompleted)
        reviewTableView.delegate = self
        APIRequest.getUserId1(id:userId!, completion: APIRequestCompletedForProfile)
    }
    
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let list = try decoder.decode(ReviewsModelResponse.self, from: data)
                reviewsList = list.RemarksList
                print(reviewsList.count)
                //                list.RemarksList?.count
                //                print(list.RemarksList!)
                //                print(reviewsList?.RemarksList?.count)
                //                print(reviewsList?.RemarksList![0].Remarks!)
                //                print(reviewsList?.RemarksList![0].Name)
                //                print(list)
                
                
                reviewTableView.reloadData()
                
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
    
    public func APIRequestCompletedForProfile(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let userData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(userData)
                print(userData,"PRinting the data here.")
                
                let user = try decoder.decode(UserProfileModelResponse.self, from: userData)
                print(user)
                let score = user.Score
                let image = user.ImagePath!
                let reviews = user.Reviews
                let name = user.UserName
                let skill = user.Categories ?? ""
                let certificateImage = user.CertificatePath ?? ""
                setProfile(imagePath: image, name: name, score: score ?? 0, reviews: reviews ?? 0,skills: skill, certificateImage: certificateImage)
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
        print(reviewsList.count)
        return reviewsList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        cell.usernameLabel.text = reviewsList[indexPath.row].Name
        cell.reviewDescriptionTextField.text = reviewsList[indexPath.row].Remarks.Remarks
        return cell
    }
    
    func setProfile(imagePath: String, name: String, score: Int , reviews: Int,skills: String , certificateImage: String){
        cosmosRatingView.rating = Double(score)
        cosmosRatingView.settings.updateOnTouch = false
        userNameLabel.text = name
        if Constants.userTypeId == 4{
            self.skillSetLabel.text = skills
            setImage1(image: certificateImage)
        }
        reviewsCountLabel.text = String("(\(reviews))")
        print(imagePath)
        setImage(image:imagePath)
        
        userNameLabel.text = name
        //self.navigationController!.navigationItem.title = "PROFILE"
        
    }
    func setImage(image: String){
        var imagePaths = image
        if (imagePaths != ""){
            imagePaths = String(imagePaths.dropFirst(3))
            imagePaths = "https://www.calltheguy.co.za/"+imagePaths
            let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print(urlString!)
            if  let url = URL(string: urlString!)  {
                print(url)
                self.profileImageView.kf.setImage(with: url)
            }
            else{
                print(imagePaths)
                let url1 = URL(string: "https://www.google.com/search?q=profile+image&rlz=1C5CHFA_enPK862PK863&sxsrf=ACYBGNSHm9w6BhMVqtn80MC2H0v-ry6Vfw:1578300977555&tbm=isch&source=iu&ictx=1&fir=ZbfgeaptF8Y5ZM%253A%252CSmb2EEjVhvpzWM%252C_&vet=1&usg=AI4_-kTnhFOIng6m_SYRWlZtGgmYATIxvg&sa=X&ved=2ahUKEwixm_aoze7mAhULfMAKHVBLBFcQ9QEwAHoECAoQKw#imgrc=ZbfgeaptF8Y5ZM:")
                self.profileImageView.downloadImage(from: url1!)
                
            }
        }
        else{
            self.profileImageView.image = UIImage.init(named: "imagePreview")
        }
    }
    func setImage1(image: String){
        var imagePaths = image
        if (imagePaths != ""){
            imagePaths = String(imagePaths.dropFirst(3))
            imagePaths = "https://www.calltheguy.co.za/"+imagePaths
            let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print(urlString!)
            if  let url = URL(string: urlString!)  {
                print(url)
                self.certificateImageView.kf.setImage(with: url)
            }
            else{
                print(imagePaths)
                let url1 = URL(string: "https://www.google.com/search?q=profile+image&rlz=1C5CHFA_enPK862PK863&sxsrf=ACYBGNSHm9w6BhMVqtn80MC2H0v-ry6Vfw:1578300977555&tbm=isch&source=iu&ictx=1&fir=ZbfgeaptF8Y5ZM%253A%252CSmb2EEjVhvpzWM%252C_&vet=1&usg=AI4_-kTnhFOIng6m_SYRWlZtGgmYATIxvg&sa=X&ved=2ahUKEwixm_aoze7mAhULfMAKHVBLBFcQ9QEwAHoECAoQKw#imgrc=ZbfgeaptF8Y5ZM:")
                self.profileImageView.downloadImage(from: url1!)
                
            }
        }
        else{
            self.profileImageView.image = UIImage.init(named: "imagePreview")
        }
    }

}
