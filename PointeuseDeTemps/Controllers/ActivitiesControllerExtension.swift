//
//  ActivitiesControllerExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 27/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension ActivitiesController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var picture: UIImage?
        if let changed = info[UIImagePickerControllerEditedImage] as? UIImage {
            picture = changed
        }
        if let selected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picture = selected
        }
        
        activities[currentTapIndex].image = picture
        imagePicker?.dismiss(animated: true, completion: nil)
        
        let act: Activities! = activities[currentTapIndex]
        if ActivitiesDataHelpers.getFunc.setActivity(activity: act) {
            tableView.reloadData()
        }
    }
    
    @objc func imageClick(sender: UITapGestureRecognizer) {
        guard imagePicker != nil else {return}
        
        print("Avant")
        currentTapIndex = imgTappedRow(sender: sender)
        print("Tap : \(currentTapIndex)")
        
        guard currentTapIndex >= 0 else {return}
        
        let alert = UIAlertController(title: RSC_SELECTPICTURE, message: RSC_SELECTMEDIA, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: RSC_PHOTOLIBRARY, style: .default) { (action) in
            self.imagePicker!.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: RSC_CANCEL, style: .cancel, handler: nil)
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
    
    func imgTappedRow(sender: UITapGestureRecognizer) -> Int{
        guard let tappedView = sender.view else {
            return -1
        }
        let touchPointInTableView = self.tableView.convert(tappedView.center, from: tappedView)
        guard let indexPath = self.tableView.indexPathForRow(at: touchPointInTableView) else {
            return -1
        }
        return indexPath.row
    }
}
