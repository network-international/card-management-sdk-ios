//
// Addresses.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct Addresses: Codable, JSONEncodable, Hashable {

    static let addressTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let addressLine1Rule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let addressLine2Rule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let addressLine3Rule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let addressLine4Rule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let emailRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let phoneRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cityRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let countryRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let zipRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let stateRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    /** PERMANENT/PRESENT/WORK */
    internal var addressType: String
    /** Building one */
    internal var addressLine1: String
    /** LandLord */
    internal var addressLine2: String?
    /** House */
    internal var addressLine3: String?
    /** Busy Street */
    internal var addressLine4: String?
    /** Email Id */
    internal var email: String?
    /** Phone number */
    internal var phone: String?
    /** City name */
    internal var city: String
    /** Country Code Ex SAU */
    internal var country: String
    /** Zip Code */
    internal var zip: String?
    /** State */
    internal var state: String?

    internal init(addressType: String, addressLine1: String, addressLine2: String? = nil, addressLine3: String? = nil, addressLine4: String? = nil, email: String? = nil, phone: String? = nil, city: String, country: String, zip: String? = nil, state: String? = nil) {
        self.addressType = addressType
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.addressLine3 = addressLine3
        self.addressLine4 = addressLine4
        self.email = email
        self.phone = phone
        self.city = city
        self.country = country
        self.zip = zip
        self.state = state
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case addressType = "address_type"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case addressLine3 = "address_line_3"
        case addressLine4 = "address_line_4"
        case email
        case phone
        case city
        case country
        case zip
        case state
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(addressType, forKey: .addressType)
        try container.encode(addressLine1, forKey: .addressLine1)
        try container.encodeIfPresent(addressLine2, forKey: .addressLine2)
        try container.encodeIfPresent(addressLine3, forKey: .addressLine3)
        try container.encodeIfPresent(addressLine4, forKey: .addressLine4)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encodeIfPresent(zip, forKey: .zip)
        try container.encodeIfPresent(state, forKey: .state)
    }
}
