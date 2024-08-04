//
//  WorkoutPlanView.swift
//  GrindTime
//
//  Created by Danny Berry on 8/4/24.
//

import SwiftUI

struct WorkoutPlanView: View {
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var personalWorkoutManager: PersonalWorkoutManager
    @State private var selectedMuscle = "biceps"
    @State private var showSaveSessionSheet = false
    @State private var sessionName = ""

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
                    if networkManager.exercises.isEmpty {
                        Text("No exercises found for \(selectedMuscle).")
                            .padding()
                    } else {
                        ForEach(networkManager.exercises) { exercise in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(exercise.name)
                                    .font(.headline)
                                
                                Text("Type: \(exercise.type)")
                                Text("Muscle: \(exercise.muscle)")
                                Text("Equipment: \(exercise.equipment)")
                                Text("Difficulty: \(exercise.difficulty)")
                                
                                DisclosureGroup("Instructions") {
                                    Text(exercise.instructions)
                                        .padding()
                                }
                                .padding(.top, 5)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.bottom, 10)
                                
                                Button(action: {
                                    personalWorkoutManager.addExercise(exercise)
                                }) {
                                    Text("Add to Personal Workout")
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Exercises")
            
            Button(action: {
                showSaveSessionSheet = true
            }) {
                Text("Save Workout Session")
                    .font(.headline)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $showSaveSessionSheet) {
            VStack {
                Text("Enter Session Name")
                    .font(.headline)
                    .padding()

                TextField("Session Name", text: $sessionName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if !sessionName.isEmpty {
                        personalWorkoutManager.saveWorkoutSession(name: sessionName)
                        sessionName = ""
                        showSaveSessionSheet = false
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}



struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPlanView(personalWorkoutManager: PersonalWorkoutManager())
    }
}
