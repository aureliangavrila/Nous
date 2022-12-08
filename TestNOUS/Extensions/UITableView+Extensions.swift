//
//  UITableView+Extensions.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 08.12.2022.
//

import Foundation
import RxSwift
import RxDataSources

protocol TableViewCellModelType {
    var identifier: String { get }
}

protocol TableViewCellType {
    func update(with model: TableViewCellModelType)
}

typealias TableViewSectionModelType = SectionModel<String, TableViewCellModelType>
extension TableViewSectionModelType {
    static func withItems(_ items: [TableViewCellModelType]) -> TableViewSectionModelType{
        TableViewSectionModelType(model: "", items: items)
    }
}

extension UITableView {
    func buildDataSource(nibCellIdentifiers: [String] = []) -> RxTableViewSectionedReloadDataSource<TableViewSectionModelType> {
        nibCellIdentifiers.forEach { identifier in
            register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
        
        return RxTableViewSectionedReloadDataSource<TableViewSectionModelType> { _, tableView, indexPath, cellModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath)
            (cell as? TableViewCellType)?.update(with: cellModel)
            return cell
        }
    }
}
