//
//  BlogDetailViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 14/11/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class BlogDetailViewController: UIViewController {

    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationItem.title = "BLOG DETAIL"
        blogTitleLabel.text = blogsList1[indexPath1].Title
        createdByLabel.text = blogsList1[indexPath1].CreatedByName
        creationDateLabel.text = blogDate1
        descTextView.text = blogsList1[indexPath1].Description?.html2AttributedString
        
        
        blogImage = blogsList1[indexPath1].ImagePath!
        print(blogImage)
        blogImage = String(blogImage.dropFirst(3))
        print(blogImage)
        blogImage = "https://www.calltheguy.co.za/"+blogImage
        print(blogImage)
        let urlString1 = blogImage.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(blogImage)
        if  let url = URL(string: urlString1!)  {
            print(url)
            blogImageView.downloadImage(from: url)
        }
        else{
            //print(imagePaths)
            let url1 = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
            blogImageView.downloadImage(from: url1!)
        }
    }
}
