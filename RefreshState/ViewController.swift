//
//  ViewController.swift
//  RefreshState
//
//  Created by Павел Попов on 29.02.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer: Timer!
    var refreshIndicator: UIBarButtonItem!
    var items = [String]()
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatioBar()
    }
    
    func setupNavigatioBar(){
        ///SettingReloadButton
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshNow))

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        refreshIndicator = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        toogleIndicator()
    }
    
    deinit {
      timer?.invalidate()
    }
    
    func toogleIndicator() {
        // 5 minutes = 300 seconds //write here 300
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(self.refreshNow)), userInfo: nil, repeats: true)
        
        /*
        self.timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: {[weak self] (tt) in
            self?.getCoinData()
            self?.coinTableView.reloadData()
        })
        timer?.fire()
 */
    }
    
    @objc func refreshNow() {
        
        //here i am creating delay for sample purpose
            //here write your webservice code on completion of webservice change bar button item
            self.navigationItem.rightBarButtonItem = refreshIndicator
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentStr = items[indexPath.row]
        cell.textLabel?.text = currentStr
        return cell
    }

}
