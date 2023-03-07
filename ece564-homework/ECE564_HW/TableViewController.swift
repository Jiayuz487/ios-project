//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by zjy on 3/17/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, URLSessionDelegate, UISearchResultsUpdating {
    /*
     Alert.
     */
    let downloadAlert = UIAlertController(title: "Data Synchronization", message: "Download data from the server?", preferredStyle: .alert)
    let downloadFinishAlert = UIAlertController(title: "Download Complete", message: "Data has been downloaded from the server.", preferredStyle: .alert)
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchData : [DukePerson] = [DukePerson]()
    
    var isSearchBarEmpty : Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isInSearch : Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    /*
     Filter database on search bar input.
     */
    func filter(_ searchText: String) {
        searchData = DataBase.roster.filter { (person : DukePerson) -> Bool in
            return "\(person.firstName) \(person.lastName) \(person.netid) \(person.team) \(person.hobbies) \(person.languages) \(person.whereFrom) \(person.degree) \(person.gender.rawValue) \(person.role.rawValue)".lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    /*
     Update search result.
     */
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filter(searchBar.text!)
    }
    
    /*
     Download data from server.
     */
    func download(alert: Bool) -> Void {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let loginData = loginString.data(using: String.Encoding.utf8) else { return }
        let base64LoginString = loginData.base64EncodedString()
        let url = URL(string: httpString)
        var req = URLRequest(url: url!)
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "GET"
 
        let sem = DispatchSemaphore.init(value: 0)
        let dataTask = session.dataTask(with: req) {
            loc, resp, err in
            defer { sem.signal() }
            if let loc = loc {
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode([CodableDukePerson].self, from: loc)
                    DataBase.roster = [DukePerson]()
                    for person in decoded {
                        person.addToRoster()
                    }
                    DataBase.saveDataBase()
                    DataBase.start()
                    
                }
                catch {
                    print("Error: ", error)
                }
            }
        }
        dataTask.resume()
        sem.wait()
        if alert {
            self.present(downloadFinishAlert, animated: true, completion: nil)
        }
        else {
            self.refreshControl?.endRefreshing()
        }
        tableView.reloadData()
    }
    
    /*
     Pop up Alert after the view gets loaded.
    */
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    /*
     Pull down for refreshing data.
     */
    @objc private func refresh(_ sender: Any) {
        download(alert: false)
    }
    
    /*
     Preperations before the view gets loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75
        DataBase.start()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Netid, name, hobbies, etc."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        downloadAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.download(alert: true) }))
        downloadAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(downloadAlert, animated: true, completion: nil)
        
        downloadFinishAlert.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
        self.tableView.flashScrollIndicators()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }

    /*
     Section number.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isInSearch ? 1 : DataBase.rosterWithSection.count
    }

    /*
     Number of records under one section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearch ? searchData.count : DataBase.rosterWithSection[section].1.count
    }

    /*
     Cell properties.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let person = isInSearch ? searchData[indexPath.row] : DataBase.rosterWithSection[indexPath.section].1[indexPath.row]

        cell.cellImg.image = person.photo
        cell.cellName.text = "\(person.firstName) \(person.lastName) (\(person.netid))"
        cell.cellDescription.text = person.description

        return cell
    }
    
    /*
     Section name.
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isInSearch ? "" : DataBase.rosterWithSection[section].0
    }
    
    /*
     Click on cell.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = isInSearch ? searchData[indexPath.row] : DataBase.rosterWithSection[indexPath.section].1[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "InformationViewController") as? InformationViewController {
            viewController.person = selectedPerson
            viewController.isEdit = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    /*
     Segue preparation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBtnJump" {
            let controller = segue.destination as! InformationViewController
            controller.isEdit = false
        }
    }
    
    /*
     Add swipe actions.
     */
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (action, view, completionHandler) in
            self.editRecord(indexPath)
            completionHandler(true)
        })
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, completionHandler) in
            self.deleteRecord(indexPath)
            completionHandler(true)
        })
        
        editAction.backgroundColor = UIColor(red: 0.4941, green: 0.8471, blue: 0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 0.8588, green: 0.0275, blue: 0, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    /*
     Delete selected person.
     */
    func deleteRecord(_ indexPath : IndexPath) {
        let selectedPerson = isInSearch ? searchData[indexPath.row] : DataBase.rosterWithSection[indexPath.section].1[indexPath.row]
        
        DataBase.remove(currentPerson: selectedPerson)
        DataBase.saveDataBase()
        DataBase.start()
        tableView.reloadData()
    }
    
    /*
     Edit selected person.
     */
    func editRecord(_ indexPath : IndexPath) {
        let selectedPerson = isInSearch ? searchData[indexPath.row] : DataBase.rosterWithSection[indexPath.section].1[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "InformationViewController") as? InformationViewController {
            viewController.person = selectedPerson
            viewController.isEdit = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
