//
//  OrderViewController.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

protocol OrderViewControllerDelegate: class {
    func orderCompleted(_ orderViewController: OrderViewController)
    func orderCancelled(_ orderViewController: OrderViewController)
}

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    weak var delegate: OrderViewControllerDelegate?
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.totalLabel.text = self.viewModel.getTotal
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.order.orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pizza = self.viewModel.order.orders[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.setupCell(pizza)
        return cell
    }
    


    @IBAction func orderAction(_ sender: Any) {
        self.delegate?.orderCompleted(self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.orderCancelled(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    class ViewModel {
        var order: Order = Order([])
        var getTotal: String {
            get {
                return "Total: \(order.total) USD"
            }
        }
        
    }
    
}
