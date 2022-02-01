//
//  AppDelegate.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/01/31.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let filePath = Bundle.main.path(forResource: "subwayJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let jsonResult = jsonResult as? Dictionary<String, [Double]> {
                    jsonResult.forEach {
                        let station = Station(name: $0.key,
                                              point: CLLocationCoordinate2D(latitude: $0.value[0], longitude: $0.value[1])
                        )
                        SubwayInformation.shared.stations.append(station)
                    }
                }
            } catch {
                print("\(error.localizedDescription)")
            }
        }
            
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

