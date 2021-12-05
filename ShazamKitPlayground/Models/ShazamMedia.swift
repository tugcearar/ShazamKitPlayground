//
//  ShazamMedia.swift
//  ShazamKitDemo
//
//  Created by Tuğçe Arar on 5.12.2021.
//

import Foundation

struct ShazamMedia: Decodable
{
    let title:String?
    let subTitle:String?
    let artistName:String?
    let albumArtURL : URL?
    let genres: [String]
}
