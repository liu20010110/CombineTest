//
//  MainVC.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2022/12/20.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseFirestore
import RealmSwift


class MainVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var settIng: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    let realm = try! Realm()
    fileprivate var minSpeed: Int = 0
    fileprivate var maxSpeed: Int = 500
    fileprivate var latitude: Double = 0
    fileprivate var longitude: Double = 0
    fileprivate let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        map.delegate = self
        map.showsUserLocation = true
        //視窗在自身定位
        map.userTrackingMode = .follow
        //定位準確度
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        map.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.aquarium])
        self.fetchDataToLocal()
        print(realm.configuration.fileURL!)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if locationManager.authorizationStatus == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func toSetting(_ sender: Any) {
        let toPersonal = PersonalInformation()
        self.navigationController?.pushViewController(toPersonal, animated: true)
        
    }
    
    @IBAction func userTrackMode(_ sender: Any) {
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude )
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    @IBAction func toFriendsList(_ sender: Any) {
        let toFriendsList = FriendsList()
        self.navigationController?.pushViewController(toFriendsList, animated: true)
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message:nil , preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = "Do you want add new Pin?"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{  _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty{
                self.fetchUsersLocal(name: text)
                self.fetchDataToLocal()
            } else {
                TAlertView.showAlertWith(title: "請重新確認ID", message: "確認ID", delegate: self) {
                    return
                }
            }
        }))
        present(alert, animated: true)
    }
    
//    func annotationTapped() {
//        let aLongPressAnnoa = MKMarkerAnnotationView()
//        let aLongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapped))
//        aLongPress.minimumPressDuration = 1
//        aLongPress.numberOfTouchesRequired = 1
//        aLongPress.delaysTouchesBegan = true
//        aLongPress.delegate = self
//        aLongPressAnnoa.addGestureRecognizer(aLongPress)
//
//    }
//
//    @objc func longPressTapped(gestureRecognizer: UILongPressGestureRecognizer) {
//        let annotaionView = MKMarkerAnnotationView()
//        print(annotaionView.glyphText!)
//        if gestureRecognizer.state != .ended {
//            return
//        } else if gestureRecognizer.state == .began {
//            TAlertView.showAlertWith(title: "是否刪除好友定位", message: "確認後刪除", delegate: self) { [self] in
//                let delete = realm.objects(UserInfo.self).filter("localUserName = '\(annotaionView.glyphText!)'").first
//                try! realm.write {
//                    realm.delete(delete!)
//                }
//            }
//        }
//    }
}

