//
//  GetData.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

var name = [String]()
var topLevelDomain = [String]()
var alpha2Code = [String]()
var alpha3Code = [String]()
var callingCodes = [String]()
var capital = [String]()
var altSpellings = [String]()
var region = [String]()
var continent = [Continent]()
var population = [Int]()
var latlng = [Double]()
var demonym = [String]()
var area = [Double]()
var gini = [Double]()
var timezones = [String]()
var borders = [String]()
var nativeName = [String]()
var numericCode = [String]()
var currencies = [Currency]()
var languages = [Language]()
var translations = [Translations]()
var flags = [String]()
var regionalBlocs = [RegionalBloc]()
var cioc = [String]()
var independent = [Bool]()

struct CountryStruct {
    var name: String
    var topLevelDomain: String
    var alpha2Code: String
    var alpha3Code: String
    var callingCodes: String
    var capital: String
    var altSpellings: String
    var region: String
    var continent: Continent
    var population: Int
    var latlng: Double
    var demonym: String
    var area: Double
    var gini: Double
    var timezones: String
    var borders: String
    var nativeName: String
    var numericCode: String
    var currencies: Currency
    var languages: Language
    var translations: Translations
    var flags: String
    var regionalBlocs: RegionalBloc
    var cioc: String
    var independent: Bool
}




func getData() {
    let urlString = "https://restcountries.com/v2/all"
    let configuration = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: configuration)
    guard let url = URL(string: urlString) else {
        print("Жопа")
        return
    }
    let task = session.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        guard error == nil else { return }
        do {
            let countryInfo = try JSONDecoder().decode([CountryElement].self, from: data)
            
            for index in 0..<countryInfo.count {
                name.append(countryInfo[index].name)
                topLevelDomain.append(contentsOf: countryInfo[index].topLevelDomain)
                alpha2Code.append(countryInfo[index].alpha2Code)
                alpha3Code.append(countryInfo[index].alpha3Code)
                callingCodes.append(contentsOf: countryInfo[index].callingCodes)
                capital.append(countryInfo[index].capital ?? "")
                altSpellings.append(contentsOf: countryInfo[index].altSpellings ?? [""])
                region.append(countryInfo[index].region)
                continent.append(countryInfo[index].continent)
                population.append(countryInfo[index].population)
                latlng.append(contentsOf: countryInfo[index].latlng ?? [0])
                demonym.append(countryInfo[index].demonym ?? "")
                area.append(countryInfo[index].area ?? 0)
                gini.append(countryInfo[index].gini ?? 0)
                timezones.append(contentsOf: countryInfo[index].timezones)
                borders.append(contentsOf: countryInfo[index].borders ?? [""])
                nativeName.append(countryInfo[index].nativeName)
                numericCode.append(countryInfo[index].numericCode)
                currencies.append(contentsOf: countryInfo[index].currencies ?? [Currency.init(code: "", name: "", symbol: "")])
                languages.append(contentsOf: countryInfo[index].languages)
                translations.append(countryInfo[index].translations)
                flags.append(contentsOf: countryInfo[index].flags)
                regionalBlocs.append(contentsOf: countryInfo[index].regionalBlocs ?? [RegionalBloc.init(acronym: Acronym.no, name: Name.no, otherNames: [OtherName.no], otherAcronyms: [OtherAcronym.no])])
                cioc.append(countryInfo[index].cioc ?? "")
                independent.append(countryInfo[index].independent)
            }
        } catch let error {
            print(error)
        }
        print(languages[0].name)
        print(languages[1].name)
        print(languages[2].name)

    }
    task.resume()
}

func sortArrays() {
    var sortedCountries = [CountryStruct]()
    for index in 0..<name.count {
        sortedCountries.append(CountryStruct(name: name[index], topLevelDomain: topLevelDomain[index], alpha2Code: alpha2Code[index], alpha3Code: alpha3Code[index], callingCodes: callingCodes[index], capital: capital[index], altSpellings: altSpellings[index], region: region[index], continent: continent[index], population: population[index], latlng: latlng[index], demonym: demonym[index], area: area[index], gini: gini[index], timezones: timezones[index], borders: borders[index], nativeName: nativeName[index], numericCode: numericCode[index], currencies: currencies[index], languages: languages[index], translations: translations[index], flags: flags[index], regionalBlocs: regionalBlocs[index], cioc: cioc[index], independent: independent[index]))
    }
//    sortedCountries = sortedCountries.sorted { item1, item2 in
//        item1.name < item2.name
//    }
    print(sortedCountries[246].name)
    print(sortedCountries[246].languages)
    for index in 0..<sortedCountries.count {
        print("\(sortedCountries[index].name) \(sortedCountries[index].capital) \(sortedCountries[index].population) \(sortedCountries[index].name)")
    }
    print(sortedCountries)
}
