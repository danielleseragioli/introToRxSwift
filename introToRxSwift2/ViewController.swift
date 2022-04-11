//
//  ViewController.swift
//  IntroToRxSwift
//
//  Created by DanielleSeragioli on 08/04/22.
//  TABLE VIEW IN Rx Swift
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - model

struct Product {
    let imageName: String
    let title: String
}

// MARK: - view model

struct ProductViewModel{
    
    // 1) collection of items of type PublishSubject wich takes a generic, that will be the collection of our product
    var items = PublishSubject<[Product]>()
    
    // 2) fetch
    func fetchItems(){
        
        
        let products = [
            Product(imageName: "house", title: "Início"),
            Product(imageName: "gear", title: "Configurações"),
            Product(imageName: "person.circle", title: "Perfil"),
            Product(imageName: "bell", title: "Notificações"),
        ]
        
        items.onNext(products)
        items.onCompleted()
        
    }
}

// MARK: - view

class ViewController: UIViewController {
    
    //creating elements -----------------------------
    
    // 1) set up table view
    private let productsTableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    // 2) instance of view Model
    private var viewModel = ProductViewModel()
    
    // 3) instance for DisposeBag
    private var bag = DisposeBag()
    
    
    // View Did Load -----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(productsTableView)
        productsTableView.frame = view.bounds
        bindTableData()
    }

    // bind func -----------------------------

    func bindTableData() {
    // where the Rx Swift magic comes in ✨
        
        // 1) Bind items to table
        viewModel.items.bind(to: productsTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            // here we can actually take the model, and configure our cell with it. This is what you would do traditionally in the cellForRowIndex function
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
            cell.imageView?.tintColor = .systemCyan
            
        }.disposed(by: bag)
        
        
        // 2) Bind a model selected handler
        //get the selected item out of the table view
        productsTableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)

        
        //3) Fetch items via ViewModel
        viewModel.fetchItems()
    }

}

