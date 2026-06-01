//
//  AboutView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero — dark with icon constellation
                ZStack {
                    Color(red: 0.10, green: 0.12, blue: 0.14)
                    VStack(spacing: 14) {
                        ZStack {
                            Circle().fill(Color(red:0.10,green:0.62,blue:0.49).opacity(0.2)).frame(width:90,height:90)
                            Image(systemName: "bowl.fill")
                                .font(.system(size:40)).foregroundColor(Color(red:0.10,green:0.62,blue:0.49))
                        }
                        Text("Foodies Cafe")
                            .font(.system(size:28,weight:.bold,design:.rounded)).foregroundColor(.white)
                        HStack(spacing:6) {
                            Text("Fresh").foregroundColor(Color(red:0.18,green:0.72,blue:0.52))
                            Text("·").foregroundColor(.white.opacity(0.3))
                            Text("Flavourful").foregroundColor(Color(red:0.96,green:0.75,blue:0.20))
                            Text("·").foregroundColor(.white.opacity(0.3))
                            Text("Feel-good").foregroundColor(Color(red:0.93,green:0.36,blue:0.36))
                        }.font(.system(size:13,weight:.semibold,design:.rounded))
                    }.padding(.vertical, 36)
                }.frame(maxWidth:.infinity)

                VStack(alignment:.leading, spacing:20) {
                    FoodiesSectionBlock(title:"Our Story", icon:"book.fill",
                        content:"Foodies Cafe started from one simple idea: everyone deserves a great meal made with real ingredients. We grew from a small weekend market stall into a full neighbourhood cafe, still carrying that same passion for honest, delicious food.")
                    FoodiesSectionBlock(title:"Our Kitchen", icon:"flame.fill",
                        content:"Everything is prepared fresh daily. We source local produce, use in-house recipes, and skip the shortcuts. If it's on the menu, it was made this morning.")

                    Text("What We Stand For")
                        .font(.system(size:19,weight:.bold,design:.rounded))

                    LazyVGrid(columns:[GridItem(.flexible()),GridItem(.flexible())], spacing:12) {
                        FoodiesValueCard(icon:"leaf.fill",          title:"Fresh Daily",    color:Color(red:0.18,green:0.62,blue:0.28))
                        FoodiesValueCard(icon:"heart.fill",         title:"Made with Love", color:.red)
                        FoodiesValueCard(icon:"mappin.circle.fill", title:"Locally Sourced",color:Color("AccentColor"))
                        FoodiesValueCard(icon:"person.2.fill",      title:"Community",      color:.blue)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Our Story")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FoodiesSectionBlock: View {
    let title: String; let icon: String; let content: String
    var body: some View {
        VStack(alignment:.leading, spacing:10) {
            HStack(spacing:8) {
                Image(systemName:icon).foregroundColor(Color("AccentColor"))
                Text(title).font(.system(size:18,weight:.bold,design:.rounded))
            }
            Text(content).font(.body).foregroundColor(.secondary).lineSpacing(4)
        }
        .padding(16).background(Color(.systemGray6)).cornerRadius(14)
    }
}

struct FoodiesValueCard: View {
    let icon: String; let title: String; let color: Color
    var body: some View {
        VStack(spacing:8) {
            Image(systemName:icon).font(.title).foregroundColor(color)
            Text(title).font(.system(size:13,weight:.semibold,design:.rounded)).multilineTextAlignment(.center)
        }
        .frame(maxWidth:.infinity).padding(14)
        .background(Color(.systemBackground)).cornerRadius(14)
        .shadow(color:.black.opacity(0.06), radius:4, y:2)
    }
}

#Preview { NavigationStack { AboutView() } }
