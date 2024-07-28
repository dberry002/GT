//
//  WorkoutSessionView.swift
//  GrindTime
//
//  Created by Danny Berry on 8/4/24.
//

import SwiftUI

struct WorkoutSessionsView: View {
    @ObservedObject var personalWorkoutManager: PersonalWorkoutManager

    var body: some View {
        VStack {
            List {
                ForEach(personalWorkoutManager.workoutSessions) { session in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(session.name)
                            .font(.headline)
                        
                        Text("Date: \(session.date, formatter: dateFormatter)")
                        Text("Exercises: \(session.exercises.count)")
                        
                        DisclosureGroup("Exercises") {
                            ForEach(session.exercises) { exercise in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(exercise.name)
                                        .font(.subheadline)
                                    Text("Type: \(exercise.type)")
                                    Text("Muscle: \(exercise.muscle)")
                                    Text("Equipment: \(exercise.equipment)")
                                    Text("Difficulty: \(exercise.difficulty)")
                                    Text("Instructions: \(exercise.instructions)")
                                        .padding()
                                }
                                .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Workout Sessions")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct WorkoutSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionsView(personalWorkoutManager: PersonalWorkoutManager())
    }
}
