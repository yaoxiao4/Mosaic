//
//  GoogleMapsViewController.swift
//  Mosaic
//
//  Created by Yao Xiao on 2015-06-11.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import GoogleMaps
class GoogleMapsViewController: UIViewController {
    var event: Event? = nil
    var longitute: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(event: Event) {
        self.event = event
        self.longitute = event.location?.longitude
        self.latitude = event.location?.latitude
        super.init(nibName: nil, bundle: nil)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.event?.location?.name

        var camera = GMSCameraPosition.cameraWithLatitude(self.latitude!, longitude: self.longitute!, zoom: 15)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = self.event?.location?.name
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
    }
}