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
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    ContentView()
}
