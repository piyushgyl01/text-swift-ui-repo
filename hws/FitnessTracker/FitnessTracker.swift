//
//  FitnessTracker.swift
//  hws
//
//  Created by piyush ehe on 10/04/25.
//

import SwiftUI

struct FitnessTracker: View {
    // Input values
    @State private var weight = 70.0
    @State private var height = 170.0
    @State private var age = 30.0
    @State private var gender = "Male"
    @State private var activityLevel = "Moderate"
    
    // Selected calculation
    @State private var selectedCalculation = "BMI"
    
    // Available options
    let genders = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
    let calculationTypes = ["BMI", "BMR", "Daily Calories", "Ideal Weight"]
    
    // Computed result
    var result: String {
        switch selectedCalculation {
        case "BMI":
            let bmi = weight / ((height / 100) * (height / 100))
            let category: String
            
            switch bmi {
            case ..<18.5:
                category = "Underweight"
            case 18.5..<25:
                category = "Normal weight"
            case 25..<30:
                category = "Overweight"
            default:
                category = "Obese"
            }
            
            return "\(bmi.formatted()) - \(category)"
            
        case "BMR":
            // Mifflin-St Jeor Equation
            let bmr: Double
            if gender == "Male" {
                bmr = 10 * weight + 6.25 * height - 5 * age + 5
            } else {
                bmr = 10 * weight + 6.25 * height - 5 * age - 161
            }
            return "\(bmr.formatted()) calories per day"
            
        case "Daily Calories":
            // Calculate BMR first
            let bmr: Double
            if gender == "Male" {
                bmr = 10 * weight + 6.25 * height - 5 * age + 5
            } else {
                bmr = 10 * weight + 6.25 * height - 5 * age - 161
            }
            
            // Apply activity multiplier
            let multiplier: Double
            switch activityLevel {
            case "Sedentary":
                multiplier = 1.2
            case "Light":
                multiplier = 1.375
            case "Moderate":
                multiplier = 1.55
            case "Active":
                multiplier = 1.725
            case "Very Active":
                multiplier = 1.9
            default:
                multiplier = 1.2
            }
            
            let calories = bmr * multiplier
            return "\(calories.formatted()) calories per day"
            
        case "Ideal Weight":
            // Devine Formula
            let idealWeight: Double
            if gender == "Male" {
                idealWeight = 50 + 2.3 * ((height - 152.4) / 2.54)
            } else {
                idealWeight = 45.5 + 2.3 * ((height - 152.4) / 2.54)
            }
            return "\(idealWeight.formatted()) kg"
            
        default:
            return "Please select a calculation type"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("Weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Height (cm)")
                        Spacer()
                        TextField("Height", value: $height, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("Age", value: $age, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(activityLevels, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Calculation Type")) {
                    Picker("Calculate", selection: $selectedCalculation) {
                        ForEach(calculationTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Result")) {
                    Text(result)
                        .font(.headline)
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BMI (Body Mass Index)")
                            .font(.subheadline)
                            .bold()
                        Text("A measure of body fat based on height and weight.")
                            .font(.caption)
                        
                        Text("BMR (Basal Metabolic Rate)")
                            .font(.subheadline)
                            .bold()
                        Text("The calories your body needs at complete rest.")
                            .font(.caption)
                        
                        Text("Daily Calories")
                            .font(.subheadline)
                            .bold()
                        Text("Total calories needed based on activity level.")
                            .font(.caption)
                        
                        Text("Ideal Weight")
                            .font(.subheadline)
                            .bold()
                        Text("Estimated ideal weight based on height and gender.")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Fitness Calculator")
        }
    }
}

struct FitnessTracker_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTracker()
    }
}
