//
//  String+URL.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/22.
//  Copyright © 2018年 Giga. All rights reserved.
//

import Foundation

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
