//
//  DetailCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 19/11/2563 BE.
//

import Foundation
import UIKit


class DetailCell: UITableViewCell, CellWithViewModel {
    var viewModel: CellViewModel?
    private var trailingText: String?
    private let label: UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        self.textLabel?.text = (viewModel as! DetailCellVM).title
        self.accessoryType = .disclosureIndicator
    }
    
    func setTrailingText(text: String) {
        self.trailingText = text
    }
}
