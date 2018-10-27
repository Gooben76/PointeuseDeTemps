//
//  TimeScoresControllerExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 22/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension TimeScoresController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func initPickerView(){
        popPickerView.delegate = self
        popPickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerViewNames.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRowPickerView = pickerViewNames[row]
    }
    
}
