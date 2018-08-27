//
//  ParametersController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ParametersController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: ImageViewTS!
    @IBOutlet weak var loginTF: TextFieldTS!
    @IBOutlet weak var passwordTF: TextFieldTS!
    @IBOutlet weak var nameTF: TextFieldTS!
    @IBOutlet weak var firstNameTF: TextFieldTS!
    
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pictureClick))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }

    @objc func pictureClick() {
        guard imagePicker != nil else {return}
        let alert = UIAlertController(title: RSC_SELECTPICTURE, message: RSC_SELECTMEDIA, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: RSC_CAMERA, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker!.sourceType = .camera
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }
        let library = UIAlertAction(title: RSC_PHOTOLIBRARY, style: .default) { (action) in
            self.imagePicker!.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: RSC_CANCEL, style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let pop = alert.popoverPresentationController {
                pop.sourceView = self.view
                pop.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
                pop.permittedArrowDirections = []
            }
        }
        self.present(alert, animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker!.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var picture: UIImage?
        if let changed = info[UIImagePickerControllerEditedImage] as? UIImage {
            picture = changed
        }
        if let selected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picture = selected
        }
        imageView.image = picture
        imagePicker!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton_Click(_ sender: Any) {
        view.endEditing(true)
    }
}
