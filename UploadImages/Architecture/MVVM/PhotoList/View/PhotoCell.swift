//
//  PhotoCell.swift
//  UploadImages
//
//  Created by Ketan on 11/04/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import MapleBacon

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var photoDetails: PhotoModel! {
        
        didSet {
            
            if let url = photoDetails.url {
                activity.isHidden = false
                lblName.text = photoDetails.name
                
                self.ivPhoto.setImage(with: url, placeholder: nil, transformer: nil, progress: nil, completion: { (image) in
                    self.activity.isHidden = true
                })
                
            }
            else {
                activity.isHidden = false
                lblName.text = photoDetails.progress + "%"
            }
            
            if let request = photoDetails.uploaderRequest {
                
                request.setUploadProgress = { () in
                    DispatchQueue.main.async {
                        self.activity.isHidden = false
                        self.lblName.text = self.photoDetails.progress + "%"
                    }
                }
                
                request.uploadProgressFinished = { () in
                    DispatchQueue.main.async {
                        
                        self.lblName.text = self.photoDetails.name
                        
                        self.ivPhoto.setImage(with: self.photoDetails.url, placeholder: nil, transformer: nil, progress: nil, completion: { (image) in
                            self.activity.isHidden = true
                        })
                    }
                }
            }
        }
    }
}
