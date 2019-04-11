//
//  PhotoDetailVC.swift
//  UploadImages
//
//  Created by Ketan on 11/04/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoDetailVC: UIViewController {

    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    var photoDetails: PhotoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPhotoDetails()
    }
    
    private func setPhotoDetails() {
        self.title = photoDetails.name
        ivPhoto.kf.setImage(with: photoDetails.url)
    }
    
}
