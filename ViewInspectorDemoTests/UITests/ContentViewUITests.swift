//
//  ContentViewUITests.swift
//  ViewInspectorDemoTests
//
//  Created by AlexanderPan on 2021/5/10.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import ViewInspectorDemo

extension SearchUserBar: Inspectable {}
extension ContentView: Inspectable {}
extension List: Inspectable {}
extension Text: Inspectable {}

class ContentViewUITests: XCTestCase {

    // MARK: - UITest

    func testSearchUI() throws {

        class FakeContentViewViewModel: ContentCombineViewModel {
            override func search() {
                self.viewObjects = [
                    .init(id: "text8", text: "id:8,login:alex8,avatar_url:https://www.google.com.tw"),
                    .init(id: "text9", text: "id:9,login:alex9,avatar_url:https://www.google.com.tw")
                ]
            }
        }

        let viewModel = FakeContentViewViewModel.init()
        let contentView = ContentView.init(viewModel: viewModel)

        try contentView.inspect().find(SearchUserBar.self).find(button: "Search").tap()

        let vstack =
            try contentView.inspect().scrollView(1).vStack()


        XCTAssertNoThrow(try vstack.forEach(0).text(0))
        XCTAssertEqual(try vstack.forEach(0).text(0).string(), "id:8,login:alex8,avatar_url:https://www.google.com.tw")

        XCTAssertNoThrow(try vstack.forEach(0).text(1))
        XCTAssertEqual(try vstack.forEach(0).text(1).string(), "id:9,login:alex9,avatar_url:https://www.google.com.tw")

        XCTAssertThrowsError(try vstack.forEach(0).text(2))

    }

}
