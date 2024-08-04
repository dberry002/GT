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
    @State private var showAddExerciseSheet = false
    @State private var newExerciseName = ""
    @State private var newExerciseType = ""
    @State private var newExerciseMuscle = ""
    @State private var newExerciseEquipment = ""
    @State private var newExerciseDifficulty = ""
    @State private var newExerciseInstructions = ""

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
            .onChange(of: selectedMuscle) { newMuscle in
                networkManager.fetchExercises(for: newMuscle)
            }

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
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .blue, radius: 15)
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
                showAddExerciseSheet = true
            }) {
                Text("Add Other Exercise")
                    .font(.headline)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .blue, radius: 10)
            }
            .padding(.bottom)

            Button(action: {
                showSaveSessionSheet = true
            }) {
                Text("Save Workout Session")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 15)
            }
            .padding()
        }
        .sheet(isPresented: $showSaveSessionSheet) {
            VStack {
                Text("Enter Name")
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
        .sheet(isPresented: $showAddExerciseSheet) {
            VStack {
                Text("Add New Exercise")
                    .font(.headline)
                    .padding()

                TextField("Name", text: $newExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Type", text: $newExerciseType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Muscle", text: $newExerciseMuscle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Equipment", text: $newExerciseEquipment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Difficulty", text: $newExerciseDifficulty)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Instructions", text: $newExerciseInstructions)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    let newExercise = Exercise(
                        name: newExerciseName,
                        type: newExerciseType,
                        muscle: newExerciseMuscle,
                        equipment: newExerciseEquipment,
                        difficulty: newExerciseDifficulty,
                        instructions: newExerciseInstructions
                    )
                    personalWorkoutManager.addExercise(newExercise)
                    showAddExerciseSheet = false
                    // Clear the input fields
                    newExerciseName = ""
                    newExerciseType = ""
                    newExerciseMuscle = ""
                    newExerciseEquipment = ""
                    newExerciseDifficulty = ""
                    newExerciseInstructions = ""
                }) {
                    Text("Add Exercise")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .onAppear {
            networkManager.fetchExercises(for: selectedMuscle)
        }
    }
}

struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPlanView(personalWorkoutManager: PersonalWorkoutManager())
    }
}

