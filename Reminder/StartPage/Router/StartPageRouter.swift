//
//  StartPageRouter.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 20/12/2563 BE.
//

import Foundation
import UIKit

class StartPageRouter : Router, ModalPresenter {
    func dismiss(completion: @escaping ()->Void) {
        context.dismiss(animated: true, completion: nil)
    }
    
    
    
    var context: UIViewController
    func push(to: UIViewController) {
        context.navigationController?.pushViewController(to, animated: true)
    }
    
    func pop() {
        context.navigationController?.popViewController(animated: true)
    }
    
    func present(to: UIViewController) {
        context.present(to, animated: true, completion: nil)
    }
    
    init(_ context: UIViewController) {
        self.context = context
    }
    
    func toReminder(_ viewModel: ReminderVM) {
        let view = ReminderViewController(viewModel: viewModel)
        push(to: view)
    }
    
    func presentAddReminder() {
        present(to: AddReminderNavViewController())
    }
}
