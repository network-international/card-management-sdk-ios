//
// GetCVV2API.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class GetCVV2API {

    /**
     postGetCVV2
     
     - parameter nISrvRequestGetCVV2: (body) Sample Description 
     - returns: NISrvResponseGetCVV2
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func postCardServicesTransactionV2GetCVV2(nISrvRequestGetCVV2: NISrvRequestGetCVV2) async throws -> NISrvResponseGetCVV2 {
        return try await postCardServicesTransactionV2GetCVV2WithRequestBuilder(nISrvRequestGetCVV2: nISrvRequestGetCVV2).execute().body
    }

    /**
     postGetCVV2
     - POST /V2/cardservices/GetCVV2
     - postGetCVV2
     - OAuth:
       - type: oauth2
       - name: OAuth2
     - parameter nISrvRequestGetCVV2: (body) Sample Description 
     - returns: RequestBuilder<NISrvResponseGetCVV2> 
     */
    internal class func postCardServicesTransactionV2GetCVV2WithRequestBuilder(nISrvRequestGetCVV2: NISrvRequestGetCVV2) -> RequestBuilder<NISrvResponseGetCVV2> {
        let localVariablePath = "/V2/cardservices/GetCVV2"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: nISrvRequestGetCVV2)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<NISrvResponseGetCVV2>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
