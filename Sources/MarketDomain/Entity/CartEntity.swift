//
//  File.swift
//  MarketDomain
//
//  Created by Onur Yılmaz on 25.07.2025.
//

import Foundation

public struct CartEntity: Equatable {
    public let id: String
    public let name: String
    public let quantity: Int
    public let price: String

    public init(id: String, name: String, quantity: Int, price: String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
