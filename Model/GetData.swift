//
//  GetData.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

var allcountrues = [CountryElement]()

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
            allcountrues = try JSONDecoder().decode([CountryElement].self, from: data)
        } catch _ {
            JSONerrorAlertCallBack()
        }
        completion()
    }
    task.resume()
}
