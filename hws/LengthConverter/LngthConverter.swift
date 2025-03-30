//
//  LngthConverter.swift
//  hws
//
//  Created by piyush ehe on 18/03/25.
//

import SwiftUI

struct LngthConverter: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "meters"
    @State private var outputUnit = "feet"
    
    let units = ["meters", "kilometers", "feet", "yards", "miles"]

    var result: Double {
        let metersValue = toMeters(inputValue, from: inputUnit)
        let finalValue = fromMeters(metersValue, to: outputUnit)
        return finalValue
    }
    
    func toMeters(_ value: Double, from unit: String) -> Double {
        switch unit {
        case "kilometers":
            return value * 1000
        case "feet":
            return value * 0.3048
        case "yards":
            return value * 0.9144
        case "miles":
            return value * 1609.344
        default:
            return value
        }
    }
    
    func fromMeters(_ meters: Double, to unit: String) -> Double {
        switch unit {
        case "kilometers":
            return meters / 1000
        case "feet":
            return meters / 0.3048
        case "yards":
            return meters / 0.9144
        case "miles":
            return meters / 1609.344
        default:
            return meters
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input")) {
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Output Unit")) {
                    Picker("Convert to", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Result")) {
                    Text("\(result.formatted()) \(outputUnit)")
                }
            }
            .navigationTitle("Length Converter")
        }
    }
}

#Preview {
    LngthConverter()
}
