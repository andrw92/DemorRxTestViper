//
//  SupportTicket.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation

struct SupportTicket: Codable {
    let id: Int
    let date: Date
    let clientMessage: String
}
