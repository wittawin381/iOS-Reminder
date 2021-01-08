//
//  ReminderRouter.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 20/12/2563 BE.
//

import Foundation
import UIKit

class ReminderRouter : Router, ModalPresenter {
    func dismiss(completion: @escaping ()->Void) {
        context.dismiss(animated: true, completion: completion)
    }
    
    func present(to: UIViewController) {
        context.navigationController?.modalPresentationStyle = .fullScreen
        context.present(to, animated: true, completion: nil)
    }
    
    var context: UIViewController
    
    func push(to: UIViewController) {
        context.navigationController?.pushViewController(to, animated: true)
    }
    
    func pop() {
        context.navigationController?.popViewController(animated: true)
    }
    
    init(_ context: UIViewController) {
        self.context = context
    }
    
    func presentAddReminder(index: Int,onAddPressed: @escaping ()-> Void, onCancelPressed:@escaping ()->Void) {
        let addReminderView = AddReminderNavViewController()
        let viewModel = AddReminderViewModel()
        addReminderView.addReminderViewController.viewModel = viewModel
        addReminderView.addReminderViewController.viewModel?.setInitIndex(index )
        addReminderView.addReminderViewController.viewModel?.onAddPressed = onAddPressed
        addReminderView.addReminderViewController.viewModel?.onCancelPressed = onCancelPressed
        present(to: addReminderView)
    }
    
    func presentAddReminder(index: Int,data: Reminders) {
        let addReminderView = AddReminderNavViewController()
        let viewModel = AddReminderViewModel(data)
        addReminderView.addReminderViewController.viewModel = viewModel
        addReminderView.addReminderViewController.viewModel?.setInitIndex(index)
        addReminderView.addReminderViewController.viewModel?.onAddPressed = {}
        addReminderView.addReminderViewController.viewModel?.onCancelPressed = {}
        present(to: addReminderView)
    }
    
    func presentEditorModal(index: Int,data: Reminders,onDone: @escaping ()->Void = {}, onCancel: @escaping ()->Void = {}) {
        let navigationController = UINavigationController()
        let view = EditorModalView()
        let viewModel = EditorModalVM(data,index: index)
        viewModel.onDone = onDone
        viewModel.onCancel = onCancel
        viewModel.index = index
        view.viewModel = viewModel
        navigationController.viewControllers = [view]
        present(to: navigationController)
    }
    
    
}
