//
//  ViewController.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/01/31.
//

import NMapsMap
import MapKit
import UIKit

class ViewController: UIViewController {
    var mkMapView = MKMapView(frame: CGRect.zero)
    var namverMapView = NMFMapView(frame: CGRect.zero)
    var locationManager = CLLocationManager()
    var currentLocationLatLng: NMGLatLng?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapView = MKMapView(frame: CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2))
        namverMapView = NMFMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        view.addSubview(mkMapView)
        view.addSubview(namverMapView)
        
        initLocationManager()
        setupMkMapKitView()
        setupNaverMapView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3
        locationManager.requestAlwaysAuthorization()
    }
    
    func setupMkMapKitView() {
        if let location = locationManager.location {
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mkMapView.setRegion(viewRegion, animated: true)
        }
        mkMapView.showsUserLocation = true
    }
    
    func detectLocation() {
        
    }
    
    func setupNaverMapView() {
        namverMapView.addCameraDelegate(delegate: self)
        locationManager.startUpdatingLocation()
        namverMapView.positionMode = .direction
        if let location = locationManager.location {
            let nmfLatLng = NMGLatLng(from: location.coordinate)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: nmfLatLng)
            cameraUpdate.animation = .linear
            namverMapView.moveCamera(cameraUpdate)
            
            let circle = NMFCircleOverlay()
            circle.center = nmfLatLng
            circle.radius = 300
            circle.mapView = namverMapView
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
}

extension ViewController: NMFMapViewCameraDelegate {
}

