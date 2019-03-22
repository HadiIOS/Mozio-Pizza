//
//  ViewController.swift
//  Mozio Pizza
//
//  Created by Mac on 14/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, MozioPizzaPickerDataSource, MozioPickerDelegate, ViewModelDelegate, OrderViewControllerDelegate {
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var rView: UIView!
    @IBOutlet weak var lView: UIView!
    @IBOutlet weak var rPizzaPicker: MozioPizzaPicker!
    @IBOutlet weak var lPizzaPicker: MozioPizzaPicker!
    @IBOutlet weak var rImageView: UIImageView!
    @IBOutlet weak var lImageView: UIImageView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.lPizzaPicker.mpDataSource = self
        self.rPizzaPicker.mpDataSource = self
        self.lPizzaPicker.mpDelegate = self
        self.rPizzaPicker.mpDelegate = self
        
        self.setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        orderBtn.layer.cornerRadius = orderBtn.frame.height / 2
        lView.backgroundColor = self.viewModel.lPizza.color()
        rView.backgroundColor = self.viewModel.rPizza.color()
        self.lImageView.image = self.viewModel.lPizza.getImage()
        self.rImageView.image = self.viewModel.rPizza.getImage()?.flip
    }


    //MARK: Actions
    @IBAction func orderAction(_ sender: Any) {
        let vc = MozioAlert.getViewController("Order", text: "Are you sure your order is complete?", acceptTitle: "Yes!", cancelTitle: "Cancel", acceptAction: {
            let orders = PizzaManager().getOrders(for: [self.viewModel.rPizza, self.viewModel.lPizza])
            let order = Order(orders)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
            vc.viewModel.order = order
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }, cancelAction: {
            
        })
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    //Mark: Order Delegates
    func orderCompleted(_ orderViewController: OrderViewController) {
        //show success view
        orderViewController.dismiss(animated: true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController")
            vc?.modalPresentationStyle = .overCurrentContext
            self.present(vc!, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5, execute: {
                vc?.dismiss(animated: true, completion: {
                    //reset view 
//                    self.viewModel.reset()
                })
            })
        }
    }
    
    func orderCancelled(_ orderViewController: OrderViewController) {
        
    }

    //Mark: View Model Delegate
    func reloadViews() {
        UIView.animate(withDuration: 0.25) {
            self.lView.backgroundColor = self.viewModel.lPizza.color()
            self.rView.backgroundColor = self.viewModel.rPizza.color()
            self.lImageView.image = self.viewModel.lPizza.getImage()
            self.rImageView.image = self.viewModel.rPizza.getImage()?.flip
        }
    }

    //Mark: Mozio Picker Delegate
    func getSelectedView(_ picker: MozioPizzaPicker, for row: Int) -> UIView? {
        let pizza = self.viewModel.pizzas.at(row) ?? .mozzarella
        let alignment: NSTextAlignment = picker == rPizzaPicker ? .left : .right
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: rPizzaPicker.frame.width, height: 50))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = pizza.toName()
        label.textAlignment = alignment
        return label

    }
    
    func getIdleView(_ picker: MozioPizzaPicker, for row: Int) -> UIView? {
        let pizza = self.viewModel.pizzas.at(row) ?? .mozzarella
        let alignment: NSTextAlignment = picker == rPizzaPicker ? .left : .right
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: rPizzaPicker.frame.width, height: 30))
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.text = pizza.toName()
        label.textAlignment = alignment
        return label
    }
    
    func numberOfPizzas(_ picker: MozioPizzaPicker) -> Int {
        return self.viewModel.pizzas.count
    }
    
    func didSelect(_ picker: MozioPizzaPicker, at row: Int) {
        let dir: ViewModel.PizzaHalf = picker == rPizzaPicker ? .right : .left
        self.viewModel.selectPizza(at: row, direction: dir)
        
    }

    //Mark: ViewModel
    class ViewModel {
        weak var delegate: ViewModelDelegate? {
            didSet {
                self.loadData()
            }
        }
        
        var pizzas: [Pizza] = []
        var lPizza: Pizza = .mozzarella
        var rPizza: Pizza = .mozzarella
        
        init() {
            self.loadData()
        }
        
        func selectPizza(at idx: Int, direction: PizzaHalf) {
            switch direction {
            case .right:
                rPizza = pizzas.at(idx) ?? .mozzarella
            case .left:
                lPizza = pizzas.at(idx) ?? .mozzarella
            }
            
            self.delegate?.reloadViews()
        }
        
        func loadData() {
            PizzaManager().getPizzas { (pizzasX) in
                self.pizzas = pizzasX
                self.delegate?.reloadViews()
            }
        }
        
        enum PizzaHalf {
            case right, left
        }
        
        enum Pizza {
            case mozzarella
            case pepperoni
            case vegaterian
            case superCheese
            
            init(_ name: String) {
                switch name {
                case "Mozzarella":
                    self = .mozzarella
                case "Pepperoni":
                    self = .pepperoni
                case "Vegetarian":
                    self = .vegaterian
                case "Super cheese":
                    self = .superCheese
                default:
                    self = .mozzarella
                }
            }
            
            func toName() -> String {
                switch self {
                case .mozzarella:
                    return "Mozzarella"
                case .pepperoni:
                    return "Pepperoni"
                case .vegaterian:
                    return "Vegetarian"
                case .superCheese:
                    return "Super cheese"
                }
            }
            
            func getImage() -> UIImage? {
                return UIImage(named: self.toName())
            }
            
            //Super cheese: #f6b93b
            //Mozzarella: #fad390
            //Pepparoni: #eb2f06
            //Vegaterian: #b8e994
            func color() -> UIColor {
                switch self {
                case .superCheese:
                    return UIColor(0xf6b93b)
                case .mozzarella:
                    return UIColor(0xfad390)
                case .pepperoni:
                    return UIColor(0xeb2f06)
                case .vegaterian:
                    return UIColor(0xb8e994)
                }
            }
        }
    }
}

protocol ViewModelDelegate: class {
    func reloadViews()
}
