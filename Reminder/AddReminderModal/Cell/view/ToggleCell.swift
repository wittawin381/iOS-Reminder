//
//  ToggleCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 19/11/2563 BE.
//

import UIKit
import Combine

class ToggleCell: UITableViewCell, CellWithViewModel{
    var viewModel: CellViewModel?
    private var title = UILabel()
    private var subTitle = UILabel()
    private var hStack = UIStackView()
    private var vStack = UIStackView()
    private var toggle = UISwitch()
    var titleStack = UIStackView()
    var subTitleStack = UIStackView()
    private var subscription = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(hStack)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        self.translatesAutoresizingMaskIntoConstraints = false
        initHStack()
        initVStack()
        initTitle(text: (viewModel as! ToggleCellVM).title )
        initSubTitle(text: (viewModel as! ToggleCellVM).subTitle )
        initSwitch()
        initLabel(isOn: false)
        listenOn()
        subTitleChange()
    }
    
    func initTitle(text:String) {
        self.title.text = text
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initSubTitle(text:String) {
        self.subTitle.text = text
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.font = subTitle.font.withSize(10)
    }
    
    func initHStack() {
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(toggle)
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
        hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 20).isActive = true
        hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -20).isActive = true
        
        hStack.spacing = 10
        hStack.alignment = .center
        
        hStack.isUserInteractionEnabled = true
    }
    
    func initVStack() {
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: hStack.topAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: hStack.bottomAnchor).isActive = true
        vStack.isUserInteractionEnabled = true
        vStack.distribution = .fillProportionally
        
        titleStack.addArrangedSubview(title)
        
        vStack.addArrangedSubview(titleStack)
        
    }
    
    func initSwitch() {
        toggle.addTarget(self, action: #selector(toggleS), for: .valueChanged)
    }
    
    func initLabel(isOn: Bool) {
        switch (isOn) {
        case true:
            setOn()
        case false:
            setOff()
        }
    }
    
    
    func setOn() {
        titleStack.removeArrangedSubview(title)
        title.removeFromSuperview()
        titleStack.addArrangedSubview(title)
        if(self.subTitle.text == ""){
            titleStack.alignment = .center
        }
        else {
            titleStack.alignment = .bottom
        }
        subTitleStack.addArrangedSubview(subTitle)
        subTitleStack.alignment = .top
        vStack.addArrangedSubview(subTitleStack)
        
    }
    
    func setOff() {
        titleStack.alignment = .center
        vStack.removeArrangedSubview(subTitleStack)
        subTitleStack.removeFromSuperview()
    }
    
    @objc func toggleS(sender: UISwitch) {
        (viewModel as! ToggleCellVM).onToggle()
        switch sender.isOn {
        case true:
            setOn()
        case false:
            setOff()
        }
    }
    
    func listenOn() {
        (viewModel as! ToggleCellVM).$isEnabled.sink(receiveValue: {value in
            self.toggle.setOn(value, animated: false)
            if(value) {
                self.setOn()
            }
            else {
                self.setOff()
            }
        }).store(in: &subscription)
    }
    
    
    func subTitleChange() {
        (self.viewModel as! ToggleCellVM).$subTitle.sink(receiveValue: {text in
            self.subTitle.text = text
        }).store(in: &subscription)
    }

}
