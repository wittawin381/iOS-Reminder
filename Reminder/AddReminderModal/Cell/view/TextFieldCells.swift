//
//  AddReminderTableViewCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit

class TextFieldCells: UITableViewCell, CellWithViewModel{
        
    var viewModel: CellViewModel?
    
    let textField : UITextField = UITextField()
    var VStack : UIStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        initTextField()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
//    override func se
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        textField.text = (self.viewModel as! TextFieldCellVM).text
        textField.placeholder = (viewModel as! TextFieldCellVM).hint
    }

    
    func initTextField(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(getText), for: .editingChanged)
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    @objc func getText(sender: UITextField) {
        (self.viewModel as! TextFieldCellVM).text = sender.text ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
