//
//  HomeViewModelInputOutput.swift
//  RefactorMoti
//
//  Created by 유정주 on 5/4/24.
//

import Foundation
import Combine

extension HomeViewModel {
    
    struct Input {
        
        let viewDidLoad: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        
        // MARK: Category
        
        let categories: PassthroughSubject<[String], Never> = .init()
        let currentCategory: PassthroughSubject<String, Never> = .init()
        
        // MARK: Achievement
        
        let achievements: PassthroughSubject<[Achievement], Never> = .init()
    }
}

