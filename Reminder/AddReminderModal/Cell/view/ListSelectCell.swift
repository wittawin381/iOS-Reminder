//
//  PageRouteCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 14/11/2563 BE.
//

import Foundation
import UIKit

class ListSelectCell: UITableViewCell, CellWithViewModel{
    var viewModel: CellViewModel?
    private var trailingText: String?
    private let label: UILabel = UILabel()
    private let hStack = UIStackView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setViewModel() {
        
    }
    
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        self.textLabel?.text = (viewModel as! ListSelectCellVM).title
        self.accessoryType = .disclosureIndicator
    }
    
    
    func setTrailingText(text: String) {
        self.trailingText = text
    }
    
}
