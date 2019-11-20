//
//  UITableView+DropDown.swift
//  DropDownTableView
//
//  Created by NSSimpleApps on 03.04.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

public enum DropDownIndexPath {
    
    case row(Int)
    case subrow(IndexPath)
    
    public var row: Int? {
        
        switch self {
            
        case .row(let row):
            return row
            
        default:
            return nil
        }
    }
    
    public var subrow: IndexPath? {
        
        switch self {
            
        case .subrow(let indexPath):
            return indexPath
            
        default:
            return nil
        }
    }
}

public extension UITableView {
    
    var dropDownDelegate: DropDownTableViewDelegate? {
        
        get {
            
            return self.delegate as? DropDownTableViewDelegate
        }
        
        set {
            
            self.delegate = newValue as? UITableViewDelegate
        }
    }
    
    var dropDownDataSource: DropDownTableViewDataSource? {
        
        get {
            
            return self.dataSource as? DropDownTableViewDataSource
        }
        
        set {
            
            return self.dataSource = newValue as? UITableViewDataSource
        }
    }
    
    func rectForRow(_ row: Int) -> CGRect {
        
        if let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first {
            
            return self.rectForRow(at: indexPathForRow)
        }
        
        return CGRect.zero
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    func rectForSubrow(at indexPath: IndexPath) -> CGRect {
        
        if let indexPathForSubrow = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [indexPath.subrow], inRow: indexPath.mainrow).first {
            
            return self.rectForRow(at: indexPathForSubrow)
        }
        return CGRect.zero
    }
    
    /// returns Int for row or IndexPath(forSubrow: Int, inMainrow: Int) for subrow
    func dropDownIndexPath(at point: CGPoint) -> DropDownIndexPath? {
        
        if let indexPath = self.indexPathForRow(at: point) {
            
            return self.dropDownDataSource?.valueForIndexPath(indexPath,
                                                              valueForRow: { (row: Int) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.row(row)
            
            }, valueForSubrow: { (subrow, row) -> DropDownIndexPath in
                    
                    return DropDownIndexPath.subrow(IndexPath(forSubrow: subrow, inMainrow: row))
            })
        }
        return nil
    }
    
    /// returns Int for row or IndexPath(forSubrow: Int, inMainrow: Int) for subrow
    func dropDownIndexPath(for cell: UITableViewCell) -> DropDownIndexPath? {
        
        if let indexPath = self.indexPath(for: cell) {
            
            return self.dropDownDataSource?.valueForIndexPath(indexPath,
                                                              valueForRow: { (row: Int) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.row(row)
            },
                                                              valueForSubrow: { (subrow, row) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.subrow(IndexPath(forSubrow: subrow, inMainrow: row))
            })
        }
        return nil
    }
    
    /// returns Int for row or IndexPath(forSubrow: Int, inMainrow: Int) for subrow
    func dropDownIndexPaths(in rect: CGRect) -> [DropDownIndexPath]? {
        
        if let dropDownDataSource = self.dropDownDataSource, let indexPaths = self.indexPathsForRows(in: rect) {
            
            return indexPaths.map({ (indexPath: IndexPath) -> DropDownIndexPath in
                
                dropDownDataSource.valueForIndexPath(indexPath,
                    valueForRow: { (row) -> DropDownIndexPath in
                        
                        return DropDownIndexPath.row(row)
                    },
                    valueForSubrow: { (subrow, row) -> DropDownIndexPath in
                        
                        return DropDownIndexPath.subrow(IndexPath(forSubrow: subrow, inMainrow: row))
                })
            })
        }
        return nil
    }
    
    func cellForRow(at row: Int) -> UITableViewCell? {
        
        if let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first {
            
            return self.cellForRow(at: indexPathForRow)
        }
        return nil
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    func cellForSubrow(at indexPath: IndexPath) -> UITableViewCell? {
        
        if let indexPathForSubrow = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [indexPath.subrow], inRow: indexPath.mainrow).first {
            
            return self.cellForRow(at: indexPathForSubrow)
        }
        return nil
    }
    
    var visibleRows: [Int]? {
        
        return self.indexPathsForVisibleRows?.compactMap({ (indexPath: IndexPath) -> Int? in
            
            self.dropDownDataSource?.valueForIndexPath(indexPath,
                                                       valueForRow: { (row: Int) -> Int in
                                                        
                                                        return row
            },
                                                       valueForSubrow: { (subrow, row) -> Int? in
                                                        
                                                        return nil
            })
        })
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    var indexPathsForVisibleSubrows: [IndexPath]? {
        
        return self.indexPathsForVisibleRows?.compactMap({ (indexPath: IndexPath) -> IndexPath? in
                
            self.dropDownDataSource?.valueForIndexPath(indexPath,
                    valueForRow: { (row: Int) -> IndexPath? in
                        
                        return nil
                        
                    },
                    valueForSubrow: { (subrow, row) -> IndexPath in
                        
                        return IndexPath(forSubrow: subrow, inMainrow: row)
                })
            })
    }
    
    func scrollToRow(at row: Int, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        
        if let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first {
            
            self.scrollToRow(at: indexPathForRow, at: scrollPosition, animated: animated)
        }
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    func scrollToSubrow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        
        if let indexPathForSubrow = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [indexPath.subrow], inRow: indexPath.mainrow).first {
            
            self.scrollToRow(at: indexPathForSubrow, at: scrollPosition, animated: animated)
        }
    }
    
