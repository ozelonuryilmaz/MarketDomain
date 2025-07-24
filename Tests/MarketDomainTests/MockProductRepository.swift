import Combine
import MarketData
@testable import MarketDomain

final class MockProductRepository: IProductRepository {
    var result: AnyPublisher<[ProductDTO], NetworkError>!

    func fetchProducts(page: Int, limit: Int) -> AnyPublisher<[ProductDTO], NetworkError> {
        return result
    }
}
