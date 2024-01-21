//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by _rati on 10.01.24.
//

import SwiftUI

struct FlagImage: ViewModifier{
    func body(content: Content) -> some View {
        content
            .border(Color.black)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct MakeProminent: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundColor(.accentColor)
            .font(.largeTitle.bold())
    }
}

extension View {
    func makeProminant() -> some View{
        modifier(MakeProminent())
    }
}

struct ContentView: View {
    @State private var countries = ["ესტონეთი", "საფრანგეთი", "გერმანია", "ირლანდია", "იტალია", "ნიგერია", "პოლონეთი", "ესპანეთი", "ბრიტანეთი", "უკრაინა", "ამერიკა"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var isLast = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    private let limit = 5
    @State private var totalTries = 0
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.4), location: 0.6),
                .init(color: Color(red: 0.75, green: 0.1, blue: 0.25), location: 0.3)
            ], center: .top, startRadius: 5, endRadius: 500)
            .ignoresSafeArea()
            
            VStack{
                Text("რა დროშა მოგვცა მიშამა?")
                    .makeProminant()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    
                Spacer()
                VStack(spacing: 15){
                    VStack{
                        Text("რომელია")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        //.foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .modifier(FlagImage())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("ქულა: \(String(describing: score))")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("გამოუშვი", action: nextQustion)
        } message: {
            Text("მიმდინარე ქულა: \(String(describing: score))")
        }
        
        .alert("ვსო, მორჩა", isPresented: $isLast){
            Button("თავიდან დაწყება", action: reset)
        } message: {
            Text("საბოლოო ქულა: 5-დან \(String(describing: score))")
        }
        
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "საღოლ!"
            score += 1
        }else{
            scoreTitle = "ნწუ, ეგ \(countries[number])ა"
        }
        totalTries += 1
        if(totalTries < limit){
            showingScore = true
        }else{
            showingScore = true
            isLast = true
        }
    }
    
    
    func nextQustion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset(){
        totalTries = 0
        score = 0
    }
}

#Preview {
    ContentView()
}
