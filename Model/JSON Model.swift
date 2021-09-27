//
//  JSON Model.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

struct CountryElement: Decodable {
    let name: String
    let topLevelDomain: [String]
    let alpha2Code: String
    let alpha3Code: String
    let callingCodes: [String]
    let capital: String?
    let altSpellings: [String]?
    let region: String
    let continent: Continent
    let population: Int
    let latlng: [Double]?
    let demonym: String?
    let area: Double?
    let gini: Double?
    let timezones: [String]
    let borders: [String]?
    let nativeName: String
    let numericCode: String
    let currencies: [Currency]?
    let languages: [Language]
    let translations: Translations
    let flags: [String]
    let regionalBlocs: [RegionalBloc]?
    let cioc: String?
    let independent: Bool

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case topLevelDomain = "topLevelDomain"
        case alpha2Code = "alpha2Code"
        case alpha3Code = "alpha3Code"
        case callingCodes = "callingCodes"
        case capital = "capital"
        case altSpellings = "altSpellings"
        case region = "region"
        case continent = "continent"
        case population = "population"
        case latlng = "latlng"
        case demonym = "demonym"
        case area = "area"
        case gini = "gini"
        case timezones = "timezones"
        case borders = "borders"
        case nativeName = "nativeName"
        case numericCode = "numericCode"
        case currencies = "currencies"
        case languages = "languages"
        case translations = "translations"
        case flags = "flags"
        case regionalBlocs = "regionalBlocs"
        case cioc = "cioc"
        case independent = "independent"
    }
}

enum Continent: String, Decodable {
    case africa = "Africa"
    case americas = "Americas"
    case antarctic = "Antarctic"
    case antarcticOcean = "Antarctic Ocean"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
    case polar = "Polar"
}

struct Currency: Decodable {
    let code: String
    let name: String
    let symbol: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case symbol = "symbol"
    }
}

struct Language: Decodable {
    let iso6391: String?
    let iso6392: String
    let name: String
    let nativeName: String?

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name = "name"
        case nativeName = "nativeName"
    }
}

struct RegionalBloc: Decodable {
    let acronym: Acronym
    let name: Name
    let otherNames: [OtherName]?
    let otherAcronyms: [OtherAcronym]?

    enum CodingKeys: String, CodingKey {
        case acronym = "acronym"
        case name = "name"
        case otherNames = "otherNames"
        case otherAcronyms = "otherAcronyms"
    }
}

enum Acronym: String, Decodable {
    case al = "AL"
    case asean = "ASEAN"
    case au = "AU"
    case cais = "CAIS"
    case caricom = "CARICOM"
    case cefta = "CEFTA"
    case eeu = "EEU"
    case efta = "EFTA"
    case eu = "EU"
    case nafta = "NAFTA"
    case pa = "PA"
    case saarc = "SAARC"
    case usan = "USAN"
    case no = ""
}

enum Name: String, Decodable {
    case africanUnion = "African Union"
    case arabLeague = "Arab League"
    case associationOfSoutheastAsianNations = "Association of Southeast Asian Nations"
    case caribbeanCommunity = "Caribbean Community"
    case centralAmericanIntegrationSystem = "Central American Integration System"
    case centralEuropeanFreeTradeAgreement = "Central European Free Trade Agreement"
    case eurasianEconomicUnion = "Eurasian Economic Union"
    case europeanFreeTradeAssociation = "European Free Trade Association"
    case europeanUnion = "European Union"
    case northAmericanFreeTradeAgreement = "North American Free Trade Agreement"
    case pacificAlliance = "Pacific Alliance"
    case southAsianAssociationForRegionalCooperation = "South Asian Association for Regional Cooperation"
    case unionOfSouthAmericanNations = "Union of South American Nations"
    case no = ""
}

enum OtherAcronym: String, Decodable {
    case eaeu = "EAEU"
    case sica = "SICA"
    case unasul = "UNASUL"
    case unasur = "UNASUR"
    case uzan = "UZAN"
    case no = ""
}

enum OtherName: String, Decodable {
    case accordDeLibreÉchangeNordAméricain = "Accord de Libre-échange Nord-Américain"
    case alianzaDelPacífico = "Alianza del Pacífico"
    case caribischeGemeenschap = "Caribische Gemeenschap"
    case communautéCaribéenne = "Communauté Caribéenne"
    case comunidadDelCaribe = "Comunidad del Caribe"
    case jāmiAtAdDuwalAlArabīyah = "Jāmiʻat ad-Duwal al-ʻArabīyah"
    case leagueOfArabStates = "League of Arab States"
    case sistemaDeLaIntegraciónCentroamericana = "Sistema de la Integración Centroamericana,"
    case southAmericanUnion = "South American Union"
    case tratadoDeLibreComercioDeAméricaDelNorte = "Tratado de Libre Comercio de América del Norte"
    case umojaWaAfrika = "Umoja wa Afrika"
    case unieVanZuidAmerikaanseNaties = "Unie van Zuid-Amerikaanse Naties"
    case unionAfricaine = "Union africaine"
    case uniãoAfricana = "União Africana"
    case uniãoDeNaçõesSulAmericanas = "União de Nações Sul-Americanas"
    case uniónAfricana = "Unión Africana"
    case uniónDeNacionesSuramericanas = "Unión de Naciones Suramericanas"
    case الاتحادالأفريقي = "الاتحاد الأفريقي"
    case جامعةالدولالعربية = "جامعة الدول العربية"
    case no = ""
}

struct Translations: Decodable {
    let br: String
    let pt: String
    let nl: String?
    let hr: String?
    let fa: String?
    let de: String?
    let es: String?
    let fr: String
    let ja: String?
    let it: String?
    let hu: String?

    enum CodingKeys: String, CodingKey {
        case br = "br"
        case pt = "pt"
        case nl = "nl"
        case hr = "hr"
        case fa = "fa"
        case de = "de"
        case es = "es"
        case fr = "fr"
        case ja = "ja"
        case it = "it"
        case hu = "hu"
    }
}

typealias Country = [CountryElement]
