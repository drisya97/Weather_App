//
//  Extention.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//

import Foundation
import UIKit

//MARK: String extension
extension String {
    
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    
    //MARK: Convert UNIX Timestamp to date in dd.MM.yyyy format
    
    func getDate() -> String {
        let date = NSDate(timeIntervalSince1970: Double(self) ?? 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let result = dateFormatter.string(from: date as Date)
        return result
    }
}

//MARK: UITableView extension
extension UITableView {
    
    public func registerNib(withName name:String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}

extension UIButton {
    
    func setButtonProperties(title: String,titleColor: UIColor, bgColor: UIColor, cornerRadius: CGFloat, borderColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.setTitleColor(titleColor, for: .normal)
        self.setBorder(color: borderColor)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.5
    }
    
}

extension UILabel {
    
    func setLabel(textColor: UIColor, textAlignment: NSTextAlignment) {
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
    
}

extension UITableViewCell {
    func setTableViewCell(cornerRadius: CGFloat, bgColor: UIColor) {
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = bgColor
    }
}
