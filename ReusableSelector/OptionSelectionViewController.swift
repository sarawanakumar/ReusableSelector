//
//  OptionSelectionViewController.swift
//  ReusableSelector
//
//  Created by Sarawanak on 2/7/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

enum PresentationMode {
    case pushed, presented
}

protocol OptionSelectionHandlerProtocol: class {
    func selected(_ value: String)
}

protocol Describable {
    var description: String { get }
}

class OptionSelectionViewController<T: Describable>: UITableViewController {

    private var selectedIndex: Int?
    private var presentationMode = PresentationMode.presented
    private var selected: ((String) -> ())?


    var data = [T]()
    var selectedData: String = "" {
        didSet {
            selectedIndex = data.index {
                return $0.description == selectedData
            }
        }
    }

    weak var delegate: OptionSelectionHandlerProtocol?

    convenience init(data: [T], selected: @escaping (String) -> () = { _ in}) {
        self.init(style: UITableViewStyle.plain)
        self.data = data
        self.selected = selected
    }

    //MARK:- Protected initializers
    private override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    private init() {
        super.init(style: .plain)
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK:- ViewController LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if isBeingPresented {
            presentationMode = .presented
        } else if isMovingToParentViewController {
            presentationMode = .pushed
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex,
            let selectedCell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) {
            selectedCell.accessoryType = .none
        }

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedData = cell.textLabel?.text ?? ""
        }

        delegate?.selected(selectedData)
        selected?(selectedData)
        removeViewController(presentationMode)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = data[indexPath.row].description

        if let selectedIndex = selectedIndex,
            selectedIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func removeViewController(_ mode: PresentationMode) {
        switch mode {
        case .presented:
            dismiss(animated: true, completion: nil)
        case .pushed:
            guard let navController = navigationController else { return }

            navController.popViewController(animated: true)
        }
    }
}

extension String: Describable {
    var description: String {
        return self
    }
}
