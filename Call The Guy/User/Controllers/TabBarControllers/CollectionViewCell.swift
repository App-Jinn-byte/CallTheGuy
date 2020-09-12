//
//  CollectionViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 21/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//


import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
   var categoryList: CategoriesListModelResponse?
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    public func setData(){
        
        self.categoryImageView.layer.cornerRadius = self.categoryImageView.frame.size.width / 2;
        self.categoryImageView.layer.cornerRadius = self.categoryImageView.frame.size.height / 2;
        self.categoryImageView.clipsToBounds = true;
        
        //var imagePaths = categoryList[indexPath.row].Image
        var imagePaths = categoryList!.Image
       
        imagePaths = String(imagePaths.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(urlString)
        if  let url = URL(string: urlString!)  {
            print(url)
            self.categoryImageView.kf.setImage(with: url)
        }
        else{
            print(imagePaths)
            let url1 = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
            self.categoryImageView.downloadImage(from: url1!)
        }
        self.categoryNameLabel.text = categoryList?.Name
    }
}
