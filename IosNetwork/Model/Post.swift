//
//  Post.swift
//  IosNetwork
//
//  Created by 김민규 on 1/12/26.
//


struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
