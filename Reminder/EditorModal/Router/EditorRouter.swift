//
//  EditorRouter.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 4/1/2564 BE.
//

import Foundation
import UIKit

class EditorRouter : Router {
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
    func toSelecGroupPage(viewModel: ListModalVM) {
//        let viewModel = ListModalVM()
        let nextPage = ListModalViewController(viewModel: viewModel)
        self.push(to: nextPage)
    }
}
