//
//  Data.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import Foundation

extension Data {
    /// Quick "pretty print" for debugging purposes.
    var prettyPrintedJSONString: String {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
            let prettyPrintedString = String(data: data, encoding: .utf8)
        else { return "<Unable to decode JSON>" }

        return prettyPrintedString
    }
}
