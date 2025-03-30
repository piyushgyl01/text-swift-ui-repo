//
//  WorkoutTimer.swift
//  hws
//
//  Created by piyush ehe on 17/03/25.
//
import SwiftUI

struct Recipe {
    var name: String
    var category: String
    var servings: Int
    var ingredients: [Ingredient]
}

struct Ingredient {
    var name: String
    var amount: Double
    var unit: String
}

struct RecipeScaling: View {
    let categories = ["Breakfast", "Main Dish", "Side Dish", "Dessert"]

    let recipes: [String: [Recipe]] = [
        "Breakfast": [
            Recipe(name: "Pancakes", category: "Breakfast", servings: 4, ingredients: [
                Ingredient(name: "Flour", amount: 2, unit: "cups"),
                Ingredient(name: "Milk", amount: 1.5, unit: "cups"),
                Ingredient(name: "Eggs", amount: 2, unit: ""),
                Ingredient(name: "Sugar", amount: 2, unit: "tbsp"),
                Ingredient(name: "Baking Powder", amount: 1, unit: "tbsp")
            ]),
            Recipe(name: "Omelette", category: "Breakfast", servings: 2, ingredients: [
                Ingredient(name: "Eggs", amount: 4, unit: ""),
                Ingredient(name: "Milk", amount: 0.25, unit: "cup"),
                Ingredient(name: "Cheese", amount: 0.5, unit: "cup"),
                Ingredient(name: "Salt", amount: 0.5, unit: "tsp")
            ])
        ],
        "Main Dish": [
            Recipe(name: "Spaghetti", category: "Main Dish", servings: 4, ingredients: [
                Ingredient(name: "Pasta", amount: 1, unit: "pound"),
                Ingredient(name: "Ground Beef", amount: 1, unit: "pound"),
                Ingredient(name: "Tomato Sauce", amount: 2, unit: "cups"),
                Ingredient(name: "Onion", amount: 1, unit: ""),
                Ingredient(name: "Garlic", amount: 2, unit: "cloves")
            ]),
            Recipe(name: "Roast Chicken", category: "Main Dish", servings: 6, ingredients: [
                Ingredient(name: "Chicken", amount: 4, unit: "pounds"),
                Ingredient(name: "Butter", amount: 0.25, unit: "cup"),
                Ingredient(name: "Herbs", amount: 2, unit: "tbsp"),
                Ingredient(name: "Salt", amount: 1, unit: "tbsp"),
                Ingredient(name: "Pepper", amount: 1, unit: "tsp")
            ])
        ],
        "Side Dish": [
            Recipe(name: "Mashed Potatoes", category: "Side Dish", servings: 4, ingredients: [
                Ingredient(name: "Potatoes", amount: 2, unit: "pounds"),
                Ingredient(name: "Butter", amount: 0.25, unit: "cup"),
                Ingredient(name: "Milk", amount: 0.5, unit: "cup"),
                Ingredient(name: "Salt", amount: 1, unit: "tsp")
            ])
        ],
        "Dessert": [
            Recipe(name: "Chocolate Cake", category: "Dessert", servings: 8, ingredients: [
                Ingredient(name: "Flour", amount: 2, unit: "cups"),
                Ingredient(name: "Sugar", amount: 1.5, unit: "cups"),
                Ingredient(name: "Cocoa Powder", amount: 0.75, unit: "cup"),
                Ingredient(name: "Eggs", amount: 3, unit: ""),
                Ingredient(name: "Butter", amount: 0.5, unit: "cup"),
                Ingredient(name: "Milk", amount: 1, unit: "cup")
            ])
        ]
    ]
    
    @State private var selectedCategory = "Breakfast"
    @State private var selectedRecipe = "Pancakes"
    @State private var originalServings = ""
    @State private var desiredServings = ""
    @State private var showingRecipeList = false

    private var currentRecipe: Recipe? {
            if let recipes = recipes[selectedCategory] {
                return recipes.first { $0.name == selectedRecipe }
            }
            return nil
        }
        
        private var recipeNames: [String] {
            if let recipes = recipes[selectedCategory] {
                return recipes.map { $0.name }
            }
            return []
        }
        
