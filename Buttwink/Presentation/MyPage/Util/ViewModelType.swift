//
//  ViewModelType.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/27/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
