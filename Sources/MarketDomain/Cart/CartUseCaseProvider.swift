//
//  File.swift
//  MarketDomain
//
//  Created by Onur Yılmaz on 25.07.2025.
//

import Foundation
import MarketData

public enum CartUseCaseProvider {
    
    public static func makeCartUseCase() -> ICartUseCase {
        let localDataSource: ICartLocalDataSource = CartLocalDataSource()
        let cartRepository: ICartRepository = CartRepository(localDataSource: localDataSource)
        return CartUseCase(cartRepository: cartRepository)
    }
}
