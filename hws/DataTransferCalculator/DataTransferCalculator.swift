import SwiftUI

struct DataTransferCalculator: View {
    let sizeUnits = ["Bytes", "KB", "MB", "GB", "TB"]
    
    let speedUnits = ["Bps", "Kbps", "Mbps", "Gbps"]
    
    @State private var dataSize = 100.0
    @State private var sizeUnit = "MB"
    @State private var transferSpeed = 50.0
    @State private var speedUnit = "Mbps"
    @FocusState private var inputIsFocused: Bool
    @State private var showingPresets = false
    
    let sizeFactors = [
        "Bytes": 1.0,
        "KB": 1024.0,
        "MB": 1048576.0,
        "GB": 1073741824.0,
        "TB": 1099511627776.0
    ]
    
    let speedFactors = [
        "Bps": 8.0,
        "Kbps": 1000.0,
        "Mbps": 1000000.0,
        "Gbps": 1000000000.0
    ]
    
    let presets = [
        (name: "Netflix HD Movie (3GB)", size: 3.0, unit: "GB"),
        (name: "4K Movie (25GB)", size: 25.0, unit: "GB"),
        (name: "Music Album (150MB)", size: 150.0, unit: "MB"),
        (name: "Photo Backup (500MB)", size: 500.0, unit: "MB"),
        (name: "Game Download (80GB)", size: 80.0, unit: "GB")
    ]
    
    let connectionPresets = [
        (name: "3G", speed: 3.0, unit: "Mbps"),
        (name: "4G", speed: 20.0, unit: "Mbps"),
        (name: "5G", speed: 100.0, unit: "Mbps"),
        (name: "Basic WiFi", speed: 25.0, unit: "Mbps"),
        (name: "Fast WiFi", speed: 100.0, unit: "Mbps"),
        (name: "Fiber", speed: 1.0, unit: "Gbps")
    ]
    
    var transferTimeSeconds: Double {
        let sizeInBytes = dataSize * (sizeFactors[sizeUnit] ?? 1.0)
        
        let speedInBitsPerSecond = transferSpeed * (speedFactors[speedUnit] ?? 1.0)
        
        return (sizeInBytes * 8) / speedInBitsPerSecond
    }
    
    var formattedTime: String {
        let totalSeconds = transferTimeSeconds
        
        if totalSeconds < 1 {
            return "\(Int(totalSeconds * 1000)) milliseconds"
        } else if totalSeconds < 60 {
            return "\(totalSeconds.formatted(.number.precision(.fractionLength(1)))) seconds"
        } else if totalSeconds < 3600 {
            let minutes = Int(totalSeconds / 60)
            let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
            return "\(minutes)m \(seconds)s"
        } else if totalSeconds < 86400 {
            let hours = Int(totalSeconds / 3600)
            let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
            return "\(hours)h \(minutes)m"
        } else {
            let days = Int(totalSeconds / 86400)
            let hours = Int((totalSeconds.truncatingRemainder(dividingBy: 86400)) / 3600)
            return "\(days)d \(hours)h"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Data Size")) {
                    HStack {
                        TextField("Size", value: $dataSize, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($inputIsFocused)
                        
                        Picker("Unit", selection: $sizeUnit) {
                            ForEach(sizeUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    
                    Button("Choose from Presets") {
                        showingPresets.toggle()
                    }
                }
                
                if showingPresets {
                    Section(header: Text("Common File Sizes")) {
                        ForEach(presets, id: \.name) { preset in
                            Button(action: {
                                dataSize = preset.size
                                sizeUnit = preset.unit
                            }) {
                                HStack {
                                    Text(preset.name)
                                    Spacer()
                                    Text("\(preset.size, specifier: "%.1f") \(preset.unit)")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Section(header: Text("Transfer Speed")) {
                    HStack {
                        TextField("Speed", value: $transferSpeed, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($inputIsFocused)
                        
                        Picker("Unit", selection: $speedUnit) {
                            ForEach(speedUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                
                Section(header: Text("Connection Presets")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(connectionPresets, id: \.name) { preset in
                                Button(action: {
                                    transferSpeed = preset.speed
                                    speedUnit = preset.unit
                                }) {
                                    VStack {
                                        Image(systemName: connectionIcon(for: preset.name))
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(connectionColor(for: preset.name))
                                            .clipShape(Circle())
                                        
                                        Text(preset.name)
                                            .font(.caption)
                                        
                                        Text("\(preset.speed, specifier: "%.0f") \(preset.unit)")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 80)
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Transfer Time")) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(formattedTime)
                                .font(.headline)
                            
                            Text("To transfer \(dataSize.formatted()) \(sizeUnit) at \(transferSpeed.formatted()) \(speedUnit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("About")) {
                    Text("This calculator estimates file transfer times based on file size and connection speed. Actual transfer times may vary due to network conditions, overhead, and other factors.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Transfer Calculator")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
    }
    
    func connectionIcon(for name: String) -> String {
        switch name {
        case "3G", "4G", "5G":
            return "antenna.radiowaves.left.and.right"
        case "Basic WiFi", "Fast WiFi":
            return "wifi"
        case "Fiber":
            return "network"
        default:
            return "globe"
        }
    }
    
    func connectionColor(for name: String) -> Color {
        switch name {
        case "3G":
            return .orange
        case "4G":
            return .green
        case "5G":
            return .purple
        case "Basic WiFi":
            return .blue
        case "Fast WiFi":
            return .indigo
        case "Fiber":
            return .red
        default:
            return .gray
        }
    }
}

struct DataTransferCalculator_Previews: PreviewProvider {
    static var previews: some View {
        DataTransferCalculator()
    }
}
