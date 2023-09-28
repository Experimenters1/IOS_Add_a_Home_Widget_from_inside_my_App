//
//  ViewController.swift
//  test1
//
//  Created by Huy Vu on 9/28/23.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {

    @IBOutlet weak var field: UITextField!
    
    
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func button(_ sender: Any) {
        field.resignFirstResponder()
                
                let userDefaults = UserDefaults(suiteName: "group.huy.test1")
                
                guard let text = field.text, !text.isEmpty else {
                    return
                }
                
                userDefaults?.setValue(text, forKey: "text")
                WidgetCenter.shared.reloadAllTimelines()
    }
    
}

