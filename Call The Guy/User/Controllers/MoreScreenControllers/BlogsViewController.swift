//
//  BlogsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 11/11/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Alamofire
//    Mark: - Accessing these variables on next view controller that is call perform segue in didselectrow function of cell
  var blogsList1 = [blogsList]()
    var indexPath1 = 0
    var blogDate1 = ""

    var blogImage = ""

class BlogsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
    @IBOutlet weak var blogTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
          APIRequest.GetBlogs(completion: APIRequestCompleted)
        
        self.navigationItem.title = "BLOGS"
        blogTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
               
                print(data,"PRinting the data here.")
                
                let blogs = try decoder.decode(BlogsModelResponse.self, from: data)
                blogsList1 = blogs.BlogList
                //print(blogsList1)
                print(blogsList1[1].ThumbNail)
                print(blogsList1.count)
               
                blogTableView.reloadData()
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
        return blogsList1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogTableViewCell
        
        var blogDate = blogsList1[indexPath.row].CreatedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
        let date = dateFormatter.date(from: blogDate!)
//        print(blogDate!)
//        print(date!)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        blogDate1 = dateFormatterPrint.string(from: date!)
        //print(date1)
        
        cell.blogTitleLabel.text = blogsList1[indexPath.row].Title
        cell.blogDateLabel.text = blogDate1
        cell.blogDescrText.text = blogsList1[indexPath.row].Description?.html2AttributedString
        
        
        var imagePaths = blogsList1[indexPath.row].ThumbNail
         print (imagePaths)
        imagePaths = String(imagePaths.dropFirst(3))
        print(imagePaths)
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(urlString)
        
        if  let url = URL(string: urlString!)  {
            print(url)
            cell.blogImageView.downloadImage(from: url)
        }
        else{
            print(imagePaths)
            let url1 = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
            cell.blogImageView.downloadImage(from: url1!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      indexPath1 = indexPath.row
        print(indexPath)
        performSegue(withIdentifier: "BlogDetail", sender: self)
    }
}

