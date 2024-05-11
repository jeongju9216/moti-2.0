//
//  HomeViewModel.swift
//  RefactorMoti
//
//  Created by 유정주 on 5/4/24.
//

import Foundation
import Combine

final class HomeViewModel {
    
    // MARK: - Interface
    
    typealias CategoryDataSource = SingleDiffableDataSource<CategoryItem>
    typealias AchievementDataSource = SingleDiffableDataSource<Achievement>
    
    func setUpCategoryDataSource(_ dataSource: CategoryDataSource) {
        self.categoryDataSource = dataSource
    }
    
    func setUpAchievementDataSource(_ dataSource: AchievementDataSource) {
        self.achievementDataSource = dataSource
    }
    
    
    // MARK: - Attribute
    
    private var categoryDataSource: CategoryDataSource?
    private var achievementDataSource: AchievementDataSource?
    
    // MARK: UseCase
    
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private let fetchAchievementsUseCase: FetchAchievementsUseCaseProtocol
    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    
    // MARK: Output
    
    let output = Output()
    private var cancellables: Set<AnyCancellable> = []
    
    private var categories: [CategoryItem] {
        output.categories.value
    }
    
    
    // MARK: - Initializer
    
    init(
        fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol = FetchCategoriesUseCase(),
        fetchAchievementsUseCase: FetchAchievementsUseCaseProtocol = FetchAchievementsUseCase(),
        addCategoryUseCase: AddCategoryUseCaseProtocol = AddCategoryUseCase()
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.fetchAchievementsUseCase = fetchAchievementsUseCase
        self.addCategoryUseCase = addCategoryUseCase
    }
}

// MARK: - Binding Interface

extension HomeViewModel {
    
    func bind(input: Input) {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self else { return }
                viewDidLoad()
            }
            .store(in: &cancellables)
        
        input.addCategory
            .sink { [weak self] categoryName in
                guard let self else { return }
                addCategory(name: categoryName)
            }
            .store(in: &cancellables)
        
        input.selectCategoryCell
            .sink { [weak self] indexPath in
                guard let self else { return }
                selectCategory(at: indexPath)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Binding Action

private extension HomeViewModel {
    
    func viewDidLoad() {
        fetchCategories()
        fetchAllAchievements()
    }
    
    func addCategory(name: String) {
        Task {
            let isSuccess = await addCategoryUseCase.execute(with: name)
            output.isAddedCategorySuccess.send(isSuccess)
        }
    }
    
    func selectCategory(at indexPath: IndexPath) {
        guard indexPath.item < categories.count else {
            return
        }
        
        output.selectedCategoryIndex.send(indexPath)
    }
}


// MARK: - Action Method

private extension HomeViewModel {
    
    func fetchAllAchievements() {
        Task {
            let achievements = (try? await fetchAchievementsUseCase.execute()) ?? []
            output.achievements.send(achievements)
            
            achievementDataSource?.update(data: achievements)
        }
    }
    
    func fetchCategories() {
        Task {
            guard let categories = try? await fetchCategoriesUseCase.execute(),
                !categories.isEmpty else {
                // TODO: 에러 발생
                return
            }
            
            output.categories.send(categories)
            categoryDataSource?.update(data: categories)

            selectCategory(at: IndexPath(item: 0, section: 0))
        }
    }
}

