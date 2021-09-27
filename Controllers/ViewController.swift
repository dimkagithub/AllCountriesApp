//
//  ViewController.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 26.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryPopulation: UILabel!
    
    
    var name = String()
    var image = String()
    var population = Int()
    var languages = [String]()
    var topLevelDomain = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = name
        countryName.text = name
        countryFlag.downloadImageFrom(link: image)
//        countryPopulation.text = ("Население: \(String(population))")

//        for item in languages {
//            countryPopulation.text = item
//        }
        countryPopulation.text = languages.joined(separator: ", ")
        countryPopulation.text = topLevelDomain
        
        
        
//        for index in 0..<languages.count {
//            print(languages)
//        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
