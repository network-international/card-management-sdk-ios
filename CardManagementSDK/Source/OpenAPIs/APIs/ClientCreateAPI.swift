//
// ClientCreateAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class ClientCreateAPI {

    /**
     ClientCreate
     
     - parameter nISrvRequestClientCreate: (body) Sample Description 
     - returns: NISrvResponseClientCreate
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func postCardServicesTransactionV2ClientCreate(nISrvRequestClientCreate: NISrvRequestClientCreate) async throws -> NISrvResponseClientCreate {
        return try await postCardServicesTransactionV2ClientCreateWithRequestBuilder(nISrvRequestClientCreate: nISrvRequestClientCreate).execute().body
    }

    /**
     ClientCreate
     - POST /V2/cardservices/ClientCreate
     - ClientCreate
     - OAuth:
       - type: oauth2
       - name: OAuth2
     - parameter nISrvRequestClientCreate: (body) Sample Description 
     - returns: RequestBuilder<NISrvResponseClientCreate> 
     */
    internal class func postCardServicesTransactionV2ClientCreateWithRequestBuilder(nISrvRequestClientCreate: NISrvRequestClientCreate) -> RequestBuilder<NISrvResponseClientCreate> {
        let localVariablePath = "/V2/cardservices/ClientCreate"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: nISrvRequestClientCreate)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<NISrvResponseClientCreate>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}