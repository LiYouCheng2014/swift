//
//  Protocol.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/22.
//  Copyright © 2018年 Giga. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

//例如：网络服务，输入验证服务，弹框服务，数据库，定位，蓝牙...

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}


// GitHub 网络服务
protocol GitHubAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String, password: String) -> Observable<Bool>
}

// 输入验证服务
protocol GitHubValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
