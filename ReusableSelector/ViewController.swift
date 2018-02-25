//
//  ViewController.swift
//  ReusableSelector
//
//  Created by Sarawanak on 2/7/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OptionSelectionHandlerProtocol {

    @IBOutlet weak var textLabel: UILabel!
    var selectionController: OptionSelectionViewController<String>?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showOptions() {
        selectionController = OptionSelectionViewController()
        selectionController?.delegate = self

        //present(selectionController!, animated: true, completion: nil)

        navigationController?.pushViewController(selectionController!, animated: true)
    }

    func selected<T>(_ value: T) where T : Describable {
        textLabel.text = value.description
    }

}

