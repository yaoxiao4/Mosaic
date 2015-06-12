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
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For the Map
        var camera = GMSCameraPosition.cameraWithLatitude(-33.868,
            longitude:151.2086, zoom:15)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = event?.location?.name
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
    }
}