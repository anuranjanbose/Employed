//
//  Table View.swift
//  Employed
//
//  Created by Anuranjan Bose on 20/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

import UIKit

extension UITableView {
    func deselectSelectedRow(animated: Bool) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}
