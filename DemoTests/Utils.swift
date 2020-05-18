//
//  Utils.swift
//  DemoTests
//
//  Created by Andres Rivas on 17-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation

class TestClass {
    init() {}
}

func bundle() -> Bundle {
    return Bundle(for: TestClass.self)
}

func getData(for file: String) -> [String: Any] {
    let data = readDictionaryJson(fileName: file)
    return data ?? [:]
}

func readDictionaryJson(fileName: String) -> [String: Any]? {
    do {
        if let file = bundle().url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                return object
            }
        }
    } catch {
        print(error.localizedDescription)
    }
    return nil
}
