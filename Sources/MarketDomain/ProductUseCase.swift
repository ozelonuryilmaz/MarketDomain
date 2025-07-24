//
//  File.swift
//  MarketDomain
//
//  Created by Onur Yılmaz on 25.07.2025.
//

import Combine
import MarketData

public protocol IProductUseCase {
    func execute(page: Int, limit: Int) -> AnyPublisher<[ProductEntity], NetworkError>
}

public final class ProductUseCase: IProductUseCase {
    private let productRepository: IProductRepository

    public init(productRepository: IProductRepository) {
        self.productRepository = productRepository
    }

    public func execute(page: Int, limit: Int) -> AnyPublisher<[ProductEntity], NetworkError> {
        productRepository.fetchProducts(page: page, limit: limit)
            .map { $0.map { ProductEntity(image: $0.image, name: $0.name) } }
            .eraseToAnyPublisher()
    }
}
