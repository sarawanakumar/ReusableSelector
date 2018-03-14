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
    func selected<T: Describable>(_ value: T)
}

protocol Describable: Equatable, CustomStringConvertible {
    var description: String { get }
}

extension Describable {
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.description == rhs.description
    }
}

protocol Selectable {
    mutating func select(optionAt index: Int) throws
}

enum CError: Error {
    case outOfBounds
}

struct OptionList<T: Describable>: Selectable {
    var options: [T]
    var selectedOption: T?
    var selectedIndex: Int? {
        return options.index {
            $0 == selectedOption
        }
    }

    init(options: [T], selectedOption: T?) {
        self.options = options
        self.selectedOption = selectedOption
    }

    init() {
        self.options = []
    }

    mutating func select(optionAt index: Int) throws {
        guard index < options.endIndex else {
            throw CError.outOfBounds
        }
        selectedOption = options[index]
    }
}

class OptionSelectionViewController<T: Describable>: UITableViewController {

    private var presentationMode = PresentationMode.presented
    private var selected: ((T) -> ())?

    private var selectedIndex: Int? {
        return optionList.selectedIndex
    }

    private var selectedOption: T? {
        return optionList.selectedOption
    }

    var optionList = OptionList<T>()
    weak var delegate: OptionSelectionHandlerProtocol?

    convenience init(data: [T], selectedOption: T?, selected: @escaping (T) -> () = { _ in}) {
        self.init(style: UITableViewStyle.plain)
        self.selected = selected
        self.optionList = OptionList(options: data, selectedOption: selectedOption)
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
        return optionList.options.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex,
            let selectedCell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) {
            selectedCell.accessoryType = .none
        }

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            try? optionList.select(optionAt: indexPath.row)
        }

        delegate?.selected(selectedOption!)
        selected?(selectedOption!)
        removeViewController(presentationMode)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = optionList.options[indexPath.row].description

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
