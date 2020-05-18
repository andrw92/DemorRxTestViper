//
//  GeneralFunctions.swift
//  DemoTests
//
//  Created by Aldo Martinez on 5/17/20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import OHHTTPStubs

let defaultRequestResponseTime = TimeInterval(0.5)

func defaultStub(urlEndsWith: String, jsonMock: String, statusCode: Int32 = 200, requestTime: TimeInterval = TimeInterval(2.5)) {
    stub(condition: pathEndsWith(urlEndsWith) ) { _ in
        let stubPath = OHPathForFile("\(jsonMock).json", DemoTests.self)
        let response = fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        response.statusCode = statusCode
        response.requestTime = requestTime
        return response
    }
}
