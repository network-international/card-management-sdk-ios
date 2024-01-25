//
//  EncryptionTests.swift
//  CardManagementSDKTests
//
//  Created by Aleksei Kiselev on 04.01.2024.
//

import XCTest
@testable import NICardManagementSDK

final class EncryptionTests: XCTestCase {

    var rsaKey: RSAKeyx509!
    
    override func setUpWithError() throws {
        rsaKey = try RSA.generateRSAKeyx509(tag: "test".data(using: .utf8)!, isPermanent: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func disable_testExample() throws {
        // Arrange
        let algorithm: SecKeyAlgorithm = GlobalConfig.NIRSAAlgorithm
        let cardNumber = "5291358274538650"
        let cardEncData = try RSAUtils.encrypt(string: cardNumber, certificate: rsaKey.cert)
        
        // Act
        let hexString = try XCTUnwrap(cardEncData)
        let decrCard = try RSAUtils.decrypt(cipherText: hexString.hexaData, privateKey: rsaKey.privateKey, algorithm: algorithm)
            
        
        // Assert
        XCTAssertEqual(cardNumber, decrCard)
        //RSAUtils.extract()

        let testCardId = /* "5291358274538650" */ "c4d3bd18bdef40e7310c0cc3505c42ed28666c7efe1254786a002294c2934a4a8b244c9ce9cc6c615de07e6b320bb638760812bfede5d5b96af2f751337c97f1055d47ff034fbef3a22a8308e279c61256c8cb0542c67245c9f8a201fed078a8552fe9730108a310be057bda793e83d482f7ca208294afedd3348449230045f2594b1d77a8e624681c84668347cdfd622244717e594e375bb1348c56276681018626d0f2f217f05409f3e3223d29600912bab958eb65a0a3b87d9ba0c2b2fb9bd25c27507810915ec1c066f69e38e7be13c1b4811a22c6a5f5510630589413b3120912fcdfd635b5dbc1f1c64a7701a7cb9bc2523dcfc51364faa02bdd51387b584e99aecb1abfbe37713639995591aa69a00fcfd3746c0c05c95153fea3cd3a8f8a4b553225fa817166bbc618f2a45dd0aeb3daef87f3192c9ddc92cdee621d5ea9b519b2f06ea34a32e402a26fbdfbd4af59de8a4855a67b8e65a0b2bdd6c6080a20c7c8cfdb9b9b3ab87f9e69243f90d9608c80ea4595baa869e9bd929f5f24ded5a9a54598b0438bd373acef82b31ed6e42bc6a2ba197c84898a19f3d264688bac59051aaa120d9a78f0d994f9ed818d4e0dac5ea788aa3197f3188a569c085a303c522c0f1ba3cfc4406b31cc0cc18b1bb8b18c16e2462ffa50e2c5220d6e1b91e182546d7fa19a4455f061ba5c9bcba8297cb24057fb4c92f92450a6fe"
        let testCardIdData = testCardId.hexaData
        // try to encrypt on my side
        
        // try to decrypt
        let cardEncrBase64 = "VPRGf3Sq3wN24oqbx1anh1VpTG/F1HEocd6nsaKC0nyRYXzPAjg5U/HPD0X+c+zzoA2kz+PP3xY8AJ/AV9Ya4uCbl1Sbtui5wbjNQ8eQNvdFclCxhN41e5ymtYIRslGuIa1N5e3xzx1uwPR6DeQozgHWTueXpMIb49t+9S9JXdn5CMwjudrKqovlCtOpBDDHHWMRUJqJIyqimUsG3CpPa3UIQoHqKcwvh9kWpvpLh9pucqZvNq/UzB6TbRDuHh2pxfCAoavMbTesMF+VmGwMCA4hpvsqIys7p01PM6iD/sFXGbU4pwLQLBVIuc4BDOY43GkxrglEhVnWuDxg4WbMMrXl77yFEyd1V8UesjDMZKkZn40Pv6oRVchYzjT3Bf1Ytr/HPsPov5OQL9eywJGlapsFLVDQVK4c3RQBuceeDFuCecwTYhIOEm8zySjNa6bKylS9/4g6GzpjLWN90myGoOD+E33TNarJWs+yKif9hf000qkdjnRX32kiAZuyYpit+TaV5zuJ/kfpIAjt0Cfq8gogE+IOQ7779drG7MHHbOo5+3VNLn/LDPMPtGDH82TRvwB8D3uQtrh/AZ0nEnDMQD9Ewd+bNh3biA26qRp1QNDVLvZg4fhN7ucGBuGXcHdTXJjVz2GA5Pr7EU/JpwLlafAB+4IEUBa3yO/hSt9BX7Y="
        let cardEncrdata = cardEncrBase64.hexaData
    }
}
