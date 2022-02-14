//
//  SearchUserResponse.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

struct User: Hashable, Identifiable, Codable {
    var id: Int64
    var login: String
    var avatar_url: URL
}

struct SearchUserResponse: Codable {
    var items: [User]
}
