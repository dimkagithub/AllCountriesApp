//
//  JSON Model.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

struct CountryElement: Codable {
    let name: Name
    let tld: [String]?
    let cca2: String
    let ccn3: String?
    let cca3: String
    let cioc: String?
    let independent: Bool?
    let status: Status
    let unMember: Bool
    let currencies: Currencies?
    let idd: Idd
    let capital: [String]?
    let altSpellings: [String]
    let region: Region
    let subregion: String?
    let languages: [String: String]?
    let translations: [String: Translation]
    let latlng: [Double]
    let landlocked: Bool
    let borders: [String]?
    let area: Double
    let demonyms: Demonyms?
    let flag: String?
    let maps: Maps
    let population: Int
    let flags: Flags
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case tld = "tld"
        case cca2 = "cca2"
        case ccn3 = "ccn3"
        case cca3 = "cca3"
        case cioc = "cioc"
        case independent = "independent"
        case status = "status"
        case unMember = "unMember"
        case currencies = "currencies"
        case idd = "idd"
        case capital = "capital"
        case altSpellings = "altSpellings"
        case region = "region"
        case subregion = "subregion"
        case languages = "languages"
        case translations = "translations"
        case latlng = "latlng"
        case landlocked = "landlocked"
        case borders = "borders"
        case area = "area"
        case demonyms = "demonyms"
        case flag = "flag"
        case maps = "maps"
        case population = "population"
        case flags = "flags"
    }
}

struct Currencies: Codable {
    let xof: Aed?
    let all: Aed?
    let eur: Aed?
    let cop: Aed?
    let myr: Aed?
    let uah: Aed?
    let stn: Aed?
    let gyd: Aed?
    let mdl: Aed?
    let usd: Aed?
    let xaf: Aed?
    let djf: Aed?
    let xpf: Aed?
    let xcd: Aed?
    let bob: Aed?
    let ghs: Aed?
    let bsd: Aed?
    let zmw: Aed?
    let twd: Aed?
    let dkk: Aed?
    let fok: Aed?
    let aoa: Aed?
    let nok: Aed?
    let mnt: Aed?
    let gel: Aed?
    let htg: Aed?
    let btn: Aed?
    let inr: Aed?
    let amd: Aed?
    let kwd: Aed?
    let cuc: Aed?
    let cup: Aed?
    let lrd: Aed?
    let irr: Aed?
    let jod: Aed?
    let aud: Aed?
    let gbp: Aed?
    let jep: Aed?
    let shp: Aed?
    let rwf: Aed?
    let gnf: Aed?
    let krw: Aed?
    let bam: BAM?
    let vnd: Aed?
    let hrk: Aed?
    let kes: Aed?
    let kgs: Aed?
    let lyd: Aed?
    let chf: Aed?
    let nzd: Aed?
    let pab: Aed?
    let pen: Aed?
    let php: Aed?
    let ang: Aed?
    let ils: Aed?
    let hnl: Aed?
    let brl: Aed?
    let sek: Aed?
    let fjd: Aed?
    let sos: Aed?
    let khr: Aed?
    let szl: Aed?
    let zar: Aed?
    let ngn: Aed?
    let wst: Aed?
    let bwp: Aed?
    let mvr: Aed?
    let ttd: Aed?
    let idr: Aed?
    let kzt: Aed?
    let iqd: Aed?
    let bhd: Aed?
    let kpw: Aed?
    let mad: Aed?
    let kmf: Aed?
    let ggp: Aed?
    let bbd: Aed?
    let ssp: Aed?
    let azn: Aed?
    let sgd: Aed?
    let bnd: Aed?
    let sbd: Aed?
    let sar: Aed?
    let bdt: Aed?
    let bif: Aed?
    let ern: Aed?
    let ars: Aed?
    let mop: Aed?
    let top: Aed?
    let qar: Aed?
    let kyd: Aed?
    let mxn: Aed?
    let isk: Aed?
    let pln: Aed?
    let omr: Aed?
    let etb: Aed?
    let vuv: Aed?
    let nio: Aed?
    let rsd: Aed?
    let czk: Aed?
    let currenciesTry: Aed?
    let mur: Aed?
    let mkd: Aed?
    let afn: Aed?
    let gtq: Aed?
    let lsl: Aed?
    let awg: Aed?
    let npr: Aed?
    let tjs: Aed?
    let scr: Aed?
    let bzd: Aed?
    let sll: Aed?
    let syp: Aed?
    let mwk: Aed?
    let bgn: Aed?
    let tvd: Aed?
    let imp: Aed?
    let huf: Aed?
    let rub: Aed?
    let pyg: Aed?
    let uyu: Aed?
    let clp: Aed?
    let yer: Aed?
    let nad: Aed?
    let lkr: Aed?
    let mga: Aed?
    let crc: Aed?
    let cny: Aed?
    let jpy: Aed?
    let zwb: Aed?
    let ron: Aed?
    let dzd: Aed?
    let lbp: Aed?
    let dop: Aed?
    let pkr: Aed?
    let byn: Aed?
    let cdf: Aed?
    let tmt: Aed?
    let ves: Aed?
    let kid: Aed?
    let ckd: Aed?
    let egp: Aed?
    let sdg: BAM?
    let uzs: Aed?
    let ugx: Aed?
    let gip: Aed?
    let cad: Aed?
    let hkd: Aed?
    let lak: Aed?
    let pgk: Aed?
    let mmk: Aed?
    let bmd: Aed?
    let cve: Aed?
    let mru: Aed?
    let aed: Aed?
    let tnd: Aed?
    let tzs: Aed?
    let thb: Aed?
    let mzn: Aed?
    let fkp: Aed?
    let srd: Aed?
    let jmd: Aed?
    let gmd: Aed?
    
