//
//  ViewController.swift
//  UploadImages
//
//  Created by Ketan on 11/04/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import Cloudinary
import OpalImagePicker


class PhotoListingVC: UIViewController {

    @IBOutlet weak var tblPhotos: UITableView!

    lazy private var imagePicker = OpalImagePickerController()
    lazy var viewModel: PhotoViewModel = {
        return PhotoViewModel()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initVM()
    }

    private func initView() {
        tblPhotos.tableFooterView = UIView()
    }
    
    func initVM() {

        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblPhotos.reloadData()
            }
        }
        viewModel.loadStoredImages()
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func btnAddNewPhotosClicked(_ sender: UIBarButtonItem) {
        
        presentOpalImagePickerController(imagePicker, animated: true, select: { (assets) in
            self.viewModel.addNewPhotos(assets: assets)
            self.imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ListToDetailVC") {
            let detailVC = segue.destination as! PhotoDetailVC
            let inderPath = sender as! IndexPath
            detailVC.photoDetails = viewModel.getCellViewModel(at: inderPath)
        }
    }
}

extension PhotoListingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoCell:PhotoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        photoCell.photoDetails = viewModel.getCellViewModel(at: indexPath)
        return photoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ListToDetailVC", sender: indexPath)
    }
    
}
