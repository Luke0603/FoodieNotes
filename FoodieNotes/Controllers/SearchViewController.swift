//
//  SearchViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/10/25.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var uiViewController: UIViewController!
    var longitude: Double!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
    
    @IBAction func didTouchUpBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            if let storeMaintainInfoViewController = self.uiViewController as? StoreMaintainInfoViewController {
                
                storeMaintainInfoViewController.addressTextField.text = response?.mapItems[0].name
                storeMaintainInfoViewController.latitude = coordinate!.latitude
                storeMaintainInfoViewController.longitude = coordinate!.longitude
            } else if let addSimplePostViewController = self.uiViewController as? AddSimplePostViewController {
                
                addSimplePostViewController.postStoreAddressTextField.text = response?.mapItems[0].name
                addSimplePostViewController.latitude = coordinate!.latitude
                addSimplePostViewController.longitude = coordinate!.longitude
            }
            self.dismiss(animated: true, completion: nil)
            //            self.geocode(latitude: coordinate!.latitude, longitude: coordinate!.longitude) { placemark, error in
            //                guard let placemark = placemark, error == nil else { return }
            //                // you should always update your UI in the main thread
            //                DispatchQueue.main.async {
            //                    //  update UI here
            //                    print("address1:", placemark.thoroughfare ?? "")
            //                    print("address2:", placemark.subThoroughfare ?? "")
            //                    print("city:",     placemark.locality ?? "")
            //                    print("state:",    placemark.administrativeArea ?? "")
            //                    print("zip code:", placemark.postalCode ?? "")
            //                    print("country:",  placemark.country ?? "")
            //                    print("placemark:",placemark.subLocality ?? "")
            //                    let address = "\(placemark.subThoroughfare ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
            //                    print("\(address)")
            //                    print(String(describing: coordinate))
            //                    self.dismiss(animated: true, completion: nil)
            //                }
            //            }
        }
    }
}

extension SearchViewController {
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        //1
        let locale = Locale(identifier: "zh_TW")
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    //                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    completion(nil, error)
                    return
                }
                completion(placemark, nil)
            }
        }
    }
    
    func locationAddress(Latitude latitude: Double, Longitude longitude: Double) {
        //CLGeocoder地理編碼 經緯度轉換地址位置
        geocode(latitude: latitude, longitude: longitude) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                //  update UI here
                print("address1:", placemark.thoroughfare ?? "")
                print("address2:", placemark.subThoroughfare ?? "")
                print("city:",     placemark.locality ?? "")
                print("state:",    placemark.administrativeArea ?? "")
                print("zip code:", placemark.postalCode ?? "")
                print("country:",  placemark.country ?? "")
                print("placemark",placemark)
                
            }
        }
    }
}
