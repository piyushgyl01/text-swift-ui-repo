//
//  DollarConverter.swift
//  hws
//
//  Created by piyush ehe on 18/03/25.
//

import SwiftUI

struct Currency_1: Identifiable {
    let id = UUID()
    let name: String
    let rate: Double
}

struct DollarConverter: View {
    @State private var inputAmount = 0.0
    @State private var inputCurrency = "USD"
    @State private var outputCurrency = "EUR"
    
    let currencies = [
        Currency(name: "USD", rate: 1.0),
        Currency(name: "EUR", rate: 0.85),
        Currency(name: "GBP", rate: 0.75),
        Currency(name: "JPY", rate: 0.0073)
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Amount to Convert") {
                    TextField("Enter amount", value: $inputAmount, format: .number).keyboardType(.decimalPad)
                }
                
                Section("Convert from") {
                    Picker("Input Currency", selection: $inputCurrency) {
                        ForEach(currencies) {currency in
                            Text(currency.name)
                                .tag(currency.name)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converted To") {
                    Picker("Output Currency", selection: $outputCurrency) {
                        ForEach(currencies) {
                            currency in Text(currency.name)
                                .tag(currency.name)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converted Amount") {
                    Text(convertedValue.formatted(.number.precision(.fractionLength(2...))))
                }
            }
            .navigationTitle("Currency Converter")
        }
    }
    
    var convertedValue: Double {
        guard let input = currencies.first(where: {$0.name == inputCurrency}),
              let output = currencies.first(where: {$0.name == outputCurrency}) else {
            return 0.0
        }
        let usdValue = inputAmount * input.rate
        return usdValue / output.rate
    }
}

#Preview {
    DollarConverter()
}
