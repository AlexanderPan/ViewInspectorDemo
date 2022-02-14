//
//  ViewInspectorRxSwiftTests.swift
//  ViewInspectorDemoTests
//
//  Created by AlexanderPan on 2021/5/10.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import ViewInspectorDemo

class ContentRxSwiftViewModelTests: XCTestCase {

    func testSearchSuccess() {

        class FakeAPIManager: APIManager {
            override func getUserByRxSwift(name:String) -> Single<SearchUserResponse> {
                let response = SearchUserResponse.init(items: [
                    .init(id: 9, login: "alex9", avatar_url: URL.init(string: "https://www.google.com.tw")!),
                    .init(id: 8, login: "alex8", avatar_url: URL.init(string: "https://www.google.com.tw")!)
                ])
                return Single.just(response)
            }
        }

        Resolver.shareInstance.add(type: APIManager.self, FakeAPIManager.init())

        let viewModel = ContentRxSwiftViewModel.init()
        let result = viewModel.search(name: "alex").toBlocking().materialize()

        switch result {
        case .completed(let elements):
            let users = elements.first!
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users.first?.id, "text8")
            XCTAssertEqual(users.first?.text, "id:8,login:alex8,avatar_url:https://www.google.com.tw")
            XCTAssertEqual(users.last?.id, "text9")
            XCTAssertEqual(users.last?.text, "id:9,login:alex9,avatar_url:https://www.google.com.tw")
        case .failed(_, _):
            XCTFail()
        }
    }

    func testSearchError() {

        class FakeAPIManager: APIManager {
            override func getUserByRxSwift(name:String) -> Single<SearchUserResponse> {
                return Single.error(FakeError.network)
            }
        }

        Resolver.shareInstance.add(type: APIManager.self, FakeAPIManager.init())

        let viewModel = ContentRxSwiftViewModel.init()

        let result = viewModel.search(name: "alex").toBlocking().materialize()

        switch result {
        case .completed(let elements):
            let users = elements.first!
            XCTAssertEqual(users.count, 0)
        case .failed(_, _):
            XCTFail()
        }

    }

}
