//
//  NetworkManager.swift
//  GrindTime
//
//  Created by Danny Berry on 7/18/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var exercises: [Exercise] = []

    private let apiKey = "jI8ujAZjI23jnQQLBLdmYw==AiW7mFPeuo57ZZfW"

    func fetchExercises(for muscle: String) {
        let subcategories: [String]
        if muscle == "legs" {
            subcategories = ["calves", "glutes", "hamstrings"]
        } else if muscle == "back" {
            subcategories = ["lower_back", "middle_back"]
        } else {
            subcategories = [muscle]
        }

        let dispatchGroup = DispatchGroup()
        var combinedExercises: [Exercise] = []

        for subcategory in subcategories {
            dispatchGroup.enter()
            fetchExercises(forSubcategory: subcategory) { exercises in
                combinedExercises.append(contentsOf: exercises)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.exercises = combinedExercises
        }
    }

    private func fetchExercises(forSubcategory subcategory: String, completion: @escaping ([Exercise]) -> Void) {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/exercises?muscle=\(subcategory)") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Exercise].self, from: data)
                    completion(decodedResponse)
                } catch {
                    print("Decoding failed: \(error.localizedDescription)")
                    completion([])
                }
            } else {
                completion([])
            }
        }
        task.resume()
    }
}


struct Exercise: Identifiable, Codable {
    let id: UUID = UUID()
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case muscle
        case equipment
        case difficulty
        case instructions
    }
}


class PersonalWorkoutManager: ObservableObject {
    @Published var personalWorkout: [Exercise] = []
    @Published var workoutSessions: [WorkoutSession] = []

    func addExercise(_ exercise: Exercise) {
        if !personalWorkout.contains(where: { $0.id == exercise.id }) {
            personalWorkout.append(exercise)
        }
    }

    func removeExercise(_ exercise: Exercise) {
        personalWorkout.removeAll { $0.id == exercise.id }
    }

    func saveWorkoutSession(name: String) {
        let newSession = WorkoutSession(name: name, exercises: personalWorkout)
        workoutSessions.append(newSession)
        personalWorkout.removeAll()
    }
}




struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    let name: String
    let date: Date
    let exercises: [Exercise]
    
    init(name: String, exercises: [Exercise], date: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
        self.date = date
    }
}








