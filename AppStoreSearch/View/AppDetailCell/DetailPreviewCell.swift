//
//  DetailPreviewCell.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/18.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

final class DetailPreviewCell: BaseTableViewCell, View {
  
  // MARK: Constants

  private struct Reusable {
    static let previewCell = ReuseCell<DetailPreviewCollectionCell>()
  }
  
  
  // MARK: UI
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      self.collectionView.register(Reusable.previewCell)
    }
  }
  
  
  //MARK: Property
  
  private let dataSource: RxCollectionViewSectionedReloadDataSource<AppDetailPreviewSection> = {
    return RxCollectionViewSectionedReloadDataSource<AppDetailPreviewSection>(
      configureCell: { (ds, collectionView, index, item) in
        switch item {
        case .image(let reactor):
          let cell = collectionView.dequeue(Reusable.previewCell, for: index)
          cell.reactor = reactor
          return cell
        }
      }
    )
  }()
  
  func bind(reactor: DetailPreviewCellReactor) {
    // State
    reactor.state
      .map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}
