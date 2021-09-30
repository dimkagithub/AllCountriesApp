//
//  GetData.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

var allCountries = [CountryElement]()

func getData(_ completion: @escaping() -> Void, JSONerrorAlertCallBack: @escaping() -> Void, serverErrorCallBack: @escaping() -> Void) {
    let urlString = "https://restcountries.com/v2/all"
    let configuration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: configuration)
    guard let url = URL(string: urlString) else {
        serverErrorCallBack()
        return
    }
    let task = session.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        guard error == nil else { return }
        do {
            allCountries = try JSONDecoder().decode([CountryElement].self, from: data)
        } catch _ {
            JSONerrorAlertCallBack()
        }
        completion()
    }
    task.resume()
}

extension UIImageView {
    func downloadImageFrom(link: String) {
        URLSession.shared.dataTask(with: URL(string: link)!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}   
