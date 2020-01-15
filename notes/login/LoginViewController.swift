//
//  CustomViewController.swift
//  notes
//
//  Created by Douglas Gelsleichter on 05/11/19.
//  Copyright © 2019 Douglas Gelsleichter. All rights reserved.
//


import UIKit
import PureLayout



class LoginViewController: UIViewController {
    var didSetupConstraints = false

    private var loginContentView: UIView = {
        let view = UIView.newAutoLayout()
        
        return view
    }()
    
    private var line: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .black
        
        return view
    }()
    
    private var line2: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .black
        
        return view
    }()
    
    private let userNameText: UITextField = {
        let textField = UITextField.newAutoLayout()
        textField.placeholder = "Login"
        textField.keyboardType = .emailAddress
        return textField
    } ()
    
    private let passwordText: UITextField = {
        let textField = UITextField.newAutoLayout()
        textField.placeholder = "Senha"
        textField.isSecureTextEntry = true
        return textField
    } ()
    
    private let button: UIButton = {
        let button = UIButton.newAutoLayout()
        button.layer.cornerRadius = 4
        button.backgroundColor = .blue
        
        button.setTitle("Login", for: .normal)
        
        return button
    }()
    
    
    func setupAutoLayout() {
        loginContentView.autoAlignAxis(toSuperviewAxis: .horizontal)
        loginContentView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        loginContentView.autoSetDimension(ALDimension.height, toSize: 200)
        loginContentView.autoMatch(ALDimension.width, to: .width, of: view, withMultiplier: 0.9)
            
        userNameText.autoSetDimension(ALDimension.height, toSize: 30)
        userNameText.autoMatch(ALDimension.width, to: .width, of: loginContentView)
        
        line.autoPinEdge(.top, to: .bottom, of: userNameText)
        line.autoSetDimension(.height, toSize: 1.0)
        line.autoMatch(ALDimension.width, to: .width, of: userNameText)
        
        passwordText.autoPinEdge(.top, to: .bottom, of: line, withOffset: 10.0)
        passwordText.autoSetDimension(ALDimension.height, toSize: 30)
        passwordText.autoMatch(ALDimension.width, to: .width, of: loginContentView)
        
        line2.autoPinEdge(.top, to: .bottom, of: passwordText)
        line2.autoSetDimension(.height, toSize: 1.0)
        line2.autoMatch(ALDimension.width, to: .width, of: passwordText)
        
        
        button.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                               left: 10.0,
                                                               bottom: 10.0, right: 10.0), excludingEdge: .top)
        
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.addSubview(loginContentView)
       
        loginContentView.addSubview(userNameText)
        loginContentView.addSubview(line)
        loginContentView.addSubview(passwordText)
        loginContentView.addSubview(line2)
        loginContentView.addSubview(button)
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        setupAutoLayout()
    }
        
    @objc func login() {
        let username = userNameText.text
        var password = passwordText.text
        password = MD5.encrypt(password ?? "")
        
       LoginInteractor.login(with: username, and: password, completationHandler: { [weak self] (token) in
            if let token = token {
                DispatchQueue.main.async {
                    self?.bind(token)
                }
            }
       })
    }
    
    func bind(_ token:String) {
        AppDelegate.token = token
        print(token)
        navigationController?.pushViewController(ListNotesViewController(), animated: true)
    }
}
