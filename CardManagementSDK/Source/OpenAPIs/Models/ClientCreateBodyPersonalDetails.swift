//
// ClientCreateBodyPersonalDetails.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct ClientCreateBodyPersonalDetails: Codable, JSONEncodable, Hashable {

    static let genderRule = StringRule(minLength: 1, maxLength: 6, pattern: nil)
    static let titleRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let firstNameRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let lastNameRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let middleNameRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let citizenshipRule = StringRule(minLength: 1, maxLength: 3, pattern: nil)
    static let maritalStatusRule = StringRule(minLength: 1, maxLength: 18, pattern: nil)
    static let dateOfBirthRule = StringRule(minLength: 1, maxLength: 15, pattern: nil)
    static let placeOfBirthRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let languageRule = StringRule(minLength: 1, maxLength: 3, pattern: nil)
    static let securityNameRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    /** Gender */
    internal var gender: String?
    /** Title MR etc */
    internal var title: String?
    /** First Name */
    internal var firstName: String
    /** Last Name */
    internal var lastName: String
    /** Middle Name */
    internal var middleName: String?
    /** Citizenship */
    internal var citizenship: String?
    /** Marital status */
    internal var maritalStatus: String?
    /** Birth Date */
    internal var dateOfBirth: String
    /** Birth place */
    internal var placeOfBirth: String?
    /** Language ISO code */
    internal var language: String?
    /** This field is used by Fraud monitoring agents to validate cardholder verification on call This is not mandatory for issuers not using Fraud monitoring service */
    internal var securityName: String?

    internal init(gender: String? = nil, title: String? = nil, firstName: String, lastName: String, middleName: String? = nil, citizenship: String? = nil, maritalStatus: String? = nil, dateOfBirth: String, placeOfBirth: String? = nil, language: String? = nil, securityName: String? = nil) {
        self.gender = gender
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.citizenship = citizenship
        self.maritalStatus = maritalStatus
        self.dateOfBirth = dateOfBirth
        self.placeOfBirth = placeOfBirth
        self.language = language
        self.securityName = securityName
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case gender
        case title
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case citizenship
        case maritalStatus = "marital_status"
        case dateOfBirth = "date_of_birth"
        case placeOfBirth = "place_of_birth"
        case language
        case securityName = "security_name"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(middleName, forKey: .middleName)
        try container.encodeIfPresent(citizenship, forKey: .citizenship)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(placeOfBirth, forKey: .placeOfBirth)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(securityName, forKey: .securityName)
    }
}

