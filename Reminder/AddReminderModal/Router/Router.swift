//
//  Router.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 12/12/2563 BE.
//

import Foundation
import UIKit


protocol Router {
    var context : UIViewController { get }
    func push(to:UIViewController)
    func pop()
}

protocol ModalPresenter {
    func present(to: UIViewController)
    func dismiss(completion:@escaping ()->Void)
}



class CellRouter: Router {
    let context: UIViewController
    func push(to: UIViewController) {
        context.navigationController?.pushViewController(to, animated: true)
    }
    
    func toConfigPage(viewModel: DetailsModalVM) {
        let configPage = DetailsModalViewController(viewModel: viewModel)
        self.push(to: configPage)
    }
    
    func toSelecGroupPage(viewModel: ListModalVM) {
        let nextPage = ListModalViewController(viewModel: viewModel)
        self.push(to: nextPage)
    }
    
    func pop() {
        context.navigationController?.popViewController(animated: true)
    }
    
    init(_ context: UIViewController) {
        self.context = context
    }
    
}
