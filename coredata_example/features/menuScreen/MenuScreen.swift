//
//  MenuScreen.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import SwiftUI

struct MenuScreen: View {
    
    @StateObject var viewModel: MenuScreenViewModel
    
    init(
        viewModel: MenuScreenViewModel = MenuScreenViewModel(
            repository:  MenuRepositoryImpl(
                service: MenuApiService()
            )
        )
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                
                Color.pallet.background
                    .edgesIgnoringSafeArea(.all)
                
                content()
                
                ErrorView(error: viewModel.error) {
                    
                }
                
                LoadingView(isLoading: viewModel.isLoading)
            }
            .navigationBarHidden(true)
//            .navigationTitle("Our Menu")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar(content: {
//                CartButton(count: viewModel.cartItems.count) {}
//                    .iconColor(Color.pallet.secondary)
//                    .badgeBackgroundColor(Color.pallet.error)
//                    .badgeForegroundColor(Color.pallet.onError)
//            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        //        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func categoriesBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                    .frame(width: 16)
                ForEach(viewModel.categories) { category in
                    CategoryButton(
                        item: category.name,
                        isActive: viewModel.activeCategory == category.id,
                        animation: animation,
                        tag: "Category_Active_Item"
                    ) {
                        viewModel.setActiveCategory(categoryId: category.id)
                    }
                }
                Spacer()
                    .frame(width: 16)
            }
        }
        .frame(height: 44)
    }
    
    func content() -> some View {
        VStack {
//            Spacer()
//                .frame(height: 16)
//
//            categoriesBar()
            
            HStack {
                
                Text("Our Menu")
                    .font(.title)
                
                Spacer(minLength: 0)
                
                CartButton(count: viewModel.cartItems.count) {}
                    .iconColor(Color.pallet.secondary)
                    .badgeBackgroundColor(Color.pallet.error)
                    .badgeForegroundColor(Color.pallet.onError)
            }
            .frame(height: 56)
            .padding(.horizontal, 16)
            
            subCategoriesBar()
            
            Spacer()
                .frame(height: 16)
            
            HStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VerticalCategoriesBar(categories: viewModel.categories, selectedCategory: viewModel.activeCategory) { category in
                        viewModel.setActiveCategory(categoryId: category.id)
                    }
                }
                
                productsList()
//                    .animation(.none)
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
                .frame(height: 24)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    func subCategoriesBar() -> some View {
        if !viewModel.subCategories.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                        .frame(width: 16)
                    
                    CategoryButton(
                        item: "All",
                        isActive: viewModel.activeSubCategory == nil,
                        animation: animation,
                        tag: "Sub_Category_Active_Item"
                    ) {
                        viewModel.setActiveSubCategory(subCategoryId: nil)
                    }
                    
                    ForEach(viewModel.subCategories) { category in
                        CategoryButton(
                            item: category.name,
                            isActive: viewModel.activeSubCategory == category.id,
                            animation: animation,
                            tag: "Sub_Category_Active_Item"
                        ) {
                            viewModel.setActiveSubCategory(subCategoryId: category.id)
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
            }
            .frame(height: 44)
        }
    }
    
    @ViewBuilder
    func productsList() -> some View {
        if !viewModel.products.isEmpty {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.products) { product in
                        ProductListItem(product: product) {
                            viewModel.incrementProduct(product: product)
                        } onDecrement: {
                            viewModel.decrementProduct(product: product)
                        }

                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
        }
    }
}

struct MenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MenuScreen()
    }
}
