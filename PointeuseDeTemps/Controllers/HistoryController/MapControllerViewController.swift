//
//  MapControllerViewController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 17/10/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import MapKit

class MapControllerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startLabel: LabelH3TitleTS!
    @IBOutlet weak var endLabel: LabelH3TitleTS!
    @IBOutlet weak var startPlaceLabel: LabelH3TS!
    @IBOutlet weak var endPlaceLabel: LabelH3TS!
    
    var detail: TimeScoreActivityDetails?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if let nav = navigationController {
            let navigationBar = nav.navigationBar
            navigationBar.tintColor = UIColor.black
        }
        
        startLabel.text = RSC_START
        endLabel.text = RSC_END
        startPlaceLabel.text = ""
        endPlaceLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if detail != nil {
            if detail!.startLatitude != 0 && detail!.startLongitude != 0 {
                let annotationStart = MKPointAnnotation()
                annotationStart.coordinate = CLLocationCoordinate2DMake(detail!.startLatitude, detail!.startLongitude)
                annotationStart.title = RSC_START
                mapView.addAnnotation(annotationStart)
                
                APIGoogle.getFunc.getPlaceFromLatitudeAndLongitude(latitude: detail!.startLatitude, longitude: detail!.startLongitude) { (response) in
                    if response != nil {
                        self.startPlaceLabel.text = response
                    } else {
                        self.startPlaceLabel.text = RSC_NOT_DEFINED
                    }
                }
            } else {
                self.startPlaceLabel.text = RSC_NOT_DEFINED
            }
            
            if detail!.endLatitude != 0 && detail!.endLongitude != 0 {
                let annotationEnd = MKPointAnnotation()
                annotationEnd.coordinate = CLLocationCoordinate2DMake(detail!.endLatitude, detail!.endLongitude)
                annotationEnd.title = RSC_END
                mapView.addAnnotation(annotationEnd)
                
                APIGoogle.getFunc.getPlaceFromLatitudeAndLongitude(latitude: detail!.endLatitude, longitude: detail!.endLongitude) { (response) in
                    if response != nil {
                        self.endPlaceLabel.text = response
                    } else {
                        self.endPlaceLabel.text = RSC_NOT_DEFINED
                    }
                }
            } else {
                self.endPlaceLabel.text = RSC_NOT_DEFINED
            }
        }
    }

}
