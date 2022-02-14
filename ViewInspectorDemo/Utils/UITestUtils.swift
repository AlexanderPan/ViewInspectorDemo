//
//  UITestUtils.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

#if TEST

class UITestUtils {

    static func processInfoEnvironmentIsContainFunctionNameThenConvertToDictionary(functionName: String = #function) -> NSMutableDictionary? {
        let modelText: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        if modelText != nil {
            return NSMutableDictionary.init(dictionary: modelText!.convertToDictionary()!)
        }
        return nil
    }

    static func processInfoEnvironmentIsContainFunctionNameThenConvertToModel<T>(_ type: T.Type, functionName: String = #function) -> T? where T: Decodable {
        let modelText: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        if modelText != nil {
            if let toModel = try? JSONDecoder().decode(T.self, from: modelText!.toDictionaryToData()) {
                return toModel
            }
        }
        return nil
    }

    static public func processInfoEnvironmentIsContainFunctionNameThenToArray<T>(_ type: T.Type, functionName: String = #function) -> T? where T: Decodable {
        let arrayText: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        if arrayText != nil {
            if let toArray = try? JSONDecoder().decode(T.self, from: arrayText!.toArrayToData()) {
                return toArray
            }
        }
        return nil
    }

    static func processInfoEnvironmentFunctionEnvironmentValue(functionName: String = #function) -> String? {
        let responseText: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        return responseText
    }

    static func processInfoEnvironmentIsContainFunctionNameThenToBool(functionName: String = #function) -> Bool? {
        let text: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        if let strongText = text {
            return (strongText as NSString).boolValue
        } else {
            return nil
        }
    }

    static func processInfoEnvironmentIsContainFunctionNameThenToInt(functionName: String = #function) -> Int? {
        let text: String? = ProcessInfo.processInfo.environment["\(functionName)"]
        if let strongText = text , let textToInt = Int.init(strongText) {
            return textToInt
        } else {
            return nil
        }
    }

}

// dic -> data -> **string**
// **string** -> dic -> data

extension Array {

    func toDataToString() throws -> String? {

        //        dic -> data -> **string**

        let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)

        return String.init(data: data, encoding: .utf8)

    }

}

extension Dictionary {

    func toDataToString() throws -> String? {

        //        dic -> data -> **string**

        let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)

        return String.init(data: data, encoding: .utf8)

    }

}

extension String {

    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func toDictionaryToData() -> Data {

//        **string** -> dic -> data

        let dictionary: Dictionary = self.convertToDictionary()!

        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)

        return data
    }

    private func convertToArray() -> [Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func toArrayToData() -> Data {

        //        **string** -> dic -> data

        let array: Array = self.convertToArray()!

        let data = try! JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)

        return data
    }

}

#endif
