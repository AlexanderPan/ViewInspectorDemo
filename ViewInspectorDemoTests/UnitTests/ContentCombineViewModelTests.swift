//
//  ViewInspectorDemoTests.swift
//  ViewInspectorDemoTests
//
//  Created by AlexanderPan on 2021/4/27.
//

import XCTest
import Combine

@testable import ViewInspectorDemo

enum FakeError:Error {
    case network
}

class ContentCombineViewModelTests: XCTestCase {

    var expectation: XCTestExpectation?
    var cancellable: Cancellable?

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.expectation = nil
        self.cancellable?.cancel()
    }

    func testSearchSuccess() {

        class FakeAPIManager: APIManager {
            override func getUserByCombine(name: String) -> AnyPublisher<SearchUserResponse, Error> {
                return Result.Publisher.init(SearchUserResponse.init(items: [
                    .init(id: 9, login: "alex9", avatar_url: URL.init(string: "https://www.google.com.tw")!),
                    .init(id: 8, login: "alex8", avatar_url: URL.init(string: "https://www.google.com.tw")!)
                ])).eraseToAnyPublisher()
            }
        }

        Resolver.shareInstance.add(type: APIManager.self, FakeAPIManager.init())

        self.expectation = self.expectation(description: "wait for api")
        let viewModel = ContentCombineViewModel.init()
        self.cancellable = viewModel.$viewObjects.dropFirst().sink { (users) in
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users.first?.id, "text8")
            XCTAssertEqual(users.first?.text, "id:8,login:alex8,avatar_url:https://www.google.com.tw")
            XCTAssertEqual(users.last?.id, "text9")
            XCTAssertEqual(users.last?.text, "id:9,login:alex9,avatar_url:https://www.google.com.tw")
            self.expectation?.fulfill()
        }
        viewModel.search()
        self.waitForExpectations(timeout: 5, handler: nil)

    }

    func testSearchError() {

        class FakeAPIManager: APIManager {
            override func getUserByCombine(name: String) -> AnyPublisher<SearchUserResponse, Error> {
                return Result<SearchUserResponse, Error>.Publisher.init(.failure(FakeError.network)).eraseToAnyPublisher()
            }
        }

        Resolver.shareInstance.add(type: APIManager.self, FakeAPIManager.init())

        self.expectation = self.expectation(description: "wait for api")
        let viewModel = ContentCombineViewModel.init()
        self.cancellable = viewModel.$viewObjects.dropFirst().sink { (users) in
            XCTAssertEqual(users.count, 0)
            self.expectation?.fulfill()
        }
        viewModel.search()
        self.waitForExpectations(timeout: 5, handler: nil)

    }

}
