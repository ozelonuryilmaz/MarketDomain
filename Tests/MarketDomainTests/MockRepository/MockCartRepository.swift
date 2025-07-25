import Combine
import MarketData
@testable import MarketDomain

final class MockCartRepository: ICartRepository {
    var savedItems: [ProductCartDTO] = []
    var fetchResult: AnyPublisher<[ProductCartDTO], Error> = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    var saveError: Error?
    
    func saveCartItem(_ item: ProductCartDTO) -> AnyPublisher<Void, Error> {
        if let error = saveError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        savedItems.append(item)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetchCartItems() -> AnyPublisher<[ProductCartDTO], Error> {
        return fetchResult
    }
}
