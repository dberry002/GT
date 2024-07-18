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

    func fetchExercises() {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/exercises") else { return }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Exercise].self, from: data) {
                    DispatchQueue.main.async {
                        self.exercises = decodedResponse
                    }
                } else {
                    print("Decoding failed")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }

    func fetchExercises(for muscle: String) {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/exercises?muscle=\(muscle)") else { return }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Exercise].self, from: data) {
                    DispatchQueue.main.async {
                        self.exercises = decodedResponse
                    }
                } else {
                    print("Decoding failed")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
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




