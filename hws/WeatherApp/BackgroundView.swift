//
//  BackgroundView.swift
//  hws
//
//  Created by piyush ehe on 18/02/25.
//
import SwiftUI


struct BackgroundView: View {
    
    var isNight: Bool
    
    var body: some View {
        ContainerRelativeShape()
            .fill(isNight ? Color.black.gradient : Color.blue.gradient)
            .ignoresSafeArea()
    }
}
