//
//  TipSplitter.swift
//  hws
//
//  Created by piyush ehe on 12/03/25.
//

import SwiftUI

struct TipSplitter: View {
    
    @State private var billAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 15
    
    let tipPercentages = [0, 5, 10, 15, 18, 20, 25]
    
    @State private var roundingOption = "None"
    let roundingOptions = ["None", "Round Down", "Round Up", "Round to Nearest"]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = billAmount / 100 * tipSelection
        let grandTotal = billAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        switch roundingOption {
        case "Round Down":
            return floor(amountPerPerson)
        case "Round Up":
            return ceil(amountPerPerson)
        case "Round to Nearest":
            return round(amountPerPerson)
        default:
            return amountPerPerson
        }
    }
    
    var totalBill: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = billAmount / 100 * tipSelection
        return billAmount + tipValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bill Information")) {
                    TextField("Amount", value: $billAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(1..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Rounding Options")) {
                    Picker("Round each person's amount", selection: $roundingOption) {
                        ForEach(roundingOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Bill Summary")) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(billAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    
                    HStack {
                        Text("Tip Amount")
                        Spacer()
                        Text(totalBill - billAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    
                    HStack {
                        Text("Total with tip")
                        Spacer()
                        Text(totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .fontWeight(.bold)
                    }
                }
                
                Section(header: Text("Amount Per Person")) {
                    HStack {
                        Text("Each person pays")
                        Spacer()
                        Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .fontWeight(.bold)
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("Tip Splitter")
        }
    }
}

struct TipSplitter_Previews: PreviewProvider {
    static var previews: some View {
        TipSplitter()
    }
}
