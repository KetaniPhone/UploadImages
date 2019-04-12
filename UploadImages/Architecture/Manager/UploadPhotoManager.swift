//
//  UploadPhotoManager.swift
//  UploadImages
//
//  Created by Ketan on 11/04/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import Cloudinary

class UploadPhotoManager: NSObject {
    
    var setUploadProgress: (()->())?
    var uploadProgressFinished: (()->())?
    
    lazy var cLDCloudinary: CLDCloudinary = {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        return cloudinary
    }()
    
    
    func uploadNewImage(photoDetail: PhotoModel) {
    
        let imagename = "\(getNextIndex())UploadImages"
        photoDetail.name = "\(imagename).jpg"
        let params = CLDUploadRequestParams().setUploadPreset(preset).setPublicId(imagename).setTags(imageTag)
        
        _ = cLDCloudinary.createUploader().upload(url: photoDetail.url, uploadPreset: preset, params: params, progress: { (progress) in
            
            photoDetail.progress = String(format: "%.2f", progress.fractionCompleted * 100)
            self.setUploadProgress?()
            
        }) { (result, error) in
            
            photoDetail.url = URL(string: result!.secureUrl!)
            photoDetail.uploaderRequest = nil
            self.uploadProgressFinished?()
        }
    }
    
    private func getNextIndex() -> Int {
        let index:Int = UserDefaults.standard.integer(forKey: imageKey)
        UserDefaults.standard.set(index + 1, forKey: imageKey)
        return index + 1
    }
    
    private func getTotalImageCount() -> Int {
        let index:Int = UserDefaults.standard.integer(forKey: imageKey)
        return index
    }
    
}
