//
//  VolumeConverter.swift
//  hws
//
//  Created by piyush ehe on 17/02/25.
//

import SwiftUI

struct VolumeConverter: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "milliliters"
    @State private var outputUnit = "liters"
    
    let units = ["milliliters", "liters", "cups", "pints", "gallons"]
    
    let toMilliliters = [
            "milliliters": 1.0,
            "liters": 1000.0,
            "cups": 236.588,
            "pints": 473.176,
            "gallons": 3785.41
        ]
    
    

    var result: Double {
        let valueInMl = inputValue * (toMilliliters[inputUnit] ?? 1.0)
        
        let outputValue = valueInMl / (toMilliliters[outputUnit] ?? 1.0)
        
        return outputValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input Value")) {
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Convert from")) {
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Convert To")) {
                    Picker("Convert from", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Result")) {
                    Text("\(result.formatted()) \(outputUnit)")
                        .font(.title2)
                }
            }
            .navigationTitle("Volume coverter")
        }
    }
}


#Preview {
    VolumeConverter()
}
