import UIKit
import MapKit
import CoreLocation

class TheaterViewController: UIViewController {
    
    @IBOutlet weak var theaterMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let theaterList = TheaterList()
    let centerList: [CLLocationCoordinate2D] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showTheaterActionSheet))
        
        setAllAnnotation()
        
        print("====== 테스트 location: \(theaterList.mapAnnotations[0].location) ======")
        print("====== 테스트 count: \(theaterList.mapAnnotations.count) ======")
        let test = theaterList.mapAnnotations.map{ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        print("====== 테스트 y좌표 배열: \(test) ======")
        
        
        //        centerList[0].latitude
        //        centerList[0].longitude
        
        sortData()
        
    }
    
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D, title: String) {
        
        // 보여줄 범위
        //        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
        //        theaterMapView.setRegion(region, animated: true)
        
        // 어노테이션 생성
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        theaterMapView.addAnnotation(annotation)
        
    }
    
    func setAllAnnotation() {
        
        for count in 0...theaterList.mapAnnotations.count-1 {
            
            //            let latitude =
            //            let longitude =
            
            
            let center = CLLocationCoordinate2D(latitude: theaterList.mapAnnotations[count].latitude, longitude: theaterList.mapAnnotations[count].longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = theaterList.mapAnnotations[count].location
            theaterMapView.addAnnotation(annotation)
            //TheaterMapView.addAnnotations(<#T##annotations: [MKAnnotation]##[MKAnnotation]#>)
            
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
            theaterMapView.setRegion(region, animated: true)
            
            
            
        }
        
        
    }
    
    func sortData() {
        
        for count in 0...theaterList.mapAnnotations.count-1 {
            
            let coordinate = CLLocationCoordinate2D(latitude: theaterList.mapAnnotations[count].latitude, longitude:theaterList.mapAnnotations[count].longitude)
            print("====== \(coordinate) ======")
        }
    }
    
    
    //    @objc func showTheaterActionSheet() {
    //        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    //
    //        let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
    //
    //            setRegionAndAnnotation(center: <#T##CLLocationCoordinate2D#>, title: <#T##String#>)
    //
    //        }
    //
    //        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
    //
    //            setRegionAndAnnotation(center: <#T##CLLocationCoordinate2D#>, title: <#T##String#>)
    //        }
    //
    //        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
    //
    //            setRegionAndAnnotation(center: <#T##CLLocationCoordinate2D#>, title: <#T##String#>)
    //        }
    //
    //        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
    //
    //            setAllAnnotation()
    //        }
    //
    //        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    //
    //        alert.addAction(megabox)
    //        alert.addAction(lotte)
    //        alert.addAction(cgv)
    //        alert.addAction(all)
    //        alert.addAction(cancel)
    //
    ////        present(alert, animated: true, completion: nil)
    ////    }
    //
    }
    
    extension TheaterViewController {
        
        // iOS 버전에 따른 분기 처리 및 iOS 위치서비스 활성화 여부 체크
        func checkDeviceLocationServiceAuthorzation() {
            print(#function)
            
            let authorizationStatus: CLAuthorizationStatus
            
            // iOS 버전에 따른 사용할 코드 분기 처리
            if #available(iOS 14.0, *) {
                authorizationStatus = locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            
            // 디바이스 위치서비스 활성화 여부 체크
            if CLLocationManager.locationServicesEnabled() {
                checkUserCurrentLocationAuthorization(authorizationStatus)
            } else {
                print("위치 서비스가 비활성화되어 있습니다.")
            }
        }
        
        // 사용자가 선택한 앱의 위치 접근 허용 상태 체크
        func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
            switch authorizationStatus {
            case .notDetermined:
                print("대기 상태, notDetermined")
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                
            case .restricted, .denied:
                print("")
                
            case .authorizedAlways:
                print("항상 허용 권한, 먼저 WhenInUse 권한 요청 후 처리하기")
                
            case .authorizedWhenInUse:
                print("앱을 사용하는 동안 허용")
                locationManager.startUpdatingLocation()
                
            default:
                print("오류 발생")
            }
        }
    }
    
    extension TheaterViewController: CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print(#function)
            
            if let coordinate = locations.last?.coordinate {
                
            }
            
            locationManager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(#function)
            print("사용자의 위치를 가져오지 못 했습니다.")
        }
        
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            print(#function)
            checkDeviceLocationServiceAuthorzation()
        }
    }
