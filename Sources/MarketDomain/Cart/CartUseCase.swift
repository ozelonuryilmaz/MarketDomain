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
    func addToCart(_ item: CartEntity) -> Bool
    func getCartItems() -> [CartEntity]
}

public final class CartUseCase: ICartUseCase {
    private let cartRepository: ICartRepository

    public init(cartRepository: ICartRepository) {
        self.cartRepository = cartRepository
    }

    // TODO: addToCart and getCartItems functions do not follow UseCase best practices. Fixed in App layer, but UseCases need refactoring accordingly.
    public func addToCart(_ item: CartEntity) -> Bool {
        let dto = ProductCartDTO(id: item.id, name: item.name, quantity: item.quantity, price: item.price)
        return cartRepository.saveCartItem(dto)
    }

    // TODO: addToCart and getCartItems functions do not follow UseCase best practices. Fixed in App layer, but UseCases need refactoring accordingly.
    public func getCartItems() -> [CartEntity] {
        return cartRepository.fetchCartItems().map { dto in
            return CartEntity(id: dto.id, name: dto.name, quantity: dto.quantity, price: dto.price)
        }
    }
}
