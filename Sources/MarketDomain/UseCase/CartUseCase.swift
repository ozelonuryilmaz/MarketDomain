//
//  File.swift
//  MarketDomain
//
//  Created by Onur Yılmaz on 25.07.2025.
//

import Foundation
import Combine
import MarketData

public protocol ICartUseCase {
    func addToCart(_ item: CartEntity) -> AnyPublisher<Void, Error>
    func getCartItems() -> AnyPublisher<[CartEntity], Error>
}

public final class CartUseCase: ICartUseCase {
    private let cartRepository: ICartRepository

    public init(cartRepository: ICartRepository) {
        self.cartRepository = cartRepository
    }

    public func addToCart(_ item: CartEntity) -> AnyPublisher<Void, Error> {
        let dto = ProductCartDTO(id: item.id, name: item.name, quantity: item.quantity, price: item.price)
        return cartRepository.saveCartItem(dto)
    }

    public func getCartItems() -> AnyPublisher<[CartEntity], Error> {
        return cartRepository.fetchCartItems()
            .map { dtos in
                dtos.map { dto in
                    CartEntity(id: dto.id, name: dto.name, quantity: dto.quantity, price: dto.price)
                }
            }
            .eraseToAnyPublisher()
    }
}