extension MainVC: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let intSpeed = Int(userLocation.speed * 3.6)
        
        
        if ((intSpeed <= minSpeed)){
            //            self.speed.text = String(0) + "  km/h"
            self.speed.isHidden = true
        }else if intSpeed > minSpeed{
            self.speed.isHidden = false
            self.speed.text = String(intSpeed) + "  km/h"
        }
        
        
        
        let last = locations.last
        let db = Firestore.firestore()
        db.collection("locations").document("\(GlobalAppSetting.shared.userName)").setData(["local" : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]) { (err) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }
            print("Success")
        }
        
        //        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("目前位置 緯度：\(locations[0].coordinate.latitude) 經度：\(locations[0].coordinate.longitude)")
        //        getAddressFromLatLonWithLocale(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.fetchDataToLocal()
        }
        
        
        if GlobalAppSetting.shared.isSignOut == true {
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
        }
        
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
        case .authorizedWhenInUse:
            print("使用者只在App開啟時定位")
        default:
            return
            
        }
        
    }
    
    func getAddressFromLatLonWithLocale(pdblLatitude: String, withLongitude pdblLongitude: String){
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
        
        _ = Locale(identifier: "zh_TW")
        UserDefaults.standard.set(["zh_TW"], forKey: "AppleLanguages")
        
        //位置的反向地理編碼請求
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placeMarks,error) in
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            
            if error == nil {
                let pm = placeMarks! as [CLPlacemark]
                if pm.count > 0{
                    let pm = placeMarks![0]
                    var newAddress = ""
                    print(placeMarks!)
                    print(pm.name ?? "")
                    print(pm.country ?? "")
                    print(pm.subAdministrativeArea ?? "")
                    print(pm.locality ?? "")
                    print(pm.postalCode ?? "")
                    print(pm.thoroughfare ?? "")
                    print(pm.subThoroughfare ?? "")
                    
                    //                    if pm.name != nil{
                    //                        newAddress += pm.name! + "\n"
                    //                    }
                    
                    if pm.locality != nil{
                        newAddress += pm.locality! + "\n"
                    }
                    
                    if pm.thoroughfare != nil{
                        newAddress += pm.thoroughfare!
                    }
                    
                    if pm.subLocality != nil{
                        newAddress += pm.subLocality!
                    }
                    
                    if pm.subThoroughfare != nil{
                        newAddress += pm.subThoroughfare! + "號"
                    }
                    
                    self.address.text = String(newAddress)
                    
                }
            }
            
        })
    }
    
    func fetchUsersLocal(name: String) {
        // 讀取某個文檔中的座標
        let docRef = db.collection("locations").document("\(name)")
        docRef.getDocument() { [self] (document, error) in
            if let document = document, let data = document.data(), let geoPoint = data["local"] as? GeoPoint {
                latitude = geoPoint.latitude
                longitude = geoPoint.longitude
                print(latitude, longitude)
                GlobalAppSetting.shared.name = name
                
                try! realm.write({
                    let userInfo = UserInfo()
                    userInfo.localCollection = "locations"
                    userInfo.localUserName = "\(name)"
                    userInfo.localField = "local"
                    userInfo.localLatitude = latitude
                    userInfo.localLongitude = longitude
                    realm.add(userInfo)
                })
                
                //                let annoTation = MKPointAnnotation()
                //                annoTation.title = "\(GlobalAppSetting.shared.name)"
                //                annoTation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                //                annoTation.subtitle = "Friend"
                //                self.map.addAnnotation(annoTation)
                //                map.removeAnnotation(annoTation)
                
                self.fetchDataToLocal()
                
            } else {
                TAlertView.showAlertWith(title: "請確認資訊", message: "確認ID是否已註冊", delegate: self) {
                    return
                }
            }
        }
    }
    func fetchDataToLocal(){
        let results = realm.objects(UserInfo.self)
        if results.count == 1 {
//                        map.removeAnnotations(map.annotations)
            let docRef = db.collection("\(results[0].localCollection)").document("\(results[0].localUserName)")
            docRef.getDocument() { [self] (snapShot, err) in
                if let snapShots2 = snapShot, let localData = snapShots2.data(), let geoPoin2 = localData["\(results[0].localField)"] as? GeoPoint {
                    try! realm.write({
                        results[0].localCollection = results[0].localCollection
                        results[0].localUserName = results[0].localUserName
                        results[0].localField = results[0].localField
                        results[0].localLatitude = geoPoin2.latitude
                        results[0].localLongitude = geoPoin2.longitude
                        
                    })
                    let annotationView = MKMarkerAnnotationView()
                    if annotationView.glyphText == results[0].localUserName {
                        return
                    } else {
                        let newAnnotation = MKPointAnnotation()
                        newAnnotation.title = results[0].localUserName
                        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: results[0].localLatitude, longitude: results[0].localLongitude)
                        newAnnotation.subtitle = "Friend"
                        self.map.addAnnotation(newAnnotation)
                        
                    }
                }
                if let documents = snapShot, documents.exists {
                    return
                } else {
                    let delete = realm.objects(UserInfo.self).filter("localUserName = '\(results[0].localUserName)'").first
                    try! realm.write {
                        realm.delete(delete!)
                    }
                }
            }
        } else if results.count > 1 {
            map.removeAnnotations(map.annotations)
            let newResults: [UserInfo] = results.map { $0 }
            for i in 0 ..< newResults.count {
                let docRef = db.collection("\(newResults[i].localCollection)").document("\(newResults[i].localUserName)")
                docRef.getDocument { [self] (snapShot3, err) in
                    if let snapShot4 = snapShot3, let localData = snapShot4.data(), let geoPoint3 = localData["\(newResults[i].localField)"] as? GeoPoint {
                        try! realm.write({
                            newResults[i].localCollection = newResults[i].localCollection
                            newResults[i].localUserName = newResults[i].localUserName
                            newResults[i].localField = newResults[i].localField
                            newResults[i].localLatitude = geoPoint3.latitude
                            newResults[i].localLongitude = geoPoint3.longitude
                        })
                        
                        let annotationView = MKPointAnnotation()
                        if annotationView.title == newResults[i].localUserName {
                            annotationView.coordinate = CLLocationCoordinate2D(latitude: newResults[i].localLatitude, longitude: newResults[i].localLongitude)
                        } else {
                            let newAnnotations2 = MKPointAnnotation()
                            newAnnotations2.title = newResults[i].localUserName
                            newAnnotations2.coordinate = CLLocationCoordinate2D(latitude: newResults[i].localLatitude, longitude: newResults[i].localLongitude)
                            newAnnotations2.subtitle = "Friend"
                            self.map.addAnnotation(newAnnotations2)
                        }
                    }
                    if let documents = snapShot3, documents.exists {
                        return
                    } else {
                        let delete = realm.objects(UserInfo.self).filter("localUserName = '\(newResults[i].localUserName)'").first
                        try! realm.write {
                            realm.delete(delete!)
                        }
                    }
                }
            }
        } else {
            return
        }

    }
}

