//
//  EmployeeListViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

var cellIndex: IndexPath?
var employeeAge: String?
var employeeSalary: String?
var employeeName: String?

class EmployeeListViewController: UIViewController {
    

    @IBOutlet weak var searchFooter: SearchFooter!
    
    let url = "http://dummy.restapiexample.com/api/v1/employees"
    var detailViewController: DetailViewController? = nil
    var result = [Employee]()
    var filteredResult = [Employee]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        employeeListTableView.dataSource = self
        employeeListTableView.delegate = self
        
        employeeListTableView.tableFooterView = UIView(frame: .zero)
        let nib = UINib.init(nibName: "EmployeeTableViewCell", bundle: nil)
        employeeListTableView.register(nib, forCellReuseIdentifier: "EmployeeTableViewCell")
        callApi()
        setupNavBar()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Employee"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        // Setup the Scope Bar
        //  searchController.searchBar.scopeButtonTitles = ["All"]
        // searchController.searchBar.delegate = self
        
        // Setup the search footer
        employeeListTableView.tableFooterView = searchFooter
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

    }
    
    
    func  callApi(){
        DispatchQueue.global().async {
            
            Connectivity.loadEmployeeData(urlString: self.url) {(employeeList, responseErr) in
                if let err = responseErr {
                    debugPrint(err.localizedDescription)
                }
                else
                {
                    self.result = employeeList as! Array<Employee>
                    DispatchQueue.main.async {
                        self.employeeListTableView.reloadData()
                    }
                }
            }
        }
    }

}


extension EmployeeListViewController : UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
    //    return 1
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredResult.count, of: result.count)
            return filteredResult.count
        }
        
        searchFooter.setNotFiltering()
        return result.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering() {
//            searchFooter.setIsFilteringToShow(filteredItemCount: filteredResult.count, of: result.count)
//            return filteredResult.count
//        }
//
//        searchFooter.setNotFiltering()
//        return result.count
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeListTableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as! EmployeeTableViewCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
       
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        
        let emp: Employee
        if isFiltering() {
            emp = filteredResult[indexPath.section]
        } else {
            emp = result[indexPath.section]
        }
        
        cell.employeeNameLabel.text = result[indexPath.section].employee_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        employeeAge = result[indexPath.section].employee_age
        employeeSalary = result[indexPath.section].employee_salary
        employeeName = result[indexPath.section].employee_name
        cellIndex = indexPath
        //employeeAge = result[indexPath.row].employee_age
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // using animation for displaying cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
    //        cell.nameLabel.backgroundColor = UIColor.green
    //        let storyboard = UIstoryboard(name: "Main", bundle: nil)
    //        controller = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
    //        empID = result[indexPath.row].id
    //        // print(type(of: cellIndex))
    //        self.cellIndex = indexPath
    //        self.empID = self.result[indexPath.row].id
    //        controller!.setEmployeeId(indexId: empID!)
    //        self.navigationController?.pushViewController(controller!, animated: true)
    //    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredResult = result.filter({( employeeObject : Employee) -> Bool in
            let doesCategoryMatch = (scope == "All") || (employeeObject.employee_name == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && employeeObject.employee_name.lowercased().contains(searchText.lowercased())
            }
        })
        employeeListTableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        employeeListTableView.reloadData()
    }
}

//extension EmployeeListVC: UISearchBarDelegate {
//    // MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
//    }
//}

extension EmployeeListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!)//, scope: scope)
    }
}
