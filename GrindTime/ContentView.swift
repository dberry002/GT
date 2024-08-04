//
//  ContentView.swift
//  GrindTime
//
//  Created by Danny Berry on 7/17/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var personalWorkoutManager = PersonalWorkoutManager()

    var body: some View {
        NavigationView {
            VStack {
                Image("GT.logo")
                       .resizable()
                       .scaledToFill()
                       .opacity(0.5)
                       .frame(width: 200, height: 450)
                   
                   Text("Start Your Grind Time:")
                       .font(.largeTitle)
                       .padding()
                       .shadow(color: .blue, radius: 10)
                       .bold()
                   
                   NavigationLink(destination: WorkoutPlanView(personalWorkoutManager: personalWorkoutManager)) {
                       Text("View Workout Plans")
                           .font(.headline)
                           .padding()
                           .background(Color.black)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           .shadow(color: .blue, radius: 10)
                   }
                   .padding(.bottom, 10) // Optional padding for spacing
                   
                   NavigationLink(destination: WorkoutSessionsView(personalWorkoutManager: personalWorkoutManager)) {
                       Text("View Workout Sessions")
                           .font(.headline)
                           .padding()
                           .background(Color.black)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           .shadow(color: .blue, radius: 10)
                   }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct WorkoutPlan: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let exercises: [String]
}
