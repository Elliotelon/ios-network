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
    @Published var updatedPost: Post?
    
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
    
    func updatePost(
        postId: Int,
        title: String,
        body: String,
        userId: Int
    ) async throws {

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)")!
        var request = URLRequest(url: url)

        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(env.token)", forHTTPHeaderField: "Authorization")

        request.httpBody = try JSONEncoder().encode(
            CreatePostRequest(title: title, body: body, userId: userId)
        )

        let (data, _) = try await URLSession.shared.data(for: request)

        self.updatedPost = try JSONDecoder().decode(Post.self, from: data)
    }
    
    func patchPost(
        postId: Int,
        title: String? = nil,
        body: String? = nil
    ) async throws {

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)")!
        var request = URLRequest(url: url)

        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = Dictionary(uniqueKeysWithValues: [
            title.map { ("title", $0) },
            body.map { ("body", $0) }
        ].compactMap { $0 })

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, _) = try await URLSession.shared.data(for: request)
        self.updatedPost = try JSONDecoder().decode(Post.self, from: data)
    }
    
    func deletePost(postId: Int) async throws {

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)")!
        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"
        // request.setValue("Bearer \(env.token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        // 보통 DELETE는 response body 없음
    }


}