    enum CodingKeys: String, CodingKey {
        case xof = "XOF"
        case all = "ALL"
        case eur = "EUR"
        case cop = "COP"
        case myr = "MYR"
        case uah = "UAH"
        case stn = "STN"
        case gyd = "GYD"
        case mdl = "MDL"
        case usd = "USD"
        case xaf = "XAF"
        case djf = "DJF"
        case xpf = "XPF"
        case xcd = "XCD"
        case bob = "BOB"
        case ghs = "GHS"
        case bsd = "BSD"
        case zmw = "ZMW"
        case twd = "TWD"
        case dkk = "DKK"
        case fok = "FOK"
        case aoa = "AOA"
        case nok = "NOK"
        case mnt = "MNT"
        case gel = "GEL"
        case htg = "HTG"
        case btn = "BTN"
        case inr = "INR"
        case amd = "AMD"
        case kwd = "KWD"
        case cuc = "CUC"
        case cup = "CUP"
        case lrd = "LRD"
        case irr = "IRR"
        case jod = "JOD"
        case aud = "AUD"
        case gbp = "GBP"
        case jep = "JEP"
        case shp = "SHP"
        case rwf = "RWF"
        case gnf = "GNF"
        case krw = "KRW"
        case bam = "BAM"
        case vnd = "VND"
        case hrk = "HRK"
        case kes = "KES"
        case kgs = "KGS"
        case lyd = "LYD"
        case chf = "CHF"
        case nzd = "NZD"
        case pab = "PAB"
        case pen = "PEN"
        case php = "PHP"
        case ang = "ANG"
        case ils = "ILS"
        case hnl = "HNL"
        case brl = "BRL"
        case sek = "SEK"
        case fjd = "FJD"
        case sos = "SOS"
        case khr = "KHR"
        case szl = "SZL"
        case zar = "ZAR"
        case ngn = "NGN"
        case wst = "WST"
        case bwp = "BWP"
        case mvr = "MVR"
        case ttd = "TTD"
        case idr = "IDR"
        case kzt = "KZT"
        case iqd = "IQD"
        case bhd = "BHD"
        case kpw = "KPW"
        case mad = "MAD"
        case kmf = "KMF"
        case ggp = "GGP"
        case bbd = "BBD"
        case ssp = "SSP"
        case azn = "AZN"
        case sgd = "SGD"
        case bnd = "BND"
        case sbd = "SBD"
        case sar = "SAR"
        case bdt = "BDT"
        case bif = "BIF"
        case ern = "ERN"
        case ars = "ARS"
        case mop = "MOP"
        case top = "TOP"
        case qar = "QAR"
        case kyd = "KYD"
        case mxn = "MXN"
        case isk = "ISK"
        case pln = "PLN"
        case omr = "OMR"
        case etb = "ETB"
        case vuv = "VUV"
        case nio = "NIO"
        case rsd = "RSD"
        case czk = "CZK"
        case currenciesTry = "TRY"
        case mur = "MUR"
        case mkd = "MKD"
        case afn = "AFN"
        case gtq = "GTQ"
        case lsl = "LSL"
        case awg = "AWG"
        case npr = "NPR"
        case tjs = "TJS"
        case scr = "SCR"
        case bzd = "BZD"
        case sll = "SLL"
        case syp = "SYP"
        case mwk = "MWK"
        case bgn = "BGN"
        case tvd = "TVD"
        case imp = "IMP"
        case huf = "HUF"
        case rub = "RUB"
        case pyg = "PYG"
        case uyu = "UYU"
        case clp = "CLP"
        case yer = "YER"
        case nad = "NAD"
        case lkr = "LKR"
        case mga = "MGA"
        case crc = "CRC"
        case cny = "CNY"
        case jpy = "JPY"
        case zwb = "ZWB"
        case ron = "RON"
        case dzd = "DZD"
        case lbp = "LBP"
        case dop = "DOP"
        case pkr = "PKR"
        case byn = "BYN"
        case cdf = "CDF"
        case tmt = "TMT"
        case ves = "VES"
        case kid = "KID"
        case ckd = "CKD"
        case egp = "EGP"
        case sdg = "SDG"
        case uzs = "UZS"
        case ugx = "UGX"
        case gip = "GIP"
        case cad = "CAD"
        case hkd = "HKD"
        case lak = "LAK"
        case pgk = "PGK"
        case mmk = "MMK"
        case bmd = "BMD"
        case cve = "CVE"
        case mru = "MRU"
        case aed = "AED"
        case tnd = "TND"
        case tzs = "TZS"
        case thb = "THB"
        case mzn = "MZN"
        case fkp = "FKP"
        case srd = "SRD"
        case jmd = "JMD"
        case gmd = "GMD"
    }
}

