//
//  PickerBLTNItem.swift
//  HiWallet
//
//  Created by apple on 2019/5/31.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import BLTNBoard

class PickerBLTNItem: BLTNPageItem,UIPickerViewDataSource,UIPickerViewDelegate
{

    
    var titleArray:[String] = []
    public var selectIndex = 0
    
    lazy var picker = UIPickerView()

    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        picker.delegate = self
        picker.dataSource = self
        return [picker]
    }
    
//    override func makeFooterViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
//        return nil
//    }
}
extension PickerBLTNItem {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectIndex = row
    }
    
}
