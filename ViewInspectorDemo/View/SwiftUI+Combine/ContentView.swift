//
//  ContentView.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/4/27.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel:ContentCombineViewModel = .init()

    var body: some View {
        SearchUserBar(text: $viewModel.name) {
            self.viewModel.search()
        }
        ScrollView(.vertical) {
            VStack{
                ForEach(viewModel.viewObjects){
                    Text($0.text)
                        .padding()
                        .accessibility(identifier: $0.id)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchUserBar: View {
    @Binding var text: String
    @State var action: () -> Void

    var body: some View {
        ZStack {
            Color.gray
            HStack {
                TextField("Search User", text: $text)
                    .padding([.leading, .trailing], 8)
                    .frame(height: 32)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(8)

                Button("Search", action: action)
                    .foregroundColor(Color.white)
                .padding([.leading, .trailing], 16)
            }
        }
        .frame(height: 64)
    }
}
