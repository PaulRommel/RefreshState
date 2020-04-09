//
//  ViewController.swift
//  RefreshState
//
//  Created by Павел Попов on 18.03.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let userBaseURL = "https://script.google.com/macros/s/AKfycbxpT85ZP_8blkqMvEq0jgMBUKKrwDXnYDYVVaFoV6uot-O-hWIH/exec"
    private let ratingURL = "https://script.google.com/macros/s/AKfycbzv2bNOi5wikApDxtSamkiIuOzI1o338Q00Hn1BJLmiJS8mtyNA/exec"
    private var users = [User]()
    
    let activityIndicator = UIActivityIndicatorView()
    let barButtonForActivity = UIBarButtonItem()
    var barButtonSave = UIBarButtonItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        setupNavigatioBar()
        
        activityIndicator(state: true)
        downloadingJsonWithURL() {
            self.activityIndicator(state: false)
        }
    }
    
    func setupNavigatioBar(){
        //Title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Rating"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Baskerville-Bold", size: 20)
        navigationItem.titleView = titleLabel
        ///SettingReloadButton
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        barButtonSave = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadButtonAction))
        navigationItem.rightBarButtonItem = barButtonSave
    }
    
    @objc func reloadButtonAction() {
        activityIndicator(state: true)
        
        downloadingJsonWithURL() {
            self.activityIndicator(state: false)
        }
    }
    
    @objc func getRatingData(completion: @escaping (_ data: Data?) -> Void) {
        guard let url = URL(string: ratingURL) else { return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            print("downloaded Rating")
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            completion(data)
        }.resume()
    }
    
    //-------------
    func downloadingJsonWithURL(completion: @escaping (() -> Void)) {
        guard let url = URL(string: userBaseURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            print("downloaded")
            
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            
            // Parse JSON data
            guard let data = data, let users = try? JSONDecoder().decode([User].self, from: data) else { return }
            
            self.getRatingData { data in
                
                guard let data = data, let ratings = try? JSONDecoder().decode([Rating].self, from: data) else {
                    self.users = users
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        completion()
                    }
                    return
                }
                
                for user in users {
                    for rating in ratings {
                        if user.id == rating.userId {
                            self.users.append(User(id: user.id,
                                                   name: user.name,
                                                   url: user.url,
                                                   rating: rating.rating,
                                                   status: rating.status,
                                                   lastGame: rating.lastGame))
                            continue
                        }
                    }
                }
                

                // Sorting by rating
                self.users.sort { lhs, rhs in
                    switch (lhs.rating, rhs.rating) {
                     case let(l?, r?): return l > r // Both lhs and rhs are not nil
                     case (nil, _): return false    // Lhs is nil
                     case (_?, nil): return true    // Lhs is not nil, rhs is nil
                     }
                }
                
                // Reload table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }
            }
        }.resume()
    }
    //-- [barButtonSave, barButtonForActivity]
    private func activityIndicator(state: Bool) {
        barButtonForActivity.customView = activityIndicator
        activityIndicator.hidesWhenStopped = true
        if state {
            activityIndicator.startAnimating()
            navigationItem.rightBarButtonItems = [barButtonForActivity]
            barButtonSave.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            navigationItem.rightBarButtonItem = barButtonSave
            barButtonSave.isEnabled = true
        }
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        // Configure the cell...
        cell.lblid.text = "\(users[indexPath.row].id)" //ID:
        cell.lblName.text = "\(users[indexPath.row].name!)" //name:
        
        cell.lblrating.text = users[indexPath.row].rating != nil ? " \(users[indexPath.row].rating!)" : "" //rating:
        cell.lmlmessage.text = users[indexPath.row].status
        
        
        if let date = users[indexPath.row].lastGame {
            let timeInterval = TimeInterval(date)
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy"
            
            let strDate = df.string(from: Date(timeIntervalSince1970: timeInterval))
            
            cell.lblnetworkStatus.text = "Date: \(strDate)"
        } else {
            cell.lblnetworkStatus.text = ""
        }
            
        cell.lblimageView.fetchImage (with: users[indexPath.row].url)
        
        return cell
    }
    
}
