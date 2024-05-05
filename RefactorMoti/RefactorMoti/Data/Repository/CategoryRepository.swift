//
//  CategoryRepository.swift
//  RefactorMoti
//
//  Created by 유정주 on 5/4/24.
//

import Foundation

struct CategoryRepository: CategoryRepositoryProtocol {
    
    func fetchCategories() async throws -> [CategoryItem] {
        [
            CategoryItem(id: 0, name: "전체"),
            CategoryItem(id: 1, name: "미설정"),
            CategoryItem(id: 2, name: "음식"),
            CategoryItem(id: 3, name: "운동"),
            CategoryItem(id: 4, name: "개발")
        ]
    }
}