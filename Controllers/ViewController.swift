//
//  ViewController.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 26.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainCountryInfoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var countryTableVew: UITableView!
    
    var countryInfo = [[String]]()
    var countryName = String()
    var countryFlag = String()
    var countryTitle = [
        "Top level domain",
        "Alpha 2 code",
        "Alpha 3 code",
        "Calling codes",
        "Capital",
        "Alt spellings",
        "Subregion",
        "Region",
        "Population",
        "Latitude, longitude",
        "Demonym",
        "Area",
        "GINI",
        "Time zones",
        "Borders",
        "Native name",
        "Numeric code",
        "Currency",
        "Languages",
        "Translations",
        "Regional Blocs",
        "CIOC",
        "Independent"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableVew.delegate = self
        countryTableVew.dataSource = self
        countryTableVew.separatorStyle = .none
        countryTableVew.showsVerticalScrollIndicator = false
        overrideUserInterfaceStyle = .light
        mainCountryInfoView.layer.cornerRadius = mainCountryInfoView.frame.width / 50
        mainCountryInfoView.layer.borderWidth = 0.1
        self.title = countryName
        name.text = countryName
        flag.downloadImageFrom(link: countryFlag)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTableVew.dequeueReusableCell(withIdentifier: "CustomCell") as! ViewControllerCell
        cell.countryView.layer.cornerRadius = cell.countryView.frame.width / 50
        cell.countryView.layer.borderWidth = 0.1
        cell.countryTitle.text = countryTitle[indexPath.row]
        cell.countryInfo.text = countryInfo[indexPath.row].joined(separator: ", ")
        return cell
    }
}
