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
        typicalDayPicker.delegate = self
        typicalDayPicker.dataSource = self
        
        typicalDayNames = [String]()
        typicalDayNames!.append("")
        if let allData = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected) {
            for elm in allData {
                typicalDayNames!.append(elm.typicalDayName!)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if typicalDayNames != nil {
            return typicalDayNames!.count
        } else {
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if typicalDayNames != nil {
            return typicalDayNames![row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typicalDayNames != nil {
            let text = typicalDayNames![row]
            if text == "" {
                typicalDay = nil
            } else {
                if let data = TypicalDaysDataHelpers.getFunc.searchTypicalDayByName(typicalDayName: text, userConnected: userConnected) {
                    typicalDay = data
                }
            }
        } else {
            typicalDay = nil
        }
    }
    
    
}
