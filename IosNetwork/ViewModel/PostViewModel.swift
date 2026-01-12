//
//  PostViewModel.swift
//  IosNetwork
//
//  Created by 김민규 on 1/12/26.
//
import SwiftUI
import Combine

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func fetchPosts() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            if let data = data, let decoded = try? JSONDecoder().decode([Post].self, from: data) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("✅ 수신 데이터:\n\(prettyString)")
                }
                DispatchQueue.main.async {
                    self.posts = decoded
                }
            }
        }.resume()
    }
}
