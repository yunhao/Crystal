//
//  HomeViewController.swift
//  Crystal-Example
//
//  Created by yunhao on 2020/8/8.
//  Copyright © 2020 yunhao. All rights reserved.
//

import UIKit
import Crystal

class HomeViewController: UIViewController {
    
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var nameView: UIImageView!
    
    @IBOutlet weak var animatedLabel: UILabel!
    
    @IBOutlet weak var animatedSwitch: UISwitch!
    
    @IBOutlet weak var currentThemeLabel: UILabel!
    
    @IBOutlet weak var currentThemeTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var shouldAnimateTheme: Bool { animatedSwitch.isOn }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.cst.apply { v, t in
            v.backgroundColor = t.backgroundColor
        }
        
        navigationController?.navigationBar.cst.apply { v, t in
            v.barTintColor = t.barTintColor
            v.tintColor = t.barButtonItemTintColor
            v.barStyle = t.barStyle
            v.layoutIfNeeded()
        }
        
        nameView.cst.apply { v, t in
            v.tintColor = t.titleColor
        }
        
        animatedLabel.cst.apply { v, t in
            v.textColor = t.labelColor
        }
        
        currentThemeLabel.cst.apply { v, t in
            v.textColor = t.labelColor
        }
        
        currentThemeTextField.cst.apply { v, t in
            v.textColor = t.labelColor
            v.text = t.name.capitalized
        }
        
        animatedSwitch.cst.apply { v, t in
            v.onTintColor = t.switchOnTintColor
        }
        
        descriptionTextView.cst.apply { v, t in
            v.textColor = t.textColor
        }
    }
    
    @IBAction func changeTheme(_ sender: FlatButton) {
        var theme: AppTheme?
        
        switch sender.name {
        case "light": theme = .light
        case "dark": theme = .dark
        case "sea": theme = .sea
        case "forest": theme = .forest
        default: break
        }
        
        if let theme = theme {
            Crystal.shared.setTheme(theme, animated: shouldAnimateTheme)
        }
    }
    
    @IBAction func refreshTheme(_ sender: Any) {
        Crystal.shared.setTheme(.light, animated: true)
    }
}
