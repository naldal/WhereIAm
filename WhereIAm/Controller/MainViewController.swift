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
    
    let bottomSheet: BottomSheet = BottomSheet(frame: CGRect.zero)
    
    
    var isStaionNear: Bool?
    var circleOverlay: MKCircle?
    var locationManager = CLLocationManager()
    
    var timer: Timer? {
        willSet {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    var stationsNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        view.addSubview(mkMapView)
        
        if stations.isEmpty {
            isStaionNear = false
        }
        
        initLocationManager()
        setupMkMapKitView()
        drawOverlayOnMap()
        layoutBottomSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        drawOverlayOnMap()
        repeatDrawOverlayOnMap()
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
            let viewRegion = MKCoordinateRegion(center: location.coordinate,
                                                latitudinalMeters: ZOOM_LEVEL,
                                                longitudinalMeters: ZOOM_LEVEL)
            mkMapView.setRegion(viewRegion, animated: true)
        }
        mkMapView.showsUserLocation = true
    }
    
    private func drawOverlayOnMap() {
        if self.circleOverlay != nil { return }
    
        guard let currentLocationCenter = locationManager.location?.coordinate else { return }
    
        self.circleOverlay = MKCircle(center: currentLocationCenter,
                                      radius: RANGE_NEARBY_MYLOCATION
        )
        
        addOverlay()
        
        detectWhichStaionIsNearBy(currentLocationCenter: currentLocationCenter)
    }
    
    func repeatDrawOverlayOnMap() {
        if self.timer != nil { return }
        timer = Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(timerDrawOverlayOnMap),
                                     userInfo: nil,
                                     repeats: true
        )
    }
    
    @objc
    private func timerDrawOverlayOnMap() {
        guard let currentLocationCenter = locationManager.location?.coordinate else {
            return
        }
        
        let circleOverlayLocal = MKCircle(center: currentLocationCenter,
                                          radius: RANGE_NEARBY_MYLOCATION)
        if circleOverlay != nil {
            self.mkMapView.removeOverlay(self.circleOverlay!)
        }
        
        self.circleOverlay = circleOverlayLocal
        DispatchQueue.main.async {
            self.mkMapView.addOverlay(self.circleOverlay!)
        }
        
        detectWhichStaionIsNearBy(currentLocationCenter: currentLocationCenter)
    }
    
    private func addOverlay() {
        DispatchQueue.main.async {
            self.mkMapView.addOverlay(self.circleOverlay!)
        }
    }

    private func detectWhichStaionIsNearBy(currentLocationCenter: CLLocationCoordinate2D) {
        let myRange = CLCircularRegion(center: currentLocationCenter,
                                       radius: RANGE_NEARBY_MYLOCATION,
                                       identifier: MYLOCATION_IDENTIFIER)
        self.stationsNames = stations.filter{ myRange.contains($0.point)}.map{$0.name}
        setStationNameOnBottomSheet() // update stations are near by
    }
    
    private func layoutBottomSheet() {
        view.addSubview(bottomSheet)
        
        setStationNameOnBottomSheet()
    
        bottomSheet.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview().inset(UIViewUtils.shared.safeAreaBottomHeight())
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setStationNameOnBottomSheet() {
        bottomSheet.setup(stationsName: self.stationsNames)
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
