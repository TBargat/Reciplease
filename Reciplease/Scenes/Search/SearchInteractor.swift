//
//  SearchInteractor.swift
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

protocol SearchBusinessLogic
{
    func fetchRecipes(request: Search.Fetch.Request)
    func fetchIngredients()
    var ingredients: [String] { get set }
}

protocol SearchDataStore
{
    var recipes: [Recipe] { get }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore
{
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker? = SearchWorker()
    var recipes = [Recipe]()
    var ingredients = [String]()
    
    // MARK: Do something
    
    func fetchRecipes(request: Search.Fetch.Request)
    {   
        worker?.requestFetchRecipes(ingredients: ingredients, completion: {(response) in
            if let recipes = response.recipesArrayObj {
                self.recipes = recipes
                
            }
        })
        
        //TODO: Remove that after finishing the app
        var recipeNames = [String]()
        for recipe in recipes {
            recipeNames.append(recipe.recipeName ?? "pas de nom")
        }
        print("These are the recipes : \(recipeNames)")
    }
    func fetchIngredients()
    {
         self.presenter?.presentIngredients(ingredients: ingredients)
    }
}