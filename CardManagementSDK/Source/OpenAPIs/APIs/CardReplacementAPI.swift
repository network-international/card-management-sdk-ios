//
// CardReplacementAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class CardReplacementAPI {

    /**
     CardReplacement
     
     - parameter nISrvRequestCardReplacement: (body) Sample Description 
     - returns: NISrvResponseCardReplacement
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func postCardServicesTransactionV2CardReplacement(nISrvRequestCardReplacement: NISrvRequestCardReplacement) async throws -> NISrvResponseCardReplacement {
        return try await postCardServicesTransactionV2CardReplacementWithRequestBuilder(nISrvRequestCardReplacement: nISrvRequestCardReplacement).execute().body
    }

    /**
     CardReplacement
     - POST /V2/cardservices/CardReplacement
     - CardReplacement
     - OAuth:
       - type: oauth2
       - name: OAuth2
     - parameter nISrvRequestCardReplacement: (body) Sample Description 
     - returns: RequestBuilder<NISrvResponseCardReplacement> 
     */
    internal class func postCardServicesTransactionV2CardReplacementWithRequestBuilder(nISrvRequestCardReplacement: NISrvRequestCardReplacement) -> RequestBuilder<NISrvResponseCardReplacement> {
        let localVariablePath = "/V2/cardservices/CardReplacement"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: nISrvRequestCardReplacement)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<NISrvResponseCardReplacement>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}