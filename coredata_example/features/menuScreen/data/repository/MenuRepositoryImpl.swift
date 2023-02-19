//
//  MenuRepositoryImpl.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import Combine
import CoreData

class MenuRepositoryImpl: MenuRepository {
    
    var activeCategory = CurrentValueSubject<Int?, Never>(nil)
    var activeSubCategory = CurrentValueSubject<Int?, Never>(nil)
    
    var products = PassthroughSubject<[Product], Never>()
    var subCategories = PassthroughSubject<[SubCategory], Never>()
    var categories = PassthroughSubject<[Category], Never>()
    
    init(service: MenuService) {
        self.service = service
    }
    
    private let service: MenuService
    private var cancellables = Set<AnyCancellable>()
    private var dbContext = CoreDataManager.shared.context
    
    func getMenu(handler: @escaping (Result<RestaurantMenu, Error>) -> ()) {
        let categories = fetchCategories()
        if !categories.isEmpty {
            let menu = self.readMenuFromDB()
            handler(.success(menu))
            return
        }
        getMenuFromApi { [unowned self] response in
            switch(response) {
            
            case .success(_):
                let menu = self.readMenuFromDB()
                handler(.success(menu))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func getMenuFromApi(handler: @escaping (Result<Bool, Error>) -> ()) {
        service.getMenu()
            .sink { complition in
                if case .failure(let error) = complition {
                    handler(.failure(error))
                }
            } receiveValue: { [unowned self]  remoteList in
                self.extractMenu(remoteCategories: remoteList)
                handler(.success(true))
            }
            .store(in: &cancellables)
    }
    
    private func readMenuFromDB() -> RestaurantMenu {
        let  categories: [Category]  = fetchCategories()
        var  subCategories: [SubCategory]
        var  products: [Product]
        if activeCategory.value == nil {
            activeCategory.send(categories.first?.id)
        }
        subCategories = fetchSubCategories(for: activeCategory.value!)
        products = fetchCategoryProducts(for: activeCategory.value!)
        let menu = RestaurantMenu(
            categories: categories,
            subCategories: subCategories,
            products: products,
            activeCategory: activeCategory.value,
            activeSubCategory: activeSubCategory.value
        )
        return menu
    }
    
    private func extractMenu(remoteCategories: [CategoryDTO]) {
        var subCategories: [SubCategoryDTO] = []
        var products: [ProductDTO] = []
        remoteCategories.forEach { catDto in
            catDto.subCategories?.forEach({ subCatDto in
                subCategories.append(subCatDto)
                if let remoteProducts = subCatDto.products {
                    products.append(contentsOf: remoteProducts)
                }
            })
        }
        updateDatebase(categories: remoteCategories, subCategories: subCategories, products: products)
    }
    
    private func updateDatebase(categories: [CategoryDTO], subCategories: [SubCategoryDTO], products: [ProductDTO]) {
        clearDatabase()
        insertCategoriesList(categories: categories)
        insertSubCategoriesList(subCategories: subCategories)
        insertProductsList(products: products)
    }
    
    private func clearDatabase() {
        activeCategory.send(nil)
        activeSubCategory.send(nil)
        let productsFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: CoreDataManager.Keys.product.rawValue)
        let productsDeleteRequest = NSBatchDeleteRequest(fetchRequest: productsFetchRequest)
        
        let subCategoriesFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: CoreDataManager.Keys.subCategory.rawValue)
        let subCategoriesDeleteRequest = NSBatchDeleteRequest(fetchRequest: subCategoriesFetchRequest)
        
        let categoriesFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: CoreDataManager.Keys.category.rawValue)
        let categoriesDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoriesFetchRequest)

