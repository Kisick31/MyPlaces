//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Ekaterina Shitikova on 07.04.2020.
//  Copyright © 2020 Kisick'n'Kisa. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChanges = false
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photoSmall")
            
            let actionSheet = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            //camera.setValue(CATextLayerAlignmentMode.left, forKey: "title")
            
            let photo = UIAlertAction(title: "Photo", style: .default ) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            //photo.setValue(CATextLayerAlignmentMode.left, forKey: "title")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
   func savePlace() {
        
        var image: UIImage?
        
        if imageIsChanges {
            image = placeImage.image
        }else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
    
        let newPlace = Place(name: placeName.text!, location: placeLocation.text,
                             type: placeType.text, imageData: imageData)
    
    if currentPlace != nil {
        try! realm.write{
            currentPlace?.name = newPlace.name
            currentPlace?.location = newPlace.location
            currentPlace?.type = newPlace.type
            currentPlace?.imageData = newPlace.imageData
        }}
    else{
            StorageManager.saveObject(newPlace)
    }
    
    }
    
    private func setupEditScreen() {
        if currentPlace != nil{
            setupNavigationBar()
            imageIsChanges = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFit
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            
        }
    }
    
    private func setupNavigationBar(){
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
                                                        target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension NewPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldChanged(){
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: - Work with image
extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            imagePicker.delegate = self
            
            present(imagePicker,animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        
        imageIsChanges = true
        
        dismiss(animated: true)
    }
}
