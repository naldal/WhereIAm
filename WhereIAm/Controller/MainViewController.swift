//
//  ViewController.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/01/31.
//

import SnapKit
import MapKit
import UIKit

class MainViewController: UIViewController {

    let stations:[Station] = SubwayInformation.shared.stations
    var mkMapView = MKMapView(frame: CGRect.zero)
    var isStaionNear: Bool?
    var locationManager = CLLocationManager()
    var circleOverlay: MKCircle?
    let bottomSheet: BottomSheet = BottomSheet(frame: CGRect.zero)
    var timer: Timer? {
        willSet {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        view.addSubview(mkMapView)
        
        if stations.isEmpty {
            isStaionNear = false
        }
        
        initLocationManager()
        setupMkMapKitView()
        detectLocation()
        layoutBottomSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view Will Appear")
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        detectLocation()
        fetchDetectLocation()
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
    }
    
    private func detectLocation() {
        guard let currentLocationCenter = locationManager.location?.coordinate else { return }
    
        let circleOverlayLocal = MKCircle(center: currentLocationCenter, radius: RANGE_NEARBY_MYLOCATION)
        DispatchQueue.main.async {
            self.mkMapView.addOverlay(circleOverlayLocal)
        }
        self.circleOverlay = circleOverlayLocal
    
        
        drawOverlayOnMap(currentLocationCenter: currentLocationCenter)
        
    }
    
    func fetchDetectLocation() {
        if self.timer != nil { return }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerDetctLocation), userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerDetctLocation() {
        
        guard let currentLocationCenter = locationManager.location?.coordinate else { return }
        DispatchQueue.main.async {
            self.mkMapView.removeOverlay(self.circleOverlay!)
            self.circleOverlay = nil
        }
        let circleOverlayLocal = MKCircle(center: currentLocationCenter, radius: RANGE_NEARBY_MYLOCATION)
        DispatchQueue.main.async {
            self.mkMapView.addOverlay(circleOverlayLocal)
            self.circleOverlay = circleOverlayLocal
        }
    }
    
    private func drawOverlayOnMap(currentLocationCenter: CLLocationCoordinate2D) {
        let myRange = CLCircularRegion(center: currentLocationCenter, radius: RANGE_NEARBY_MYLOCATION, identifier: MYLOCATION_IDENTIFIER)
        
        stations.forEach { station in
            if myRange.contains(station.point) {
                print("\(station.name)이 범위안에 있어요")
            }
        }
    }
    
    private func layoutBottomSheet() {
        view.addSubview(bottomSheet)
        bottomSheet.setup()
        
        bottomSheet.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.bottom.equalToSuperview().inset(UIViewUtils.shared.safeAreaBottomHeight())
            $0.left.right.equalToSuperview().inset(20)
    
        }
    }

}
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .green
        circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.1)
        circleRenderer.lineWidth = 0.5
        return circleRenderer
    }
}

extension MainViewController: CLLocationManagerDelegate {
}
