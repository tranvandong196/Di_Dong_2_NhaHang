//
//  SimpleTypeExtension.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/19/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
// MARK: *** Interger
//Setup NumberFormatter: Int 1250000 --> to String: 1.250.000
struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(for: self) ?? ""
    }
}


// MARK: *** String
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    func trim(_ characterSetIn: String) -> String {
        let cs = CharacterSet.init(charactersIn: characterSetIn)
        return self.trimmingCharacters(in: cs)
    }
  
}
