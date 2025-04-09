//
//  FitnessTracker.swift
//  hws
//
//  Created by piyush ehe on 10/04/25.
//

import SwiftUI

struct FitnessTracker: View {
    @State private var weight = 70.0
    @State private var height = 170.0
    @State private var age = 30.0
    @State private var gender = "Male"
    @State private var activityLevel = "Moderate"
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

struct FitnessTracker_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTracker()
    }
}
