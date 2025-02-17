//
//  TempConverter.swift
//  hws
//
//  Created by piyush ehe on 15/02/25.
//

import SwiftUI

struct TempConverter: View {
    @State private var inputTemp = 0.0
    @State private var inputUnit = "Celsius"
    @State private var outputUnit = "Fahrenheit"
    
    let units = ["Celsius", "Fahrenheit", "Kelvin"]

    var convertedTemp: Double {
        
        let celsius: Double
        
        switch inputUnit {
        case "Fahrenheit":
              celsius = (inputTemp - 32) * 5/9
        case "Kelvin":
              celsius = inputTemp - 273.15
        default:
              celsius = inputTemp
        }
        
        switch outputUnit {
        case "Fahrenheit":
            return celsius * 9/5 + 32
        case "Kelvin":
            return celsius + 273.15
        default:
            return celsius
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Input Temperature") {
                    TextField("Temperature", value: $inputTemp, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("From", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Convert To") {
                    Picker("To", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Result") {
                    Text(convertedTemp.formatted())
                }
            }
            .navigationTitle("Temperature Converter")
        }
    }
}

#Preview {
    TempConverter()
}