        do {
            try dbContext.execute(productsDeleteRequest)
            try dbContext.execute(subCategoriesDeleteRequest)
            try dbContext.execute(categoriesDeleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func insertProductsList(products: [ProductDTO]) {
        
        for idx in products.indices {
            let productDTO = products[idx]
            let product = ProductEntity(context: dbContext)
            product.id = Int16(productDTO.id ?? 0)
            product.barcode = productDTO.barcode ?? ""
            product.categoryId = Int16(productDTO.categoryId ?? 0)
            product.code = productDTO.code ?? ""
            product.info = productDTO.description ?? ""
            product.discount = Int16(productDTO.discount ?? 0)
            product.expectedTime = productDTO.expectedTime
            product.image = productDTO.image
            product.isAvailable = productDTO.isAvailable == 1 ? true : false
            product.name = productDTO.name ?? ""
            if productDTO.offerId != nil {
                product.offerId = NSNumber(value: productDTO.offerId ?? 0)
            }
            
            product.price = productDTO.price ?? 0
            product.restaurantId = Int16(productDTO.restaurantId ?? 0)
            product.size = productDTO.size ?? ""
            product.sliderImage = productDTO.sliderImage
            product.sort = Int16(productDTO.sort ?? idx)
            product.cartCount = 0
        }
        save()
    }
    
    private func insertSubCategoriesList(subCategories: [SubCategoryDTO]) {
        
        for idx in subCategories.indices {
            let subCategoryDTO = subCategories[idx]
            let subCategory = SubCategoryEntity(context: dbContext)
            subCategory.id = Int16(subCategoryDTO.id ?? 0)
            subCategory.isActive = subCategoryDTO.isActive == 1 ? true : false
            subCategory.name = subCategoryDTO.name ?? ""
            subCategory.parentId = Int16(subCategoryDTO.parentId ?? 0)
            if subCategoryDTO.restaurantId != nil {
                subCategory.restaurantId = Int16(subCategoryDTO.restaurantId ?? 0)
            }
            subCategory.sort = Int16(subCategoryDTO.sort ?? idx) // Int16(idx)
        }
        save()
    }
    
    private func insertCategoriesList(categories: [CategoryDTO]) {
        for idx in categories.indices {
            let categoryDTO = categories[idx]
            let category = CategoryEntity(context: dbContext)
            category.id = Int16(categoryDTO.id ?? 0)
            category.isActive = categoryDTO.isActive == 1 ? true : false
            category.name = categoryDTO.name ?? ""
            if categoryDTO.restaurantId != nil {
                category.restaurantId = Int16(categoryDTO.restaurantId ?? 0)
            }
            category.sort = Int16(categoryDTO.sort ?? idx)
        }
        save()
    }
    
    private func save() {
        do {
            try dbContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchCategoryProducts(for categoryId: Int) -> [Product] {
        do {
            
            let subCategories = fetchSubCategories(for: categoryId)
            let ids = subCategories.map({Int($0.id)})
            
            let productsFetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            productsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ProductEntity.sort, ascending: true)]
            productsFetchRequest.predicate = NSPredicate(format: "categoryId IN %@", ids)
            productsFetchRequest.returnsObjectsAsFaults = false
            
            let dbProducts = try dbContext.fetch(productsFetchRequest)
            let products = dbProducts.map({Product(entity: $0)})
            return products
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func fetchSubCategoryProducts(for subCategoryId: Int) -> [Product] {
        let productsFetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        productsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ProductEntity.sort, ascending: true)]
        productsFetchRequest.predicate = NSPredicate(format: "categoryId == %@", "\(subCategoryId)")
        do {
             let dbProducts = try dbContext.fetch(productsFetchRequest)
            let products = dbProducts.map({Product(entity: $0)})
            return products
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func fetchSubCategories(for categoryId: Int) -> [SubCategory] {
        do {
            let subCategoriesFetchRequest: NSFetchRequest<SubCategoryEntity> = SubCategoryEntity.fetchRequest()
            subCategoriesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \SubCategoryEntity.sort, ascending: true)]
            subCategoriesFetchRequest.predicate = NSPredicate(format: "parentId == %@", "\(categoryId)")
            subCategoriesFetchRequest.returnsObjectsAsFaults = false
            
            let dbSubCategories = try dbContext.fetch(subCategoriesFetchRequest)
            let subCategories = dbSubCategories.map { SubCategory(entity: $0) }
            return subCategories
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func fetchCategories() -> [Category] {
        let categoriesFetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoriesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CategoryEntity.sort, ascending: true)]
        
        do {
             let dbProducts = try dbContext.fetch(categoriesFetchRequest)
            let categories = dbProducts.map({Category(entity: $0)})
            return categories
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func setActiveCategory(categoryId: Int) {
        let subcategories = fetchSubCategories(for: categoryId)
        let products = fetchCategoryProducts(for: categoryId)
        self.activeCategory.send(categoryId)
        self.activeSubCategory.send(nil)
        self.subCategories.send(subcategories)
        self.products.send(products)
    }
    
    func setActiveSubCategory(subCategoryId: Int?) {
        var products: [Product]
        activeSubCategory.send(subCategoryId)
        if subCategoryId == nil {
            products = fetchCategoryProducts(for: activeCategory.value ?? 0)
        } else {
            products = fetchSubCategoryProducts(for: subCategoryId!)
        }
        self.products.send(products)
    }
}


extension Array where Element == Int {
    func toString() -> String {
        let strings = map {String($0) }
        var result = strings.joined(separator: ", ")
        result = "[" + result + "]"
        return result
    }
}
