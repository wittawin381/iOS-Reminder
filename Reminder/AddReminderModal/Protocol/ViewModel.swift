//
//  ViewModel.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 21/11/2563 BE.
//

import Foundation


protocol CellWithViewModel {
    var viewModel: CellViewModel? { get set }
    func initCell(_ viewModel: CellViewModel?)
}
