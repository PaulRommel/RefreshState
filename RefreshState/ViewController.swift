//
//  ViewController.swift
//  RefreshState
//
//  Created by Павел Попов on 29.02.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let userBaseURL = "https://script.google.com/macros/s/AKfycbxpT85ZP_8blkqMvEq0jgMBUKKrwDXnYDYVVaFoV6uot-O-hWIH/exec"
    private var users = [User]()
    
    var timer: Timer!
    var refreshIndicator: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "Cell")
        
        self.setupNavigatioBar()
        self.downloadingJsonWithURL()
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
    }
    
    @objc func refreshNow() {
        //here i am creating delay for sample purpose
            //here write your webservice code on completion of webservice change bar button item
            self.navigationItem.rightBarButtonItem = refreshIndicator
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem
            }
    }
    //-------------
    func downloadingJsonWithURL() {
        guard let url = URL(string: userBaseURL) else {
            return
                    }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print("downloaded")
            
            if let response = response {
                print(response)
                    } else if let error = error {
                print(error)
             return }

            // Parse JSON data
            if let data = data {
                self.users = self.parseJsonData(data: data)

            // Reload table view
            OperationQueue.main.addOperation({
                self.table.reloadData()
                })
            }
        }.resume()
    }

    func parseJsonData(data: Data) -> [User] {

        var users = [User]()

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
            
            let jsonUsers = json as! [AnyObject]
            for jsonUser in jsonUsers {
                var user = User()
                user.id = jsonUser["id"] as! Int
                user.name = jsonUser["name"] as! String
                user.urlImage = jsonUser["url"] as! String
                users.append(user)
            }
        } catch {
            print(error)
    }
        return users
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        // Configure the cell...
        cell.identifierLabel.text = "$\(users[indexPath.row].id)"
        cell.nameLabel.text = users[indexPath.row].name
        
        //cell.imgLabel.image = UIImage(
        if let imageURL = URL(string: users[indexPath.row].urlImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgLabel.image = image
                    }
                }
            }
        }
        return cell
    }
}
