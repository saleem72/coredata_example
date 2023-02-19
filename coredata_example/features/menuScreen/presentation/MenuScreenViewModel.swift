//
//  MenuScreenViewModel.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import Combine

class MenuScreenViewModel: ObservableObject {
    
    private let repository: MenuRepository
    @Published var categories: [Category] = []
    @Published var subCategories: [SubCategory] = []
    @Published var products: [Product] = []
    @Published var activeCategory: Int? = nil
    @Published var activeSubCategory: Int? = nil
    @Published var error: String? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: MenuRepository) {
        self.repository = repository
        loadSubscriptions()
        getMenu()
    }
    
    func loadSubscriptions() {
        repository.products
            .sink { [weak self] remoteProducts in
                self?.products = remoteProducts
            }
            .store(in: &cancellables)
        
        repository.subCategories
            .sink { [weak self] remoteSubCategories in
                self?.subCategories = remoteSubCategories
            }
            .store(in: &cancellables)
        
        repository.categories
            .sink { [weak self] remoteCategories in
                self?.categories = remoteCategories
            }
            .store(in: &cancellables)
        
        repository.activeCategory
            .sink { [weak self] remoteActiveCategory in
                self?.activeCategory = remoteActiveCategory
            }
            .store(in: &cancellables)
        
        repository.activeSubCategory
            .sink { [weak self] remoteActiveSubCategory in
                self?.activeSubCategory = remoteActiveSubCategory
            }
            .store(in: &cancellables)
    }
    
    func getMenu() {
        isLoading = true
        repository.getMenu { [weak self] response in
            self?.isLoading = false
            switch (response) {
            
            case .success(let menu):
                self?.menuToState(menu: menu)
            case .failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
    
    func menuToState(menu: RestaurantMenu)  {
        categories = menu.categories
        subCategories = menu.subCategories
        products = menu.products
        activeCategory = menu.activeCategory
        activeSubCategory = menu.activeSubCategory
    }
    
    func setActiveCategory(categoryId: Int) {
        guard activeCategory != categoryId else {return}
//        activeCategory = categoryId
        repository.setActiveCategory(categoryId: categoryId)
    }
    
    func setActiveSubCategory(subCategoryId: Int?) {
        guard activeSubCategory != subCategoryId else {return}
//        activeSubCategory = subCategoryId
        repository.setActiveSubCategory(subCategoryId: subCategoryId)
    }
}
