//
//  ViewController.swift
//  test
//
//  Created by Huy Vu on 9/28/23.
//

import WidgetKit
import UIKit

class ViewController: UIViewController {

    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter text"
        field.backgroundColor = .white
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBlue
        view.addSubview(field)
        view.addSubview(button)
        field.becomeFirstResponder()
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        field.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.frame.size.width - 40, height: 52)
        button.frame = CGRect(x: 30, y: view.safeAreaInsets.top + 70, width: view.frame.size.width - 60, height: 50)
    }
    
    @objc private func didTapButton() {
        field.resignFirstResponder()
        
        let userDefaults = UserDefaults(suiteName: "group.huy.test1")
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        userDefaults?.setValue(text, forKey: "text")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
