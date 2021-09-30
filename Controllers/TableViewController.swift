//
//  TableViewController.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit
import SystemConfiguration

class TableViewController: UITableViewController {
    
    var filteredCountries = [CountryElement]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var filtering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showNoInternetAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Нет соединения с интернет", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showJSONerrorAlert() {
        let alert = UIAlertController(title: "Ошибка обработки данных", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showServerErrorAlert() {
        let alert = UIAlertController(title: "Сервер недоступен", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.title = "Все страны"
        getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } JSONerrorAlertCallBack: {
            DispatchQueue.main.async {
                self.showJSONerrorAlert()
            }
        } serverErrorCallBack: {
            DispatchQueue.main.async {
                self.showServerErrorAlert()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtering {
            return filteredCountries.count
        } else {
            return allCountries.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        tableView.keyboardDismissMode = .onDrag
        var countries: CountryElement
        cell.tableViewCell.layer.cornerRadius = cell.tableViewCell.frame.width / 50
        cell.tableViewCell.layer.borderWidth = 0.1
        if filtering {
            countries = filteredCountries[indexPath.row]
        } else {
            countries = allCountries[indexPath.row]
        }
        cell.countryName.text = countries.name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCountryInfo" {
            let controller = segue.destination as! ViewController
            if let index = tableView.indexPathForSelectedRow {
                var country: CountryElement
                if filtering {
                    country = filteredCountries[index.row]
                } else {
                    country = allCountries[index.row]
                }
                controller.countryName = country.name
                controller.countryFlag = country.flags.png
                controller.countryInfo.append(country.topLevelDomain)
                controller.countryInfo.append([country.alpha2Code])
                controller.countryInfo.append([country.alpha3Code])
                controller.countryInfo.append(country.callingCodes)
                controller.countryInfo.append([country.capital ?? ""])
                controller.countryInfo.append(country.altSpellings ?? [""])
                controller.countryInfo.append([country.subregion])
                controller.countryInfo.append([country.region.rawValue])
                controller.countryInfo.append([String(country.population)])
                controller.countryInfo.append([String(String(describing: country.latlng!))])
                controller.countryInfo.append([country.demonym!])
                controller.countryInfo.append([String(country.area!)])
                controller.countryInfo.append([String(country.gini ?? 0)])
                controller.countryInfo.append(country.timezones)
                controller.countryInfo.append(country.borders ?? [""])
                controller.countryInfo.append([country.nativeName])
                controller.countryInfo.append([country.numericCode])
                controller.countryInfo.append([String(describing: country.currencies)])
                controller.countryInfo.append([String(describing: country.languages)])
                controller.countryInfo.append([String(describing: country.translations)])
                controller.countryInfo.append([String(describing: country.regionalBlocs)])
                controller.countryInfo.append([country.cioc ?? ""])
                if country.independent == true {
                    controller.countryInfo.append(["Yes"])
                } else {
                    controller.countryInfo.append(["No"])
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = allCountries.filter({ (allCountries: CountryElement) -> Bool in
            return allCountries.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
