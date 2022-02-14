//
//  ContentRxSwiftViewModel.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/10.
//

import Foundation
import RxSwift

class ContentRxSwiftViewModel {

    var disposeBag: DisposeBag = .init()
    @Inject private var apiManager:APIManager

    func search(name:String?) -> Single<[UserViewObject]> {
        
        #if TEST
        if let viewObjects = UITestUtils.processInfoEnvironmentIsContainFunctionNameThenToArray([UserViewObject].self) {
            return Single<[UserViewObject]>.just(viewObjects)

        }
        #endif

        return apiManager.getUserByRxSwift(name: name ?? "").map { (response) -> [UserViewObject] in
            return response.items.sorted { (user0, user1) -> Bool in
                return user0.id < user1.id
            }.map { (user) -> UserViewObject in
                return .init(id: "text\(user.id)", text: "id:\(user.id),login:\(user.login),avatar_url:\(user.avatar_url)")
            }
        }.catchAndReturn([]).observe(on: MainScheduler.instance)

    }
    
}
