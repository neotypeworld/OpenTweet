//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    let parser = Parser()
    var tweets = [Tweet]()
    var origin = [Tweet]()
    var selectedRow: Int?
    
    private let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    
        if let data = parser.readLocalFile(forName: "timeline"), let resp
            = parser.parse(jsonData: data) {
            tweets = resp.timeline
           
        }
        setupTableView()
    }
        
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        setUpNavigation()
      
	}
    private func setUpNavigation() {
        navigationItem.title = "Tweets"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        let resetBt = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetAll))
        resetBt.tintColor = .white
        navigationItem.rightBarButtonItem = resetBt

    }
    
    @objc private func resetAll() {
        tweets = origin
        selectedRow = nil
        tableView.reloadData()
    }
    
    private func setupTableView() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
}


