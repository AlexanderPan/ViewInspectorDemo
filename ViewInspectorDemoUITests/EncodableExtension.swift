//
//  EncodableExtension.swift
//  ViewInspectorDemoUITests
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

extension Encodable {

    func toJsonString() throws -> String? {
        let data = try JSONEncoder().encode(self)
        if let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

}

extension Array where Element: Encodable {

    func toJsonString() throws -> String? {
        let data = try JSONEncoder().encode(self)
        if let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

}
