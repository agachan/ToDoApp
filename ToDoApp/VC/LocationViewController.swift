//
//  LocationViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/25.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            // 許可されてない場合
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            // 拒否されてる場合
            case .restricted, .denied:
                // 何もしない
                break
            // 許可されている場合
            case .authorizedAlways, .authorizedWhenInUse:
                // 現在地の取得を開始
                manager.startUpdatingLocation()
                break
            default:
                break
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.first
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude

            print("latitude: \(latitude!)\nlongitude: \(longitude!)")
        }
    
}
