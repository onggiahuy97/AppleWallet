//
//  PlaygroundSwiftUI.swift
//  PlaygroundSwiftUI
//
//  Created by Huy Ong on 8/2/21.
//

import SwiftUI
import Combine

struct PlaygroundSwiftUI: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.title)
            TextField("Number", text: $viewModel.number)
                .padding()
                .keyboardType(.numberPad)
        }
    }
}

extension PlaygroundSwiftUI {
    class ViewModel: ObservableObject {
        @Published var number = ""
        
        var title = ""
        
        var cancellables = Set<AnyCancellable>()
        
        init() {
            $number
                .sink { str in
                    var res = ""
                    str.enumerated().forEach { ele in
                        if (ele.offset + 1) % 4 == 0 {
                            res.append("\(ele.element) ")
                        } else {
                            res.append(ele.element)
                        }
                    }
                    self.title = res
                }
                .store(in: &cancellables)
        }
    }
}

struct PlaygroundSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundSwiftUI()
    }
}