        private var scaledIngredients: [Ingredient] {
            guard let recipe = currentRecipe,
                  let originalServingsInt = Int(originalServings),
                  let desiredServingsInt = Int(desiredServings),
                  originalServingsInt > 0 else {
                return currentRecipe?.ingredients ?? []
            }
            
            let scaleFactor = Double(desiredServingsInt) / Double(originalServingsInt)
            
            return recipe.ingredients.map { ingredient in
                var scaledIngredient = ingredient
                scaledIngredient.amount = (ingredient.amount * scaleFactor).rounded(to: 2)
                return scaledIngredient
            }
        }
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Recipe Selection")) {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedCategory) { _ in
                            if let firstRecipe = recipeNames.first {
                                selectedRecipe = firstRecipe
                                if let recipe = currentRecipe {
                                    originalServings = "\(recipe.servings)"
                                }
                            }
                        }
                        
                        HStack {
                            Text("Recipe")
                            Spacer()
                            Button(selectedRecipe) {
                                showingRecipeList = true
                            }
                            .foregroundColor(.blue)
                        }
                        .actionSheet(isPresented: $showingRecipeList) {
                            ActionSheet(
                                title: Text("Select Recipe"),
                                buttons: recipeNames.map { name in
                                    .default(Text(name)) {
                                        selectedRecipe = name
                                        if let recipe = currentRecipe {
                                            originalServings = "\(recipe.servings)"
                                        }
                                    }
                                } + [.cancel()]
                            )
                        }
                    }
                    
                    Section(header: Text("Serving Size")) {
                        HStack {
                            Text("Original Servings")
                            Spacer()
                            TextField("Original", text: $originalServings)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Desired Servings")
                            Spacer()
                            TextField("Desired", text: $desiredServings)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Section(header: Text("Scaled Ingredients")) {
                        if let recipe = currentRecipe, !originalServings.isEmpty, !desiredServings.isEmpty,
                           let original = Int(originalServings), let desired = Int(desiredServings), original > 0 {
                            ForEach(scaledIngredients.indices, id: \.self) { index in
                                HStack {
                                    Text(scaledIngredients[index].name)
                                    Spacer()
                                    Text(formatAmount(scaledIngredients[index].amount, unit: scaledIngredients[index].unit))
                                }
                            }
                        } else {
                            Text("Enter serving information to see scaled ingredients")
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                }
                .navigationTitle("Recipe Scaler")
                .onAppear {
                    if let recipe = currentRecipe {
                        originalServings = "\(recipe.servings)"
                    }
                }
            }
        }
        
        // Helper functions
        private func formatAmount(_ amount: Double, unit: String) -> String {
            let formattedAmount = formatFraction(amount)
            return unit.isEmpty ? "\(formattedAmount)" : "\(formattedAmount) \(unit)"
        }
        
        private func formatFraction(_ value: Double) -> String {
            let whole = Int(value)
            let decimal = value - Double(whole)
            
            // Return just the whole number if decimal part is very small
            if decimal < 0.01 {
                return "\(whole)"
            }
            
            // Special common fractions
            let fractions: [(threshold: Double, display: String)] = [
                (0.120, "1/8"),
                (0.250, "1/4"),
                (0.330, "1/3"),
                (0.375, "3/8"),
                (0.500, "1/2"),
                (0.625, "5/8"),
                (0.666, "2/3"),
                (0.750, "3/4"),
                (0.875, "7/8"),
                (0.999, "")  // Just to capture anything close to 1
            ]
            
            // Find the closest fraction
            for (index, fraction) in fractions.enumerated() {
                if decimal <= fraction.threshold {
                    let fractionDisplay = fraction.display
                    
                    // If it's very close to the next whole number
                    if index == fractions.count - 1 {
                        return "\(whole + 1)"
                    }
                    
                    // If whole part is 0, just return the fraction
                    if whole == 0 {
                        return fractionDisplay
                    }
                    
                    // Otherwise combine whole and fraction
                    return "\(whole) \(fractionDisplay)"
                }
            }
            
            // Fallback to decimal format
            return String(format: "%.2f", value)
        }
    }

    extension Double {
        func rounded(to places: Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScaling()
    }
}
