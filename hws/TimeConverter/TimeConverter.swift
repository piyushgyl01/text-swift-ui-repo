//
//  TimeConverter.swift
//  hws
//
//  Created by piyush ehe on 25/03/25.
//

import SwiftUI

struct TimeConverter: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "seconds"
    @State private var outputUnit = "minutes"
    
    let units = ["seconds", "minutes", "hours", "days"]

    func toSeconds(value: Double, from unit: String) ->  Double {
        switch unit {
        case "minutes":
            return value * 60
        case "hours":
            return value * 3600
        case "days":
            return value * 86400
        default:
            return value
        }
    }
    
    func fromSeconds(_ seconds: Double, to unit: String) -> Double {
        switch unit {
        case "minutes":
            return seconds / 60
        case "hours":
            return seconds / 3600
        case "days":
            return seconds / 86400
        default:
            return seconds
        }
    }
    
    var result: Double {
        let seconds = toSeconds(value: inputValue, from: inputUnit)
        let finalValue = fromSeconds(seconds, to: outputUnit)
        return finalValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Input") {
                    TextField("Value", value: $inputValue, format: .number)
                    
                    Picker("From", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }
                
                Section("Output") {
                    Picker("To", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    Text("\(result.formatted()) \(outputUnit)")
                }
            }
            .navigationTitle("Time Converter")
        }
    }
}

#Preview {
    TimeConverter()
}
