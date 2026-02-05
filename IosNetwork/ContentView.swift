//
//  ContentView.swift
//  IosNetwork
//
//  Created by 김민규 on 1/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PostViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.posts) { post in
                Text(post.title)
            }
            .navigationTitle("Posts")
            .task {
                do {
                     try await viewModel.createPost(
                        title: "Hello",
                        body: "This is a post",
                        userId: 1
                    )
                    try await viewModel.fetchPosts()
                } catch {
                    print("❌ POST 실패:", error)
                }
            }

            //            .onAppear {
            //                viewModel.fetchPosts()
            //            }
        }
    }
}

#Preview {
    ContentView()
}
