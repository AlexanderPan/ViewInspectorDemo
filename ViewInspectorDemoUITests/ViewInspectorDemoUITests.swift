//
//  ViewInspectorDemoUITests.swift
//  ViewInspectorDemoUITests
//
//  Created by AlexanderPan on 2021/4/27.
//

import XCTest

class ViewInspectorDemoUITests: XCTestCase {

    private var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        continueAfterFailure = true

    }

    override func tearDownWithError() throws {

    }

    func assertCustomValue(predicate: String, obj: Any, file: StaticString = #file,
                           line: UInt = #line, timeOut: TimeInterval = 10) {

        let exists = NSPredicate(format: predicate)
        let expect = expectation(for: exists, evaluatedWith: obj, handler: nil)
        self.waitForExpectations(timeout: timeOut) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription, file: file, line: line)
            } else {
                expect.fulfill()
            }
        }
    }

    func testSearhUI() throws {

        let viewObjects:[UserViewObject] = [
            .init(id: "text8", text: "id:8,login:alex8,avatar_url:https://www.google.com.tw"),
            .init(id: "text9", text: "id:9,login:alex9,avatar_url:https://www.google.com.tw")
        ]

        
        let app = XCUIApplication()
        app.launchEnvironment["search()"] = try viewObjects.toJsonString()
        app.launchEnvironment["search(name:)"] = try viewObjects.toJsonString()
        app.launch()

        app.buttons["Search"].tap()

        self.assertCustomValue(predicate: "count == 2", obj: app.scrollViews.staticTexts)

        let text8 = app.scrollViews.staticTexts["text8"].firstMatch
        XCTAssertEqual(text8.label, "id:8,login:alex8,avatar_url:https://www.google.com.tw")
        XCTAssertEqual(app.scrollViews.staticTexts.element(boundBy: 0).identifier, text8.identifier)

        let text9 = app.scrollViews.staticTexts["text9"].firstMatch
        XCTAssertEqual(text9.label, "id:9,login:alex9,avatar_url:https://www.google.com.tw")
        XCTAssertEqual(app.scrollViews.staticTexts.element(boundBy: 1).identifier, text9.identifier)

        print(app.debugDescription)
    }

}


