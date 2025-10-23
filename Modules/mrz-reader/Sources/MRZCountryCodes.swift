import Foundation

/// Valid country codes for Machine Readable Zone (MRZ) validation
/// Based on ISO 3166-1 alpha-3 with MRZ-specific modifications
/// According to ICAO Document 9303 specifications
struct MRZCountryCodes {

  static let validCodes: Set<String> = [
    // A
    "ABW", // Aruba
    "AFG", // Afghanistan
    "AGO", // Angola
    "AIA", // Anguilla
    "ALA", // Åland Islands
    "ALB", // Albania
    "AND", // Andorra
    "ARE", // United Arab Emirates
    "ARG", // Argentina
    "ARM", // Armenia
    "ASM", // American Samoa
    "ATA", // Antarctica
    "ATF", // French Southern Territories
    "ATG", // Antigua and Barbuda
    "AUS", // Australia
    "AUT", // Austria
    "AZE", // Azerbaijan

    // B
    "BAH", // Bahamas (legacy MRZ code - erroneously used in some early Bahamian passports)
    "BDI", // Burundi
    "BEL", // Belgium
    "BEN", // Benin
    "BES", // Bonaire, Sint Eustatius and Saba
    "BFA", // Burkina Faso
    "BGD", // Bangladesh
    "BGR", // Bulgaria
    "BHR", // Bahrain
    "BHS", // Bahamas
    "BIH", // Bosnia and Herzegovina
    "BLM", // Saint Barthélemy
    "BLR", // Belarus
    "BLZ", // Belize
    "BMU", // Bermuda
    "BOL", // Bolivia
    "BRA", // Brazil
    "BRB", // Barbados
    "BRN", // Brunei
    "BTN", // Bhutan
    "BVT", // Bouvet Island
    "BWA", // Botswana

    // C
    "CAF", // Central African Republic
    "CAN", // Canada
    "CCK", // Cocos (Keeling) Islands
    "CHE", // Switzerland
    "CHL", // Chile
    "CHN", // China
    "CIV", // Côte d'Ivoire
    "CMR", // Cameroon
    "COD", // Democratic Republic of the Congo
    "COG", // Republic of the Congo
    "COK", // Cook Islands
    "COL", // Colombia
    "COM", // Comoros
    "CPV", // Cape Verde
    "CRI", // Costa Rica
    "CUB", // Cuba
    "CUW", // Curaçao
    "CXR", // Christmas Island
    "CYM", // Cayman Islands
    "CYP", // Cyprus
    "CZE", // Czech Republic

    // D
    "D",   // Germany (legacy MRZ code - still used in some German documents)
    "DEU", // Germany
    "DJI", // Djibouti
    "DMA", // Dominica
    "DNK", // Denmark
    "DOM", // Dominican Republic
    "DZA", // Algeria

    // E
    "ECU", // Ecuador
    "EGY", // Egypt
    "ERI", // Eritrea
    "ESH", // Western Sahara
    "ESP", // Spain
    "EST", // Estonia
    "ETH", // Ethiopia
    "EUE", // European Union (MRZ-specific code)

    // F
    "FIN", // Finland
    "FJI", // Fiji
    "FLK", // Falkland Islands
    "FRA", // France
    "FRO", // Faroe Islands
    "FSM", // Micronesia

    // G
    "GAB", // Gabon
    "GBD", // British Overseas Territories Citizen / British Dependent Territories Citizen (MRZ-specific)
    "GBN", // British National (Overseas) (MRZ-specific)
    "GBO", // British Overseas Citizen (MRZ-specific)
    "GBP", // British Protected Person (MRZ-specific)
    "GBR", // United Kingdom
    "GBS", // British Subject (MRZ-specific)
    "GEO", // Georgia
    "GGY", // Guernsey
    "GHA", // Ghana
    "GIB", // Gibraltar
    "GIN", // Guinea
    "GLP", // Guadeloupe
    "GMB", // Gambia
    "GNB", // Guinea-Bissau
    "GNQ", // Equatorial Guinea
    "GRC", // Greece
    "GRD", // Grenada
    "GRL", // Greenland
    "GTM", // Guatemala
    "GUF", // French Guiana
    "GUM", // Guam
    "GUY", // Guyana

    // H
    "HKG", // Hong Kong
    "HMD", // Heard Island and McDonald Islands
    "HND", // Honduras
    "HRV", // Croatia
    "HTI", // Haiti
    "HUN", // Hungary

    // I
    "IDN", // Indonesia
    "IMN", // Isle of Man
    "IND", // India
    "IOT", // British Indian Ocean Territory
    "IRL", // Ireland
    "IRN", // Iran
    "IRQ", // Iraq
    "ISL", // Iceland
    "ISR", // Israel
    "ITA", // Italy

    // J
    "JAM", // Jamaica
    "JEY", // Jersey
    "JOR", // Jordan
    "JPN", // Japan

    // K
    "KAZ", // Kazakhstan
    "KEN", // Kenya
    "KGZ", // Kyrgyzstan
    "KHM", // Cambodia
    "KIR", // Kiribati
    "KNA", // Saint Kitts and Nevis
    "KOR", // South Korea
    "KWT", // Kuwait

    // L
    "LAO", // Laos
    "LBN", // Lebanon
    "LBR", // Liberia
    "LBY", // Libya
    "LCA", // Saint Lucia
    "LIE", // Liechtenstein
    "LKA", // Sri Lanka
    "LSO", // Lesotho
    "LTU", // Lithuania
    "LUX", // Luxembourg
    "LVA", // Latvia

    // M
    "MAC", // Macao
    "MAF", // Saint Martin
    "MAR", // Morocco
    "MCO", // Monaco
    "MDA", // Moldova
    "MDG", // Madagascar
    "MDV", // Maldives
    "MEX", // Mexico
    "MHL", // Marshall Islands
    "MKD", // North Macedonia
    "MLI", // Mali
    "MLT", // Malta
    "MMR", // Myanmar
    "MNE", // Montenegro
    "MNG", // Mongolia
    "MNP", // Northern Mariana Islands
    "MOZ", // Mozambique
    "MRT", // Mauritania
    "MSR", // Montserrat
    "MTQ", // Martinique
    "MUS", // Mauritius
    "MWI", // Malawi
    "MYS", // Malaysia
    "MYT", // Mayotte

    // N
    "NAM", // Namibia
    "NCL", // New Caledonia
    "NER", // Niger
    "NFK", // Norfolk Island
    "NGA", // Nigeria
    "NIC", // Nicaragua
    "NIU", // Niue
    "NLD", // Netherlands
    "NOR", // Norway
    "NPL", // Nepal
    "NRU", // Nauru
    "NSK", // Neue Slowenische Kunst passport (limited acceptance)
    "NZL", // New Zealand

    // O
    "OMN", // Oman

    // P
    "PAK", // Pakistan
    "PAN", // Panama
    "PCN", // Pitcairn Islands
    "PER", // Peru
    "PHL", // Philippines
    "PLW", // Palau
    "PNG", // Papua New Guinea
    "POL", // Poland
    "PRI", // Puerto Rico
    "PRK", // North Korea
    "PRT", // Portugal
    "PRY", // Paraguay
    "PSE", // Palestine
    "PYF", // French Polynesia

    // Q
    "QAT", // Qatar

    // R
    "REU", // Réunion
    "RKS", // Kosovo (MRZ-specific code)
    "ROU", // Romania
    "RUS", // Russia
    "RWA", // Rwanda

    // S
    "SAU", // Saudi Arabia
    "SDN", // Sudan
    "SEN", // Senegal
    "SGP", // Singapore
    "SGS", // South Georgia and the South Sandwich Islands
    "SHN", // Saint Helena, Ascension and Tristan da Cunha
    "SJM", // Svalbard and Jan Mayen
    "SLB", // Solomon Islands
    "SLE", // Sierra Leone
    "SLV", // El Salvador
    "SMR", // San Marino
    "SOM", // Somalia
    "SPM", // Saint Pierre and Miquelon
    "SRB", // Serbia
    "SSD", // South Sudan
    "STP", // São Tomé and Príncipe
    "SUR", // Suriname
    "SVK", // Slovakia
    "SVN", // Slovenia
    "SWE", // Sweden
    "SWZ", // Eswatini (Swaziland)
    "SXM", // Sint Maarten
    "SYC", // Seychelles
    "SYR", // Syria

    // T
    "TCA", // Turks and Caicos Islands
    "TCD", // Chad
    "TGO", // Togo
    "THA", // Thailand
    "TJK", // Tajikistan
    "TKL", // Tokelau
    "TKM", // Turkmenistan
    "TLS", // Timor-Leste
    "TON", // Tonga
    "TTO", // Trinidad and Tobago
    "TUN", // Tunisia
    "TUR", // Turkey
    "TUV", // Tuvalu
    "TWN", // Taiwan
    "TZA", // Tanzania

    // U
    "UGA", // Uganda
    "UKR", // Ukraine
    "UMI", // United States Minor Outlying Islands
    "UNA", // Specialized agency of the United Nations (MRZ-specific)
    "UNK", // Resident of Kosovo - UNMIK travel document (MRZ-specific)
    "UNO", // United Nations organization (MRZ-specific)
    "URY", // Uruguay
    "USA", // United States
    "UZB", // Uzbekistan

    // V
    "VAT", // Vatican City
    "VCT", // Saint Vincent and the Grenadines
    "VEN", // Venezuela
    "VGB", // British Virgin Islands
    "VIR", // United States Virgin Islands
    "VNM", // Vietnam
    "VUT", // Vanuatu

    // W
    "WLF", // Wallis and Futuna
    "WSA", // World Service Authority World Passport (limited acceptance)
    "WSM", // Samoa

    // X - International organizations and special statuses
    "XBA", // African Development Bank (MRZ-specific)
    "XCC", // Caribbean Community (MRZ-specific)
    "XCO", // Common Market for Eastern and Southern Africa (MRZ-specific)
    "XCT", // Turkish Republic of Northern Cyprus (limited acceptance)
    "XEC", // Economic Community of West African States (MRZ-specific)
    "XIM", // African Export–Import Bank (MRZ-specific)
    "XOM", // Sovereign Military Order of Malta (MRZ-specific)
    "XPO", // International Criminal Police Organization - INTERPOL (MRZ-specific)
    "XXA", // Stateless person (1954 Convention) (MRZ-specific)
    "XXB", // Refugee (1951 Convention) (MRZ-specific)
    "XXC", // Refugee (other) (MRZ-specific)
    "XXX", // Unspecified nationality (MRZ-specific)

    // Y
    "YEM", // Yemen

    // Z
    "ZAF", // South Africa
    "ZIM", // Zimbabwe (legacy MRZ code - erroneously used in some early Zimbabwean passports)
    "ZMB", // Zambia
    "ZWE"  // Zimbabwe
  ]
}
