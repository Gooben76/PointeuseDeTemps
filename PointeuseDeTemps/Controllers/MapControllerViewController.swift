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

    @IBOutlet weak var latitudeLabel: LabelH3TitleTS!
    @IBOutlet weak var latitudeValueLabel: LabelH3TS!
    @IBOutlet weak var longitudeLabel: LabelH3TitleTS!
    @IBOutlet weak var longitudeValueLabel: LabelH3TS!
    @IBOutlet weak var mapView: MKMapView!
    
    var detail: TimeScoreActivityDetails?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if let nav = navigationController {
            let navigationBar = nav.navigationBar
            navigationBar.tintColor = UIColor.black
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if detail != nil {
            let annotationStart = MKPointAnnotation()
            annotationStart.coordinate = CLLocationCoordinate2DMake(detail!.startLatitude, detail!.startLongitude)
            annotationStart.title = RSC_START
            
            let annotationEnd = MKPointAnnotation()
            annotationEnd.coordinate = CLLocationCoordinate2DMake(detail!.endLatitude, detail!.endLongitude)
            annotationEnd.title = RSC_END
            
            mapView.addAnnotation(annotationStart)
            mapView.addAnnotation(annotationEnd)
        }
        
    }

}
