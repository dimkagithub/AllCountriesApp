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
    var nativeName = [String]()
    var languages = [String]()
    var countryCode = [String]()
    var translate = [String]()
    var latLong = [String]()
    var currency = [String]()
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
        cell.countryName.text = countries.name.common
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        nativeName.removeAll()
        languages.removeAll()
        countryCode.removeAll()
        translate.removeAll()
        latLong.removeAll()
        currency.removeAll()
        if segue.identifier == "ShowCountryInfo" {
            let controller = segue.destination as! ViewController
            if let index = tableView.indexPathForSelectedRow {
                var country: CountryElement
                if filtering {
                    country = filteredCountries[index.row]
                } else {
                    country = allCountries[index.row]
                }
                controller.countryName = country.name.common
                controller.countryFlag = country.flags.png
                
                for element in country.name.nativeName!.values {
                    nativeName.append(String(element.official))
                }
                controller.countryInfo.append(nativeName.sorted())
                controller.countryInfo.append(country.tld ?? [""])
                controller.countryInfo.append([country.cca2])
                controller.countryInfo.append([country.cca3])
                controller.countryInfo.append([String(country.ccn3 ?? "")])
                controller.countryInfo.append([country.cioc ?? ""])
                if country.independent == true {
                    controller.countryInfo.append(["Yes"])
                } else {
                    controller.countryInfo.append(["No"])
                }
                if country.status.rawValue == "officially-assigned" {
                    controller.countryInfo.append(["Officially assigned"])
                } else {
                    controller.countryInfo.append(["User assigned"])
                }
                
                if country.unMember == true {
                    controller.countryInfo.append(["Yes"])
                } else {
                    controller.countryInfo.append(["No"])
                }
                currency.append(contentsOf: [String((country.currencies?.afn!.name)!)])
                currency.append(contentsOf: [String((country.currencies?.afn!.symbol)!)])
                controller.countryInfo.append(currency)
                //                controller.countryInfo.append([String(country.currencies.debugDescription)])
                countryCode.append(country.idd.root!)
                countryCode.append(contentsOf: country.idd.suffixes!)
                controller.countryInfo.append([countryCode.joined(separator: " ")])
                controller.countryInfo.append(country.capital ?? [""])
                controller.countryInfo.append(country.altSpellings)
                controller.countryInfo.append([country.region.rawValue])
                controller.countryInfo.append([String(country.subregion ?? "")])
                for element in country.languages!.values {
                    languages.append(element)
                }
                controller.countryInfo.append(languages.sorted())
                if let translations = country.translations["rus"] {
                    translate.append(translations.official)
                }
                if let translations = country.translations["deu"] {
                    translate.append(translations.official)
                }
                if let translations = country.translations["fra"] {
                    translate.append(translations.official)
                }
                translate.sort { (lhs: String, rhs: String) -> Bool in
                    return lhs > rhs
                }
                translate = translate.map { $0.capitalized}
                controller.countryInfo.append(translate)
                for element in country.latlng {
                    latLong.append(String(element))
                }
                controller.countryInfo.append(latLong)
                if country.landlocked == true {
                    controller.countryInfo.append(["Yes"])
                } else {
                    controller.countryInfo.append(["No"])
                }
                controller.countryInfo.append(country.borders ?? [""])
                controller.countryInfo.append([String(country.area)])
                for element in ([String((country.demonyms?.eng.m)!)]) {
                    controller.countryInfo.append([element])
                }
                controller.countryInfo.append([String(country.population)])
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
            return allCountries.name.common.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
