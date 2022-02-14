//
//  UserViewObject.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/10.
//

import Foundation

struct UserViewObject: Hashable, Identifiable, Codable {
    var id: String
    let text: String
}
