//
//  CSSUnitConverter.swift
//  hws
//
//  Created by piyush ehe on 30/03/25.
//

import SwiftUI

struct CSSUnitConverter: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "px"
    @State private var outputUnit = "pt"
    
    let units = ["px", "pt", "in", "cm", "mm", "pc"]

    private let conversionRates: [String: Double] = [
        "px": 1.0,
        "pt": 0.75,
        "in": 0.0104166667,
        "cm": 0.0264583333,
        "mm": 0.2645833333,
        "pc": 0.0625
    ]
    
    var result: Double {
        let baseValue = inputValue / (conversionRates[inputUnit] ?? 1.0)
        return baseValue * (conversionRates[outputUnit] ?? 1.0)
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Length")) {
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
                Section(header: Text("Converted Length")) {
                    Text("\(result.formatted(.number.precision(.fractionLength(2)))) \(outputUnit)")
                }
                .navigationTitle("CSS Unit Converter")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CSSUnitConverter_Previews: PreviewProvider {
    static var previews: some View {
        CSSUnitConverter()
    }
}
