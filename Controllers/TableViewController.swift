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
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.gray
        }
        searchController.searchBar.searchTextField.leftView?.tintColor = .gray
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
                if country.name.nativeName?.values == nil {
                    nativeName.append(" ")
                    controller.countryInfo.append(nativeName)
                } else {
                    
                    for element in country.name.nativeName!.values {
                        nativeName.append(String(element.official))
                    }
                    controller.countryInfo.append(nativeName.sorted())
                }
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
                currency.append(contentsOf: [String((country.currencies?.xof?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xof?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.all?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.all?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.eur?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.eur?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cop?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cop?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.myr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.myr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uah?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uah?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.stn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.stn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gyd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gyd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mdl?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mdl?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.usd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.usd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xaf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xaf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.djf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.djf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xpf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xpf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xcd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.xcd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bob?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bob?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ghs?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ghs?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bsd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bsd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zmw?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zmw?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.twd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.twd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dkk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dkk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fok?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fok?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aoa?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aoa?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nok?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nok?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mnt?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mnt?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gel?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gel?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.htg?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.htg?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.btn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.btn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.inr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.inr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.amd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.amd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kwd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kwd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cuc?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cuc?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cup?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cup?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lrd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lrd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.irr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.irr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jod?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jod?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aud?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aud?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gbp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gbp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jep?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jep?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.shp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.shp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rwf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rwf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gnf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gnf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.krw?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.krw?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bam?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.vnd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.vnd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hrk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hrk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kes?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kes?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kgs?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kgs?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lyd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lyd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.chf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.chf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nzd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nzd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pab?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pab?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pen?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pen?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.php?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.php?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ang?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ang?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ils?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ils?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hnl?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hnl?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.brl?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.brl?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sek?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sek?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fjd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fjd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sos?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sos?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.khr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.khr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.szl?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.szl?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zar?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zar?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ngn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ngn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.wst?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.wst?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bwp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bwp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mvr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mvr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ttd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ttd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.idr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.idr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kzt?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kzt?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.iqd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.iqd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bhd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bhd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kpw?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kpw?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mad?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mad?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kmf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kmf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ggp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ggp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bbd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bbd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ssp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ssp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.azn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.azn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sgd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sgd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bnd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bnd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sbd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sbd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sar?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sar?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bdt?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bdt?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bif?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bif?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ern?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ern?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ars?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ars?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mop?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mop?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.top?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.top?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.qar?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.qar?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kyd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kyd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mxn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mxn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.isk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.isk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pln?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pln?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.omr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.omr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.etb?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.etb?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.vuv?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.vuv?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nio?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nio?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rsd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rsd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.czk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.czk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.currenciesTry?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.currenciesTry?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mur?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mur?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mkd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mkd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.afn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.afn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gtq?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gtq?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lsl?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lsl?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.awg?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.awg?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.npr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.npr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tjs?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tjs?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.scr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.scr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bzd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bzd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sll?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sll?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.syp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.syp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mwk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mwk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bgn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bgn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tvd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tvd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.imp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.imp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.huf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.huf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rub?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.rub?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pyg?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pyg?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uyu?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uyu?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.clp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.clp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.yer?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.yer?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nad?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.nad?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lkr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lkr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mga?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mga?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.crc?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.crc?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cny?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cny?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jpy?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jpy?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zwb?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.zwb?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ron?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ron?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dzd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dzd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lbp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lbp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dop?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.dop?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pkr?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pkr?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.byn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.byn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cdf?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cdf?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tmt?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tmt?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ves?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ves?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kid?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.kid?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ckd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ckd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.egp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.egp?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.sdg?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uzs?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.uzs?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ugx?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.ugx?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gip?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gip?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cad?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cad?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hkd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.hkd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lak?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.lak?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pgk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.pgk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mmk?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mmk?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bmd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.bmd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cve?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.cve?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mru?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mru?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aed?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.aed?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tnd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tnd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tzs?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.tzs?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.thb?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.thb?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mzn?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.mzn?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fkp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.fkp?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.srd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.srd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jmd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.jmd?.symbol ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gmd?.name ?? ""))])
                currency.append(contentsOf: [String((country.currencies?.gmd?.symbol ?? ""))])
                currency.sort()
                var oneCurrency = currency.filter { $0 != "" }
                controller.countryInfo.append(oneCurrency)
                oneCurrency.removeAll()
                if country.idd.root == nil && country.idd.suffixes == nil {
                    countryCode.append("")
                } else {
                    countryCode.append(country.idd.root!)
                    countryCode.append(contentsOf: country.idd.suffixes!)
                }
                controller.countryInfo.append([countryCode.joined(separator: " ")])
                controller.countryInfo.append(country.capital ?? [""])
                controller.countryInfo.append(country.altSpellings)
                controller.countryInfo.append([country.region.rawValue])
                controller.countryInfo.append([String(country.subregion ?? "")])
                if country.languages == nil {
                    languages.append("")
                } else {
                    for element in country.languages!.values {
                        languages.append(element)
                    }
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
                let area = country.area
                let areaNumberFormatter = NumberFormatter()
                areaNumberFormatter.numberStyle = NumberFormatter.Style.decimal
                areaNumberFormatter.groupingSeparator = " "
                let formattedArea = areaNumberFormatter.string(from: NSNumber(value:area))
                controller.countryInfo.append([String(formattedArea ?? "")])
                for element in ([String((country.demonyms?.eng.m)!)]) {
                    controller.countryInfo.append([element])
                }
                let population = country.population
                let populationNumberFormatter = NumberFormatter()
                populationNumberFormatter.numberStyle = NumberFormatter.Style.decimal
                populationNumberFormatter.groupingSeparator = " "
                let formattedPopulation = populationNumberFormatter.string(from: NSNumber(value:population))
                controller.countryInfo.append([String(formattedPopulation ?? "")])
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
