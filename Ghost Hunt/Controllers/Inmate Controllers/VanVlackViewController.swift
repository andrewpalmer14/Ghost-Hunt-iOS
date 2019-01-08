//
//  VanVlackViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 12/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class VanVlackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.orange
        navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.title = "Inmate VanVlack"
        navigationController?.navigationBar.isHidden = false
        
        
        view.addSubview(timerLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: timerLabel)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: timerLabel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "This is Van Vlacks Page"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : AnyObject]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }

   

}
