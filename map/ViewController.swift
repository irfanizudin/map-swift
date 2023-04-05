//
//  ViewController.swift
//  map
//
//  Created by Irfan Izudin on 05/04/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    var map: MKMapView!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!
    
    lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "scope", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var shareLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 35, height: 35)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        map = MKMapView()
        map.addSubview(currentLocationButton)
        map.addSubview(shareLocationButton)
        
        setupConstraints()
        
        locationManager = CLLocationManager()
        userLocation = CLLocation()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        view.addSubview(map)
        map.frame = view.bounds
        
        shareLocationButton.isEnabled = false
        
        currentLocationButton.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        shareLocationButton.addTarget(self, action: #selector(shareLocation), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            currentLocationButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -80),
            currentLocationButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -30),
            
            shareLocationButton.bottomAnchor.constraint(equalTo: currentLocationButton.topAnchor, constant: -20),
            shareLocationButton.trailingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor)
            
        ])
    }
    
    @objc func moveToCurrentLocation() {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
    }
    
    @objc func shareLocation() {
        guard userLocation.coordinate.latitude != 0 && userLocation.coordinate.longitude != 0 else {
                print("User location not available.")
                return
            }

            let url = URL(string: "https://www.google.com/maps?q=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)")

            let shareSheet = UIActivityViewController(activityItems: ["Check out my current location!", url!], applicationActivities: nil)

            present(shareSheet, animated: true, completion: nil)
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
        }
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        
        shareLocationButton.isEnabled = true

        locationManager.stopUpdatingLocation()
    }
}

