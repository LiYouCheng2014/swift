//
//  LoginViewModel.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/21.
//  Copyright © 2018年 Giga. All rights reserved.
//

import Foundation

import RxSwift

fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

class LoginViewModel {
    // 输出
    let usernameValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let everythingValid: Observable<Bool>
    
    // 输入 -> 输出
    init(
        username: Observable<String>,
        password: Observable<String>
        ) {
        
        //用户名是否有效
        usernameValid = username
            .map {
                //用户名 -> 用户名是否有效
                $0.count >= minimalUsernameLength
            }
            .share(replay: 1)
        
        //密码是否有效
        passwordValid = password
            .map {
                //密码 -> 密码是否有效
                $0.count >= minimalPasswordLength
            }
            .share(replay: 1)
        
        //所有输入是否有效
        everythingValid = Observable.combineLatest(usernameValid, passwordValid) {
            //用户名和密码同时有效
            $0 && $1
            }
            .share(replay: 1)
        
    }
}
