//
//  CreatePostRequest.swift
//  IosNetwork
//
//  Created by 김민규 on 2/5/26.
//

struct CreatePostRequest: Encodable {
    let title: String
    let body: String
    let userId: Int
}
