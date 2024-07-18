//
//  ContentView.swift
//  GrindTime
//
//  Created by Danny Berry on 7/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to GrindTime")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: WorkoutPlanView()) {
                    Text("View Workout Plans")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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

struct WorkoutPlanDetailView: View {
    let workoutPlan: WorkoutPlan

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(workoutPlan.name)
                    .font(.largeTitle)
                    .padding(.bottom)

                Text(workoutPlan.description)
                    .padding(.bottom)

                Text("Exercises:")
                    .font(.headline)
                    .padding(.bottom)

                ForEach(workoutPlan.exercises, id: \.self) { exercise in
                    Text("- \(exercise)")
                        .padding(.bottom, 2)
                }
            }
            .padding()
        }
        .navigationTitle(workoutPlan.name)
    }
}


struct WorkoutPlanView: View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var selectedMuscle = "biceps"

    var body: some View {
        VStack {
            Picker("Select Muscle Group", selection: $selectedMuscle) {
                Text("Biceps").tag("biceps")
                Text("Triceps").tag("triceps")
                Text("Chest").tag("chest")
                Text("Legs").tag("legs")
                Text("Back").tag("back")
                Text("Shoulders").tag("shoulders")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: {
                networkManager.fetchExercises(for: selectedMuscle)
            }) {
                Text("Fetch Exercises")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)

            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(networkManager.exercises) { exercise in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(exercise.name)
                                .font(.headline)
                            Text("Type: \(exercise.type)")
                            Text("Muscle: \(exercise.muscle)")
                            Text("Equipment: \(exercise.equipment)")
                            Text("Difficulty: \(exercise.difficulty)")
                            Text("Instructions: \(exercise.instructions)")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Exercises")
        }
        .padding()
    }
}

struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPlanView()
    }
}


