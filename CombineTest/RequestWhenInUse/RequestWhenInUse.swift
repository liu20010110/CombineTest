//
//  RequestWhenInUse.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/1/26.
//

import UIKit
import CoreLocation
import MapKit


class RequestWhenInUse: UIViewController, CLLocationManagerDelegate {
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var mapKit = MKMapView()
    
    @IBOutlet weak var whenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        whenBtn.layer.cornerRadius = whenBtn.frame.height/2
    }


    @IBAction func acceptUse(_ sender: Any) {
        self.locationManagerDidChangeAuthorization(locationManager)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status{
        case .notDetermined:
            print("尚未同意使用定位")
            TAlertView.showAlertWith(title: "尚未同意使用定位", message: "在設置>隱私中打開定位服務，來允許地圖確定您當前的位置", delegate: self) {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            TAlertView.showAlertWith(title: "使用者拒絕存取定位", message: "在設置>隱私中打開定位服務，來允許地圖確定您當前的位置", delegate: self) {
                DispatchQueue.main.async {
                    guard let url = URL(string: UIApplication.openSettingsURLString)
                    else{
                        return
                    }
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url) { (success) in
                            print("Success")
                        }
                    }
                }
            }
            print("使用者拒絕定位")
        case .restricted:
            print("應用程式沒有權限取得定位")
            TAlertView.showAlertWith(title: "應用程式沒有權限取得定位", message: "在設置>隱私中打開定位服務，來允許地圖確定您當前的位置", delegate: self) {
                guard let url = URL(string: UIApplication.openSettingsURLString)
                else{
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url) { (success) in
                        print("Success")
                    }
                }
            }
        case .authorizedAlways:
            print("使用者永遠定位")
            let toMainVC = MainVC()
            self.navigationController?.pushViewController(toMainVC, animated: true)
        case .authorizedWhenInUse:
            print("使用者只在App開啟時定位")
            let toAlways = RequestAlways()
            self.navigationController?.pushViewController(toAlways, animated: true)
        default:
            return
            
        }
        
    }
}
