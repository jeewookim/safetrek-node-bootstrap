//
//  ThirdViewController.swift
//  Safetrek
//
//  Created by Daniel Ju on 3/24/18.
//  Copyright © 2018 Daniel Ju. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ThirdViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                /* Yes, only when our app is in use  */
                createLocationManager(startImmediately: true)
            case .denied:
                /* No */
                displayAlertWithTitle(title: "Not Determined",
                                      message: "Location services are not allowed for this app")
            case .notDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                /* Restrictions have been applied, we have no access
                 to location services */
                displayAlertWithTitle(title: "Restricted",
                                      message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            print("Location services are not enabled")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLocationManager(startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    @IBAction func connect(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://account-sandbox.safetrek.io/authorize?client_id=m5qXF5ztOdT4cdQtUbZT2grBhF187vw6&scope=openid%20phone%20offline_access&response_type=code&redirect_uri=https://coooolapp.herokuapp.com/callback")!)
    }
    
    @IBAction func triggerAlarm(_ sender: Any) {
        print("Bearer \(UserDefaults.init().string(forKey: "ACCESS_TOKEN") ?? "")")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.init().string(forKey: "ACCESS_TOKEN") ?? "")"
        ]
        
        
        let params = ["services": [
            "police": true,
            "fire": false,
            "medical": false
            ],
                      "location.coordinates": [
                        "lat": Double((locationManager?.location?.coordinate.latitude)!),
                        "lng": Double((locationManager?.location?.coordinate.longitude)!),
                        "accuracy": 5
            ]]
        print("lat: " + String((locationManager?.location?.coordinate.latitude)!))
        print("long:" + String((locationManager?.location?.coordinate.longitude)!))
        Alamofire.request(URL(string: "https://api-sandbox.safetrek.io/v1/alarms")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
    func displayAlertWithTitle(title: String, message: String){
        // Helper function for displaying dialog windows - no edits needed.
        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
        
        present(controller, animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
