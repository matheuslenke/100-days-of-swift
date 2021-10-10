//
//  ViewController.swift
//  Project22-iBeacon
//
//  Created by Matheus Lenke on 04/10/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var distanceCircle: UIView!
    var locationManager: CLLocationManager?
    
    var beaconFirstFound = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        beaconName.text = "No beacon found"
        
        distanceCircle.tintColor = .yellow
        distanceCircle.layer.cornerRadius = 128
        distanceCircle.clipsToBounds = true
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        
//        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
//        let beaconRegion2 = CLBeaconRegion(uuid: uuid2, major: 123, minor: 456, identifier: "MyBeacon2")
//
//        locationManager?.startMonitoring(for: beaconRegion2)
//        locationManager?.startRangingBeacons(satisfying: beaconRegion2.beaconIdentityConstraint)
//
//        let uuid3 = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!
//        let beaconRegion3 = CLBeaconRegion(uuid: uuid3, major: 123, minor: 456, identifier: "MyBeacon3")
//
//        locationManager?.startMonitoring(for: beaconRegion3)
//        locationManager?.startRangingBeacons(satisfying: beaconRegion3.beaconIdentityConstraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT THERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if beaconFirstFound {
            beaconFirstFound = false
            let ac = UIAlertController(title: "Beacon found!", message: "Now try to get close to it", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
        }
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            beaconName.text = beacon.description
        } else {
            update(distance: .unknown)
        }
    }
    
}

