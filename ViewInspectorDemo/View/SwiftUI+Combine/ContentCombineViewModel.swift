//
//  ContentViewViewModel.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/4.
//

import Foundation
import Combine

class ContentCombineViewModel: ObservableObject {

    @Published var viewObjects:[UserViewObject] = []
    @Published var name = "alex"
    @Inject private var apiManager:APIManager

    private var searchCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        searchCancellable?.cancel()
    }

    func search() {

        #if TEST
        if let viewObjects = UITestUtils.processInfoEnvironmentIsContainFunctionNameThenToArray([UserViewObject].self) {
            self.viewObjects = viewObjects
            return
        }
        #endif
        searchCancellable = apiManager.getUserByCombine(name: name)
            .map({ (users) -> [UserViewObject] in
                return users.items.sorted { (user0, user1) -> Bool in
                    return user0.id < user1.id
                }.map { (user) -> UserViewObject in
                    return .init(id: "text\(user.id)", text: "id:\(user.id),login:\(user.login),avatar_url:\(user.avatar_url)")
                }
            })
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.viewObjects, on: self)
    }

}
