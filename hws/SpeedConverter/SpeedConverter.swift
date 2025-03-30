//
//  SpeedConverter.swift
//  hws
//
//  Created by piyush ehe on 28/03/25.
//

import SwiftUI

struct SpeedConverter: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "m/s"
    @State private var outputUnit = "km/s"
    
    let units = ["m/s", "km/h", "mph", "knots"]

    private let conversionRates: [String: Double] = [
        "m/s": 1.0,
        "km/h": 3.6,
        "mph": 2.23694,
        "knots": 1.94384
    ]
    
    var result: Double {
        let baseSpeed = inputValue / (conversionRates[inputUnit] ?? 1.0)
        
        return baseSpeed * (conversionRates[outputUnit] ?? 1.0)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Speed")) {
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("From Unit")) {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("To Unit")) {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Converted Speed")) {
                    Text("\(result.formatted(.number.precision(.fractionLength(2)))) \(outputUnit)")
                }
            }
            .navigationTitle("Speed Converter")
        }
    }
}

struct SpeedConverter_Previews: PreviewProvider {
    static var previews: some View {
        SpeedConverter()
    }
}
