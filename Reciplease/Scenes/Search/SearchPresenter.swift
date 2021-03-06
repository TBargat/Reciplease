//
//  SearchPresenter.swift
//  Reciplease
//
//  Created by Thibault Bargat on 21/03/2019.
//  Copyright (c) 2019 Thibault Bargat. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchPresentationLogic
{
    func presentIngredients(ingredients: [String]?)
}

class SearchPresenter: SearchPresentationLogic
{
    
  weak var viewController: SearchDisplayLogic?
  
  // MARK: Do something
  
  func presentIngredients(ingredients: [String]?)
  {
    var displayedIngredientsString: String = ""
    for ingredient in ingredients ?? [""] {
        if !(ingredient == ""){
        displayedIngredientsString += "- \(ingredient) \n"
        }
    }
    let viewModel = Search.Fetch.ViewModel(displayedIngredients: displayedIngredientsString)
    viewController?.displayIngredients(viewModel: viewModel)
  }
    
    
}

