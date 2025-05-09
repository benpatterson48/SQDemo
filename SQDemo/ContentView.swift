//
//  ContentView.swift
//  SQDemo
//
//  Created by Ben Patterson on 2/4/25.
//

import SwiftUI

protocol Countable {
    var count: Int { get set }
    func increment()
    func decrement()
    func reset()
}

private func notInCoverage() {
    print("I")
    print("am")
    print("not")
    print("in")
    print("coverage")
    print("I")
    print("am")
    print("not")
    print("in")
    print("coverage")
    print("I")
    print("am")
    print("not")
    print("in")
    print("coverage")
    print("I")
    print("am")
    print("not")
    print("in")
    print("coverage")
    print("a")
}

private func printNoTest() {
    print("Not a test")
}

private func printNoTestAgain() {
    print("Not a test")
    print("Not a test")
}

@Observable
final class CounterViewModel: Countable, ObservableObject {
    var count = 0
    
    func increment() {
        count += 1
    }
    
    func decrement() {
        count = max(0, count - 1)
    }
    
    func reset() {
        count = 0
    }
}

struct ContentView: View {
    @StateObject var counter = CounterViewModel()
    
    var body: some View {
        VStack {
            Text("\(counter.count)")
                .font(.system(size: 120))
                .bold()
            
            HStack {
                AddButton(
                    counter: counter
                )
                Spacer()
                    .frame(width: 32)
                SubtractButton(
                    counter: counter
                )
            }
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 32)
            
            Button {
                counter.reset()
            } label: {
                Text("Reset")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    struct AddButton: View {
        @ObservedObject var counter: CounterViewModel
        
        var body: some View {
            Button {
                counter.decrement()
            } label: {
                Text("Subtract")
                    .font(.headline)
                    .padding()
            }
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(.capsule)
        }
    }
    
    struct SubtractButton: View {
        @ObservedObject var counter: CounterViewModel
        
        var body: some View {
            Button {
                counter.increment()
            } label: {
                Text("Add")
                    .font(.headline)
                    .padding()
            }
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
