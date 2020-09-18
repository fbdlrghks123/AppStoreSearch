//
//  Reuse.swift
//  DabangPro
//
//  Created by Ickhwan Ryu on 2020/09/16.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

protocol CellType: class {
  var reuseIdentifier: String? { get }
}

struct ReuseCell<Cell: CellType> {
  typealias Class = Cell

  let `class`: Class.Type = Class.self
  let identifier: String
  let nib: UINib?
  
  private init(identifier: String? = nil, nib: UINib? = nil) {
    self.identifier = nib?.instantiate(withOwner: nil, options: nil).lazy
      .compactMap { ($0 as? CellType)?.reuseIdentifier }
      .first ?? identifier ?? UUID().uuidString
    self.nib = nib
  }
  
  init(identifier: String? = nil) {
    if Bundle.main.path(forResource: String(describing: Cell.self), ofType: "nib") != nil {
      let nib = UINib(nibName: String(describing: Cell.self), bundle: nil)
      self.init(identifier: identifier, nib: nib)
    } else {
      self.init(identifier: identifier, nib: nil)
    }
  }
}

extension UITableViewCell: CellType {
    
}

extension UICollectionViewCell: CellType {
    
}

extension UITableView {
  func register<Cell>(_ cell: ReuseCell<Cell>) {
    if let nib = cell.nib {
      self.register(nib, forCellReuseIdentifier: cell.identifier)
    } else {
      self.register(Cell.self, forCellReuseIdentifier: cell.identifier)
    }
  }
  
  func dequeue<Cell>(_ cell: ReuseCell<Cell>) -> Cell? {
    return self.dequeueReusableCell(withIdentifier: cell.identifier) as? Cell
  }
  
  func dequeue<Cell>(_ cell: ReuseCell<Cell>, for indexPath: IndexPath) -> Cell {
    return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! Cell
  }
}

extension UICollectionView {
  func register<Cell>(_ cell: ReuseCell<Cell>) {
    if let nib = cell.nib {
      self.register(nib, forCellWithReuseIdentifier: cell.identifier)
    } else {
      self.register(Cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
  }
  
  func dequeue<Cell>(_ cell: ReuseCell<Cell>, for indexPath: IndexPath) -> Cell {
    return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! Cell
  }
}
