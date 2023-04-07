//
//  NIMobileAPI.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


/// Contains request creators for NI Mobile API.

class NIMobileAPI {
    
    static var shared = NIMobileAPI()
    
    private init() {}
    
    
    func retrieveCardDetails(input: NIInput, completion: @escaping (CardDetailsResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = retrievePublicKey() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let cardParams = CardDetailsParams(publicKey: publicKey)
        let request = Request(.cardDetails(cardParams: cardParams,
                                           identifier: input.cardIdentifierId, type: input.cardIdentifierType,
                                           bankCode: input.bankCode, connection: input.connectionProperties))
        
        request.sendAsync { response, error in
            
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let cardDetails = CardDetailsResponse().parse(json: data) {
                completion(cardDetails, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    func cardLookup(identifier: String, type: String, bankCode: String, _ connectionProperties: NIConnectionProperties, completion: @escaping (CardLookupResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = retrievePublicKey() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        let cardLookupParams = CardLookupParams(cardIdentifierId: identifier, cardIdentifierType: type, publicKey: publicKey)
        let request = Request(.cardsLookup(lookupParams: cardLookupParams, bankCode: bankCode, connection: connectionProperties))
        
        request.sendAsync { response, error in
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let res = CardLookupResponse().parse(json: data) {
                completion(res, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    func retrievePinCertificate(bankCode: String, _ connectionProperties: NIConnectionProperties, completion: @escaping (PinCertificateResponse?, NIErrorResponse?) -> Void) {
        
        let request = Request(.pinCertificate(bankCode: bankCode, connection: connectionProperties))
        request.sendAsync { response, error in
            
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let res = PinCertificateResponse().parse(json: data) {
                completion(res, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    // MARK: - Private Utils
    private func retrievePublicKey() -> String? {
        return RSA.generatePublicKeyx509()
    }
    
    func setPin(_ encryption: PinEncryption, input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedPin = encryption.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(cardIdentifierId: input.cardIdentifierId,
                                  cardIdentifierType: input.cardIdentifierType,
                                  encryptedPin: encryptedPin,
                                  encryptionMethod: encryption.method)
        let request = Request(.setPin(params: params, bankCode: input.bankCode, connection: input.connectionProperties))
        
        request.sendAsync { response, error in
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            completion(response, error)
        }
    }
    
    func verifyPin(_ encryption: PinEncryption, input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedPin = encryption.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(cardIdentifierId: input.cardIdentifierId,
                                  cardIdentifierType: input.cardIdentifierType,
                                  encryptedPin: encryptedPin,
                                  encryptionMethod: encryption.method)
        let request = Request(.verifyPin(params: params, bankCode: input.bankCode, connection: input.connectionProperties))
        
        request.sendAsync { response, error in
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            completion(response, error)
        }
    }
    
    func changePin(_ encryption: (PinEncryption, PinEncryption), input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedOldPin = encryption.0.encryptedPinBlock, let encryptedPin = encryption.1.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = ChangePinParams(cardIdentifierId: input.cardIdentifierId,
                                     cardIdentifierType: input.cardIdentifierType,
                                     encryptedOldPin: encryptedOldPin,
                                     encryptedNewPin: encryptedPin,
                                     encryptionMethod: encryption.0.method)
        let request = Request(.changePin(params: params, bankCode: input.bankCode, connection: input.connectionProperties))
        
        request.sendAsync { response, error in
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            completion(response, error)
        }
    }
}
