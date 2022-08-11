/*
 전체흐름
 1. locationMangerDidChangeAuthorization
 : 관리자 인스턴스 생성 및 권한 상태 변화 발생 시 호출
 
 2. checkUserDeviceLocationServiceAuthorization
 : 사용자 디바이스 위치 서비스 활성화 여부 체크
 
 3. checkUserCurrentLocationAuthorization
 : 사용자가 설정한 앱의 위치 접근 허용 권한 상태 체크
 
 4. notDetermined 상태에서 사용자가 새로운 접근 권한을 선택하면 1 -> 2 -> 3 반복
 */

import UIKit
import MapKit
//1.
//import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    // 2.
    let locationManager = CLLocationManager()
    
    let defaultCenter = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    let appleStoreCenter = CLLocationCoordinate2D(latitude: 37.520870, longitude: 127.022772)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegionAndAnnotation(center: appleStoreCenter, title: "애플스토어 가로수길")
        // 4.
        locationManager.delegate = self
    }
    
    // 8
    func setRegionAndAnnotation(center: CLLocationCoordinate2D, title: String) {
        print(#function)
        
        // 보여질 지도 중심 및 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
        
        // 어노테이션
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치 접근 불가", message: "기기의 '설정 -> 개인정보 보호'에서 위치 서비스를 활성화해주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in

          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
        
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}
// 위치 관련된 커스텀 메소드들
extension MapViewController {
    
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
            print("영등포 캠퍼스로 맵뷰 중심 설정")
            setRegionAndAnnotation(center: defaultCenter, title: "영등포 캠퍼스")
            showRequestLocationServiceAlert()
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

// 3.
extension MapViewController: CLLocationManagerDelegate {
    
    // 5. 사용자의 위치를 잘 가져 왔을 때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate, title: "집")
        }
        
        locationManager.stopUpdatingLocation()
    }
    // 6. 사용자의 위치를 가져오지 못 했을 때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        print("사용자의 위치를 가져오지 못 했습니다. 영등포 캠퍼스로 표시합니다.")
    }
    
    // 7.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationServiceAuthorzation()
    }
}