extension MainVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let realm = try! Realm()
        let results = realm.objects(UserInfo.self)
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        }
        
        if results.count == 1, annotation !== map.userLocation {
            annotationView?.glyphText = results[0].localUserName
            annotationView?.markerTintColor = .black
            annotationView?.glyphTintColor = .white
            annotationView?.titleVisibility = .adaptive
            annotationView?.subtitleVisibility = .adaptive
        } else if results.count > 1, annotation !== map.userLocation {
            let newResults: [UserInfo] = results.map { $0 }
            for i in 0 ..< newResults.count {
                if let title = annotation.title, title == newResults[i].localUserName {
                    annotationView?.glyphText = newResults[i].localUserName
                    annotationView?.markerTintColor = .black
                    annotationView?.glyphTintColor = .white
                    annotationView?.titleVisibility = .adaptive
                    annotationView?.subtitleVisibility = .adaptive
                }
            }
        } else if results.count == 0, annotation === map.userLocation {
            annotationView?.markerTintColor = .black
            annotationView?.glyphTintColor = .white
            annotationView?.glyphImage = UIImage(systemName: "mappin.and.ellipse")
            annotationView?.titleVisibility = .adaptive
            annotationView?.subtitleVisibility = .adaptive
        } else if annotation === map.userLocation {
            annotationView?.markerTintColor = .black
            annotationView?.glyphTintColor = .white
            annotationView?.glyphImage = UIImage(systemName: "mappin.and.ellipse")
            annotationView?.titleVisibility = .adaptive
            annotationView?.subtitleVisibility = .adaptive
        } else {
            return nil
        }
        
//        for annotation in self.map.annotations {
//            for i in 0 ..< results.count {
//                if let title = annotation.title, results[i].localUserName != title, annotation is MKAnnotationView  {
//                    self.map.removeAnnotation(annotation)
//                } else {
//                    return nil
//                }
//            }
//        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
        print(view.annotation!.coordinate.latitude,view.annotation!.coordinate.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.getAddressFromLatLonWithLocale(pdblLatitude: "\(view.annotation!.coordinate.latitude)", withLongitude: "\(view.annotation!.coordinate.longitude)")
       
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(map.region)
        getAddressFromLatLonWithLocale(pdblLatitude: "\(map.region.center.latitude)", withLongitude: "\(map.region.center.longitude)")
    }
}
