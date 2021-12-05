//
//  MainView.swift
//  ShazamKitDemo
//
//  Created by Tuğçe Arar on 5.12.2021.
//

import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel = MainViewModel()
    var body: some View {
        ZStack(){
            AsyncImage(url: viewModel.shazamMedia.albumArtURL).blur(radius: 10,opaque: true).opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                AsyncImage(url: viewModel.shazamMedia.albumArtURL){image
                    in image
                        .resizable()
                        .frame(width:300,height:300)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.blue.opacity(0.5))
                                            .frame(width: 300, height: 300)
                                            .cornerRadius(10)
                                            .redacted(reason: .privacy)
                }
                Text(viewModel.shazamMedia.artistName ?? "Artist")
                Text(viewModel.shazamMedia.title ?? "Title")
            }
        }
        .onAppear {
            viewModel.startOrEndListening()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