struct Aed: Codable {
    let name: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
    }
}

struct BAM: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

struct Demonyms: Codable {
    let eng: Eng
    let fra: Eng?
    
    enum CodingKeys: String, CodingKey {
        case eng = "eng"
        case fra = "fra"
    }
}

struct Eng: Codable {
    let f: String
    let m: String
    
    enum CodingKeys: String, CodingKey {
        case f = "f"
        case m = "m"
    }
}

struct Flags: Codable {
    let svg: String
    let png: String
    
    enum CodingKeys: String, CodingKey {
        case svg = "svg"
        case png = "png"
    }
}

struct Idd: Codable {
    let root: String?
    let suffixes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case root = "root"
        case suffixes = "suffixes"
    }
}

struct Maps: Codable {
    let googleMaps: String
    let openStreetMaps: String
    
    enum CodingKeys: String, CodingKey {
        case googleMaps = "googleMaps"
        case openStreetMaps = "openStreetMaps"
    }
}

struct Name: Codable {
    let common: String
    let official: String
    let nativeName: [String: Translation]?
    
    enum CodingKeys: String, CodingKey {
        case common = "common"
        case official = "official"
        case nativeName = "nativeName"
    }
}

struct Translation: Codable {
    let official: String
    let common: String
    
    enum CodingKeys: String, CodingKey {
        case official = "official"
        case common = "common"
    }
}

enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
}

enum Status: String, Codable {
    case officiallyAssigned = "officially-assigned"
    case userAssigned = "user-assigned"
}
