//
//  Inject.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

@propertyWrapper
public struct Inject<T> {

    public var wrappedValue: T {
        Resolver.shareInstance.resolve(T.self)
    }

    public init() {}
}
