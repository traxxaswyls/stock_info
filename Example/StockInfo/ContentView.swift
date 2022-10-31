//
//  ContentView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI
import SwiftYFinance

enum Period: Equatable {
    case week
    case month
    case year
}

enum Filter: Equatable {
    case desc(Period)
    case inc(Period)
}

struct ContentView: View {
    @State var searchString: String = "AAPL"
    @State var foundContainer: [StockInfoPlainObject] = []

    @State var sheetVisible = false
    @State var filter: Filter = .inc(.week)
    @ObservedObject var selection = SelectedSymbolWrapper()
    var body: some View {
        VStack {
            HStack {
                Text("Stock Info")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Desc filter")
                    .contextMenu {
                        Button(action: { filter = .desc(.week) }) {
                            Text("week")
                        }
                        // 2.
                        Button(action: { filter = .desc(.month) }) {
                            Text("month")
                        }
                        // 3.
                        Button(action: { filter = .desc(.year) }) {
                            Text("year")
                        }
                    }
                Text("Stonks filter")
                    .contextMenu {
                        Button(action: { filter = .inc(.week) }) {
                            Text("week")
                        }
                        // 2.
                        Button(action: { filter = .inc(.month) }) {
                            Text("month")
                        }
                        // 3.
                        Button(action: { filter = .inc(.year) }) {
                            Text("year")
                        }
                    }

            }.padding([.top, .leading, .trailing])
            TextField("Search", text: $searchString, onCommit: self.searchObjects)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(5).padding(.horizontal)

            Group {
                List {
                    ForEach(self.foundContainer.filter({
                        searchString.isEmpty || $0.companyName.uppercased().contains(searchString.uppercased()) || $0.tickerName.uppercased().contains(searchString.uppercased())
                    }).sorted(by: { lhs, rhs in
                        switch filter {
                        case .desc(let period):
                            switch period {
                            case .week:
                                return lhs.percentUpdateWeek > rhs.percentUpdateWeek
                            case .month:
                                return lhs.percentUpdateMonth > rhs.percentUpdateMonth
                            case .year:
                                return lhs.percentUpdateYear > rhs.percentUpdateYear
                            }
                        case .inc(let period):
                            switch period {
                            case .week:
                                return lhs.percentUpdateWeek < rhs.percentUpdateWeek
                            case .month:
                                return lhs.percentUpdateMonth < rhs.percentUpdateMonth
                            case .year:
                                return lhs.percentUpdateYear < rhs.percentUpdateYear
                            }
                        }
                    }), id: \.tickerName) { result in
                        Button(action: {
                            self.selection.symbol = result.tickerName
                            self.sheetVisible = true
                        }) {
                            ListUnoView(result: result).listRowInsets(EdgeInsets())
                        }
                    }.listRowInsets(EdgeInsets())
                }.padding(0.0)
            }
            Spacer()
        }.sheet(isPresented: self.$sheetVisible, content: {
            SheetView(selection: self.selection)
        }).onAppear(perform: self.searchObjects)
    }

    func searchObjects() {
        StockService().stoks(sort: "") { result in
            switch result {
            case .success(let stoks):
                self.foundContainer = stoks.stoks
            case .failure:
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SelectedSymbolWrapper: ObservableObject {
    @Published var symbol: String?
    init(symbol: String) {
        self.symbol = symbol
    }
    init() {
    }
}
