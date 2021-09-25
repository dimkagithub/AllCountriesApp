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
    
    var name = String()
    var image = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        countryName.text = name
        countryFlag.image = UIImage(named: image)
        print(image)
        

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
