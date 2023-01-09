//
//  ContentView.swift
//  iSplit
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 10
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = 0..<101
    
    var noTip: Bool {
        tipPercentage == 0
    }
    
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    var totalAmount: Double {
        return (1.0 + Double(tipPercentage) * 0.01) * checkAmount
    }
    
    var amountPerPerson: Double {
        let numberOfPeopleProcessed = numberOfPeople + 2
        guard numberOfPeopleProcessed != 0 else {return 0.0}
        return totalAmount / Double(numberOfPeopleProcessed)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(value: $checkAmount,
                              format: currencyFormat)
                        { Text("Amount") }
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 11) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip %", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalAmount, format: currencyFormat)
                        .foregroundColor(noTip ? .red : .primary)
                } header: {
                    Text("Total amount")
                }
                
                
                Section {
                    Text(amountPerPerson, format: currencyFormat)
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("iSplit 🧾")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
