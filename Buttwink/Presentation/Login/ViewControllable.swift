//
//  ViewControllable.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/10/25.
//

import UIKit

protocol ViewControllable: UIViewController {}

extension ViewControllable {
    func setStyle() {
        self.view.backgroundColor = .buttwink_green950
    }
}