    func insertRows(at rows: [Int], with animation: UITableView.RowAnimation) {
        
        if let indexPathsForRows = self.dropDownDataSource?.tableView(self, indexPathsForRows: rows) {
        
            self.dropDownDataSource?.dropDownInsertRows(rows, in: self)
            
            self.insertRows(at: indexPathsForRows, with: animation)
        }
    }
    
    func insertSubrows(_ subrows: [Int], in row: Int, with animation: UITableView.RowAnimation) {
        
        let indexPaths = subrows.map { (subrow: Int) -> IndexPath in
            
            IndexPath(row: row + subrow + 1, section: 0)
        }
        
        self.insertRows(at: indexPaths, with: animation)
    }
    
    func deleteRows(at rows: [Int], with animation: UITableView.RowAnimation) {
        
        if let indexPathsForRows = self.dropDownDataSource?.tableView(self, indexPathsForRows: rows) {
            
            self.dropDownDataSource?.dropDownDeleteRows(rows, in: self)
            
            self.deleteRows(at: indexPathsForRows, with: animation)
        }
    }
    
    func deleteSubrows(_ subrows: [Int], in row: Int, with animation: UITableView.RowAnimation) {
        
        let indexPaths = subrows.map { (subrow: Int) -> IndexPath in
            
            IndexPath(row: row + subrow + 1, section: 0)
        }
        
        self.deleteRows(at: indexPaths, with: animation)
    }
    
    func reloadRows(at rows: [Int], with animation: UITableView.RowAnimation) {
        
        if let indexPathsForRows = self.dropDownDataSource?.tableView(self, indexPathsForRows: rows) {
            
            self.reloadRows(at: indexPathsForRows, with: animation)
        }
    }
    
    func reloadSubrows(_ subrows: [Int], in row: Int, with animation: UITableView.RowAnimation) {
        
        if let indexPathsForSubrows = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: subrows, inRow: row) {
                
            self.reloadRows(at: indexPathsForSubrows, with: animation)
        }
    }
    
    func moveRow(at row: Int, to newRow: Int) {
        
        if let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first, let indexPathForNewRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [newRow]).first {
            
            self.moveRow(at: indexPathForRow, to: indexPathForNewRow)
        }
    }
    
    func moveSubrow(_ subrow: Int, to newSubrow: Int, in row: Int) {
        
        let indexPathsForSubrows = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [subrow, newSubrow], inRow: row)
        
        if let indexPathForSubrow = indexPathsForSubrows?.first, let indexPathForNewSubrow = indexPathsForSubrows?.last {
            
            self.moveRow(at: indexPathForSubrow, to: indexPathForNewSubrow)
        }
    }
    
    /// returns Int for row or IndexPath(forSubrow: Int, inMainrow: Int) for subrow
    var dropDownIndexPathForSelectedRow: DropDownIndexPath? {
        
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            
            return self.dropDownDataSource?.valueForIndexPath(indexPathForSelectedRow,
                                                              valueForRow: { (row) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.row(row)
            },
                                                              valueForSubrow: { (subrow, row) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.subrow(IndexPath(forSubrow: subrow, inMainrow: row))
            })
        }
        
        return nil
    }
    
    /// returns Int for row or IndexPath(forSubrow: Int, inMainrow: Int) for subrow
    var dropDownIndexPathsForSelectedRows: [DropDownIndexPath]? {
        
        if let dropDownDataSource = self.dropDownDataSource, let indexPathsForSelectedRows = self.indexPathsForSelectedRows {
            
            return indexPathsForSelectedRows.map({ (indexPath: IndexPath) -> DropDownIndexPath in
                
                return dropDownDataSource.valueForIndexPath(indexPath,
                                                            valueForRow: { (row) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.row(row)
                },
                                                            valueForSubrow: { (subrow, row) -> DropDownIndexPath in
                                                                
                                                                return DropDownIndexPath.subrow(IndexPath(forSubrow: subrow, inMainrow: row))
                })
            })
        }
        
        return nil
    }
    
    func select(row: Int?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        
        if let row = row, let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first {
            
            self.selectRow(at: indexPathForRow, animated: animated, scrollPosition: scrollPosition)
        
        } else {
            
            self.selectRow(at: nil, animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    func selectSubrow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        
        if let indexPath = indexPath, let indexPathForSubrow = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [indexPath.subrow], inRow: indexPath.mainrow).first {
                
                self.selectRow(at: indexPathForSubrow, animated: animated, scrollPosition: scrollPosition)
            
        } else {
            
            self.selectRow(at: nil, animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    func deselect(row: Int, animated: Bool) {
        
        if let indexPathForRow = self.dropDownDataSource?.tableView(self, indexPathsForRows: [row]).first {
            
            self.deselectRow(at: indexPathForRow, animated: animated)
        }
    }
    
    // IndexPath(forSubrow: Int, inMainrow: Int)
    func deselectSubrow(at indexPath: IndexPath, animated: Bool) {
        
        if let indexPathForSubrow = self.dropDownDataSource?.tableView(self, indexPathsForSubrows: [indexPath.subrow], inRow: indexPath.mainrow).first {
            
            self.deselectRow(at: indexPathForSubrow, animated: animated)
        }
    }
}
