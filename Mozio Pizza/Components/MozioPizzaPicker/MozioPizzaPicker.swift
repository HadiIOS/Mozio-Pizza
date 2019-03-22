//
//  MozioPizzaPicker.swift
//  Mozio Pizza
//
//  Created by Mac on 15/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

protocol MozioPizzaPickerDataSource: class {
    func getSelectedView(_ picker: MozioPizzaPicker, for row: Int) -> UIView?
    func getIdleView(_ picker: MozioPizzaPicker, for row: Int) -> UIView?
    func numberOfPizzas(_ picker: MozioPizzaPicker) -> Int
}

protocol MozioPickerDelegate: class {
    func didSelect(_ picker: MozioPizzaPicker, at row: Int)
}

class MozioPizzaPicker: UIPickerView {
    
    fileprivate var selectedRow: Int = 0
    weak var mpDataSource: MozioPizzaPickerDataSource? {
        didSet {
            self.dataSource = self 
        }
    }
    
    weak var mpDelegate: MozioPickerDelegate? {
        didSet {
            self.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.subviews.count > 2 {
            self.subviews[1].isHidden = true
            self.subviews[2].isHidden = true
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if self.subviews.count > 2 {
            self.subviews[1].isHidden = true
            self.subviews[2].isHidden = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        if self.subviews.count > 2 {
            self.subviews[1].isHidden = true
            self.subviews[2].isHidden = true
        }
    }
}

extension MozioPizzaPicker: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mpDataSource?.numberOfPizzas(self) ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}


extension MozioPizzaPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if selectedRow == row {
            return self.mpDataSource?.getSelectedView(self, for: row) ?? UIView()
        } else {
            return self.mpDataSource?.getIdleView(self, for: row) ?? UIView()
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        self.reloadComponent(0)
        self.mpDelegate?.didSelect(self, at: row)
    }
}
