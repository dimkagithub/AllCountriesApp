//
//  TableViewController.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit
import SystemConfiguration

class TableViewController: UITableViewController {
    
    var allcountries = [CountryStruct]()
    

    
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
        self.title = "Обновление..."
        getData {
            DispatchQueue.main.async {
                self.allcountries = Countries.sortArrays(
                    JSONerrorAlertCallBack: {
                        self.showJSONerrorAlert()
                    })
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

        return  allcountries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.countryName.text = allcountries[indexPath.row].name
        cell.countryFlag.downloadImageFrom(link: allcountries[indexPath.row].flags)
        
        
        
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "ShowCountryInfo" {
             let controller = segue.destination as! ViewController
             if let index = tableView.indexPathForSelectedRow {
                let country = allcountries[index.row]
                controller.name = country.name
                controller.image = country.flags
             }
         }
     }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
