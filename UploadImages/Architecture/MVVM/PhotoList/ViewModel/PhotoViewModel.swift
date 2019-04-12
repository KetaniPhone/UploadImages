//
//  PhotoViewModel.swift
//  UploadImages
//
//  Created by Ketan on 11/04/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import Photos

class PhotoViewModel: NSObject {

    var reloadTableViewClosure: (()->())?
    
    private var arrPhotos: [PhotoModel] = [PhotoModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    
    //MARK:- Custom Methods
    
    func loadStoredImages() {
        
        let totalImage = UserDefaults.standard.integer(forKey: imageKey)
        
        if(totalImage > 0) {
            for i in (1...totalImage).reversed() {
                
                let objPhoto = PhotoModel()
                
                let imageName = "\(i)\(fileExtention)"
                
                objPhoto.name = imageName
                objPhoto.progress = fullProgress
                objPhoto.url = URL(string: "\(serverImagePath)\(imageName)")
                objPhoto.uploaderRequest = nil
                self.arrPhotos.append(objPhoto)
            }
        }
    }
    
    func addNewPhotos(assets: [PHAsset]) {
        
        for imageDetail in assets.enumerated() {
            imageDetail.element.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                if let input = eidtingInput, let imgURL = input.fullSizeImageURL {
                    let objPhoto = PhotoModel()
                    objPhoto.progress = emptyProgress
                    objPhoto.url = imgURL
                    objPhoto.uploaderRequest = UploadPhotoManager()
                    objPhoto.uploaderRequest!.uploadNewImage(photoDetail: objPhoto)
                    self.arrPhotos.insert(objPhoto, at: 0)
                }
            }
        }
    }
    
    var numberOfCells: Int {
        return arrPhotos.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoModel {
        return arrPhotos[indexPath.row]
    }
    
}
