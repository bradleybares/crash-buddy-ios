//
//  LocationManager.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 11/28/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
