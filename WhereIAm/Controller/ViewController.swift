//
//  ViewController.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/01/31.
//

import SnapKit
import MapKit
import UIKit

class ViewController: UIViewController {

    let stations:[Station] = SubwayInformation.shared.stations
    var mkMapView = MKMapView(frame: CGRect.zero)
//    var namverMapView = NMFMapView(frame: CGRect.zero)
    var locationManager = CLLocationManager()
//    var currentLocationLatLng: NMGLatLng?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        view.addSubview(mkMapView)
        
        initLocationManager()
        setupMkMapKitView()
        
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
        self.mkMapView.delegate = self
        if let location = locationManager.location {
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: ZOOM_LEVEL, longitudinalMeters: ZOOM_LEVEL)
            mkMapView.setRegion(viewRegion, animated: true)
        }
        mkMapView.showsUserLocation = true
        
        detectLocation()
    }
    
    private func detectLocation() {
        guard let currentLocationCenter = locationManager.location?.coordinate else { return }
        let circleOverlay = MKCircle(center: currentLocationCenter, radius: RANGE_NEARBY_MYLOCATION)
        mkMapView.addOverlay(circleOverlay)
        
        let myRange = CLCircularRegion(center: currentLocationCenter, radius: RANGE_NEARBY_MYLOCATION, identifier: "myRange")
        
        stations.forEach { station in
            if myRange.contains(station.point) {
                print("\(station.name)이 범위안에 있어요")
            }
        }
    }

    
    
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.3)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
}

extension ViewController: CLLocationManagerDelegate {
}
