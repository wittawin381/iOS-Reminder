//
//  ReminderCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 30/12/2563 BE.
//

import Foundation
import UIKit

class ReminderCell : UITableViewCell {
    var checkBox = UIImage(systemName: "circle")
    var title = UITextField()
    var date = UILabel()
    var note = UILabel()
    var url = UILabel()
    var dateText : Date? = nil
    var reminder: Reminders = DatabaseManager.db.createReminder()
    var context:UIViewController = UIViewController()
    var onCancel : ()-> Void = {}
    var onDone : ()-> Void = {}
    var onComplete : ()->Void = {}
    var index : Int = 0
    var checking = UIImageView()
    @Published var complete : Bool = false
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        note.font = UIFont.systemFont(ofSize: 15)
        note.textColor = .gray
        
        title.addTarget(self, action: #selector(insertConfig), for: .editingDidBegin)
        title.addTarget(self, action: #selector(removeConfig), for: .editingDidEnd)
        title.addTarget(self, action: #selector(finishedEdit), for: .editingChanged)
        
        vstack.addToView(view: contentView)
        hstack.addToStack(view: vstack)
        checkbox.addToStack(view: hstack)
        title.addToStack(view: hstack)
        detailstack.addToStack(view: vstack)
        date.addToStack(view: detailstack)
        note.addToStack(view: detailstack)
        
        configButton.addTarget(self, action: #selector(presentConfigFromRow), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(completionTap) )
        checkbox.addGestureRecognizer(tapGesture)
        urlButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func completionTap(sender: UIGestureRecognizer) {
        complete.toggle()
        self.reminder.complete = complete
        DatabaseManager.db.updateData()
        if complete {
            if reminder.date == nil {
                NotificationManager.noti.remove(identifier: reminder.id!.uuidString)
            }
            checkbox.image = UIImage(systemName: "largecircle.fill.circle")
        }
        else {
            if reminder.date != nil {
                NotificationManager.noti.request(from: reminder)
            }
            checkbox.image = UIImage(systemName: "circle")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: onComplete)
    }
    
    @objc func insertConfig() {
        configButton.addToStack(view: hstack)
    }
    
    @objc func removeConfig() {
        hstack.removeArrangedSubview(configButton)
        configButton.removeFromSuperview()
    }
    
    @objc func finishedEdit() {
        self.reminder.title = title.text
        DatabaseManager.db.updateData()
    }
    
    
    @objc func presentConfigFromRow() {
        ReminderRouter(context).presentEditorModal(index: index ,data: reminder,onDone: onDone)
    }
    
    @objc func openURL() {
        var urlText = self.url.text ?? ""
        if !urlText.lowercased().contains("https://") && urlText.lowercased().contains(".com") {
            urlText.insert(contentsOf: "https://", at: urlText.startIndex)
        }
        if let url = URL(string: urlText.lowercased()){
            UIApplication.shared.open(url)
        }
    }
    
    func dateToString(date: Date?,time: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        var datestring = ""
        if date != nil {
            datestring += dateFormatter.string(from: date!)
        }
        if time != nil {
            datestring += " "
            datestring += timeFormatter.string(from: time!)
        }
        return datestring
    }
    
    func date(date: Date?,time: Date?) {
        self.date.text = dateToString(date: date,time: time)
        self.date.font = UIFont.systemFont(ofSize: 15)
        let realDate = parseDate(date: date, time: time)
        if Date().distance(to: realDate!) < 0 {
            self.date.textColor = .red
        }
        else {
            self.date.textColor = .gray
        }
    }
    
    func parseDate(date: Date?, time: Date?) -> Date?{
        let calendar = Calendar.current
        var component = DateComponents()
        if date != nil {
            component.day = calendar.component(.day, from: date!)
            component.month = calendar.component(.month, from: date!)
            component.year = calendar.component(.year, from: date!)
        }
        if time != nil {
            component.hour = calendar.component(.hour, from: time!)
            component.minute = calendar.component(.minute, from: time!)
        }
        return calendar.date(from: component)
    }
    
    var urlButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "safari"), for: .normal)
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        return button
    }()
        
    func initView(reminderData: Reminders) {
        self.reminder = reminderData
        title.text = reminderData.title
        note.text = reminderData.note
        complete = reminderData.complete
        url.text = reminderData.url
        date(date: reminderData.date,time: reminderData.time)
        
        check()
        detailstack.removeArrangedSubview(urlButton)
        urlButton.removeFromSuperview()
        
        if reminderData.url != nil {
            urlButton.setTitle(reminderData.url, for: .normal)
            urlButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
            urlButton.addToStack(view: detailstack)
            
        }
        
        vstack.layout( top: 20, bottom: -20, left: 20, right: -20)
        configButton.size(height: 40, width: 40)
        checkbox.size(height: 40, width: 40)
    }
    
    
    
    
    let vstack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let hstack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let configButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.layout()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let detailstack : UIStackView = {
        let detailStack = UIStackView()
        detailStack.axis = .vertical
        detailStack.alignment = .leading
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        detailStack.isLayoutMarginsRelativeArrangement = true
        detailStack.layoutMargins = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        detailStack.spacing = 5
        return detailStack
    }()
    
    var checkbox : UIImageView = {
        let checkBoxView = UIImageView()
        checkBoxView.image = UIImage(systemName: "circle")
        checkBoxView.isUserInteractionEnabled = true
        return checkBoxView
    }()
    
    func check() {
        if complete {
            let image = UIImage(systemName: "largecircle.fill.circle")
            checkbox.image = image
        }
        else {
            let image = UIImage(systemName: "circle")
            checkbox.image = image
        }
    }

}


extension UIView {
    func layout(top:CGFloat = 0,bottom:CGFloat = 0 , left:CGFloat = 0,right:CGFloat = 0) {
        if superview != nil {
            topAnchor.constraint(equalTo: superview!.topAnchor,constant: top).isActive = true
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor,constant: bottom).isActive = true
            leftAnchor.constraint(equalTo: superview!.leftAnchor,constant: left).isActive = true
            rightAnchor.constraint(equalTo: superview!.rightAnchor,constant: right).isActive = true
        }
    }
    
    func size(height:CGFloat, width:CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
    func addToStack(view: UIStackView) {
        view.addArrangedSubview(self)
    }
}


