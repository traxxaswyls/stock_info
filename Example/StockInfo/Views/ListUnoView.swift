//
//  ListUnoView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI
import SwiftYFinance

struct ListUnoView: View {
    var result: StockInfoPlainObject

    var body: some View {
        VStack(alignment: .leading) {
            Text(result.companyName)
                .font(.title)
                .fontWeight(.semibold)
            Text(result.tickerName)
            HStack {
                Text("Price: ") + Text(String(result.lastPrice))
                Spacer()
                Text(String(result.percentUpdate))
                    .foregroundColor(result.percentUpdate > 0 ? .green : .red) +
                Text("%")
                    .foregroundColor(result.percentUpdate > 0 ? .green : .red)
            }
            HStack {
                Text("Volume in mlns: ")
                Spacer()
                Text(String(result.volumeInMillions))
            }
            HStack {
                Text("Percentage week: ")
                Spacer()
                Text(String(result.percentUpdateWeek))
                    .foregroundColor(result.percentUpdateWeek > 0 ? .green : .red) +
                Text("%")
                    .foregroundColor(result.percentUpdateWeek > 0 ? .green : .red)
            }
            HStack {
                Text("Percentage month: ")
                Spacer()
                Text(String(result.percentUpdateMonth))
                    .foregroundColor(result.percentUpdateMonth > 0 ? .green : .red) +
                Text("%")
                    .foregroundColor(result.percentUpdateMonth > 0 ? .green : .red)
            }
            HStack {
                Text("Percentage year: ")
                Spacer()
                Text(String(result.percentUpdateStartYear))
                    .foregroundColor(result.percentUpdateStartYear > 0 ? .green : .red) +
                Text("%")
                    .foregroundColor(result.percentUpdateStartYear > 0 ? .green : .red)
            }
            HStack {
                Text("Capitalization  ")
                Spacer()
                Text(String(result.capitalizationInBillionRUB) + " RUB  ") + Text(String(result.capitalizationInBillionUSD) + " USD")
            }

        }.padding(.all)
    }
}

struct ListUnoView_Previews: PreviewProvider {
    static var previews: some View {
        ListUnoView(result: .init(updateTime: 3234234, companyName: "dfsdf", tickerName: "ddd", lastPrice: 22, percentUpdate: 1, volumeInMillions: 1, percentUpdateWeek: 2, percentUpdateMonth: 3, percentUpdateStartYear: 3, percentUpdateYear: 1, capitalizationInBillionRUB: 2, capitalizationInBillionUSD: 3))
    }
}
