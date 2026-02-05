//
//  PostViewModel.swift
//  IosNetwork
//
//  Created by 김민규 on 1/12/26.
//
import SwiftUI
import Combine

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var createdPost: Post?
    
    //    func fetchPosts() {
    //
    //        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, _, _ in
    //
    //            if let data = data, let decoded = try? JSONDecoder().decode([Post].self, from: data) {
    //                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
    //                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
    //                   let prettyString = String(data: prettyData, encoding: .utf8) {
    //                    print("✅ 수신 데이터:\n\(prettyString)")
    //                }
    //                DispatchQueue.main.async {
    //                    self.posts = decoded
    //                }
    //            }
    //        }.resume()
    //    }
    
    func fetchPosts() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        self.posts = try JSONDecoder().decode([Post].self, from: data)
    }
    
    func createPost(title: String, body: String, userId: Int) async throws{
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(env.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(CreatePostRequest(title: title, body: body, userId: userId))
        
        let (data, _) = try await URLSession.shared.data(for: request)
        self.createdPost = try JSONDecoder().decode(Post.self, from: data)
       
    }
}
