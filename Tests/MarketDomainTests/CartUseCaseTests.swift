import XCTest
import Combine
import MarketData
@testable import MarketDomain

final class CartUseCaseTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var sut: ICartUseCase!
    private var repository: MockCartRepository!

    override func setUp() {
        super.setUp()
        cancellables = []
        repository = MockCartRepository()
        sut = CartUseCase(cartRepository: repository)
    }

    override func tearDown() {
        cancellables = nil
        repository = nil
        sut = nil
        super.tearDown()
    }

    func test_addToCart_success_shouldStoreItem() {
        // GIVEN
        let item = CartEntity(id: "1", name: "Apple", quantity: 3, price: "5.0")

        let expectation = expectation(description: "addToCart should succeed")

        // WHEN
        sut.addToCart(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Unexpected failure")
                }
            }, receiveValue: {
                // THEN
                XCTAssertEqual(self.repository.savedItems.count, 1)
                XCTAssertEqual(self.repository.savedItems[0].name, "Apple")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }

    func test_getCartItems_shouldReturnMappedEntities() {
        // GIVEN
        let dtos = [
            ProductCartDTO(id: "1", name: "Milk", quantity: 1, price: "10.0"),
            ProductCartDTO(id: "2", name: "Bread", quantity: 2, price: "4.5")
        ]
        repository.fetchResult = Just(dtos)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let expectation = expectation(description: "getCartItems should return items")

        // WHEN
        sut.getCartItems()
            .sink(receiveCompletion: { _ in }, receiveValue: { entities in
                // THEN
                XCTAssertEqual(entities.count, 2)
                XCTAssertEqual(entities[0].name, "Milk")
                XCTAssertEqual(entities[1].price, "4.5")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }

    func test_addToCart_shouldReturnError_whenSaveFails() {
        // GIVEN
        repository.saveError = NSError(domain: "Test", code: 999, userInfo: nil)
        let item = CartEntity(id: "3", name: "Egg", quantity: 6, price: "2.5")
        let expectation = expectation(description: "addToCart should fail")

        // WHEN
        sut.addToCart(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                }
            }, receiveValue: {
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
}
