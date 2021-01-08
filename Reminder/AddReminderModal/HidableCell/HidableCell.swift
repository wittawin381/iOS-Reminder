//
//  HidableCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 31/12/2563 BE.
//

import Foundation
import Combine



class HidableCell {
    var addRow = CurrentValueSubject<IndexPath?,Never>(nil)
    var deleteRow = CurrentValueSubject<IndexPath?,Never>(nil)
    var list = CurrentValueSubject<[[CellViewModel]],Never>([])
    var previousIndex : IndexPath = IndexPath()
    var cellOpened : Bool = false
    var currentRow : IndexPath? = nil
    
    func show(cell: CellViewModel,by parent: CellViewModel,from items : [[CellViewModel]], onUpdate: @escaping ([[CellViewModel]])->Void) {
        let next = findIndex(of: parent,from: items)
        var items = items
        let parent = parent as! ToggleCellVM
        if currentRow != nil {
            let current = currentRow!
            if next == current {
                items[next.section].remove(at: next.row)
                onUpdate(items)
                deleteRow.send(next)
                currentRow = nil
            }
            else {
                if parent.isEnabled {
                    items[current.section].remove(at: current.row)
                    onUpdate(items)
                    deleteRow.send(current)
                    let index = findIndex(of: parent,from: items)
                    items[index.section].insert(cell, at: index.row)
                    onUpdate(items)
                    addRow.send(index)
                    currentRow = self.findIndex(of: parent, from: items)
                }
                else {
                    items[current.section].remove(at: current.row)
                    onUpdate(items)
                    deleteRow.send(current)
                    currentRow = nil
                }
            }
        }
        else {
            if parent.isEnabled {
                items[next.section].insert(cell, at: next.row)
                onUpdate(items)
                addRow.send(next)
                currentRow = self.findIndex(of: parent,from: items)
            }
        }
        onUpdate(items)
    }
    
    
    func index(of: CellViewModel,from items: [[CellViewModel]]) -> Int? {
        return items[0].firstIndex(where: {$0.type == of.type})
    }
    
    func findIndex(of: CellViewModel, from items: [[CellViewModel]]) -> IndexPath{
        for section in 0..<items.count {
            for row in 0..<items[section].count {
                if items[section][row].type == of.type {
                    return IndexPath(row: row + 1, section: section)
                }
            }
        }
        return IndexPath()
    }}
