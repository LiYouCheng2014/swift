//
//  LoginViewController.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/21.
//  Copyright © 2018年 Giga. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var doSomethingButton: UIButton!
    
    fileprivate let minimalUsernameLength = 5
    fileprivate let minimalPasswordLength = 5
    
    let disposeBag = DisposeBag()
    
    private var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameValidLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        viewModel = LoginViewModel(
            username: passwordTextField.rx.text.orEmpty.asObservable(),
            password: usernameTextField.rx.text.orEmpty.asObservable()
        )
        
        //用户名是否有效 -> 密码输入框是否可用
        viewModel.usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //用户名是否有效 -> 用户名提示语是否隐藏
        viewModel.usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //密码是否有效 -> 密码s提示语是否隐藏
        viewModel.passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        //所有输入是否有效 -> 绿色按钮是否可点击
        viewModel.everythingValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 点击绿色按钮 -> 弹出提示框
        doSomethingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
                
            })
            .disposed(by: disposeBag)
    }

    
    func showAlert() {
        let alertControl = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
            
        }
        alertControl.addAction(action)
        self.present(alertControl, animated: true, completion: nil)
    }
}
