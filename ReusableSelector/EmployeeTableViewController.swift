//
//  EmployeeTableViewController.swift
//  ReusableSelector
//
//  Created by Sarawanak on 2/7/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UITableViewController, OptionSelectionHandlerProtocol {
    var selectionViewController: OptionSelectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        switch (indexPath.section, indexPath.row) {
        case (0,2):
            let bloodGroupData = ["A+", "B+", "O+", "AB+", "AB-", "O-", "B-", "A-"]
            selectionViewController = OptionSelectionViewController(data: bloodGroupData)
            selectionViewController?.delegate = self
            selectionViewController?.selectedData = cell.textLabel?.text ?? ""
            selectionViewController?.title = "Blood Group"
            navigationController?.pushViewController(selectionViewController!, animated: true)

        case (1,0):
            let companyNames = ["Google", "Oracle", "IBM", "Microsoft", "Apple", "Adobe"]
            selectionViewController = OptionSelectionViewController(data: companyNames) { (selectedValue) in
                cell.textLabel?.text = selectedValue
            }
            selectionViewController?.selectedData = cell.textLabel?.text ?? ""
            selectionViewController?.title = "Company"
            navigationController?.pushViewController(selectionViewController!, animated: true)


        default:
            ()
        }
    }

    @IBAction func viewTouched(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func selected(_ value: String) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) {
            cell.textLabel?.text = value
        }
    }
}
