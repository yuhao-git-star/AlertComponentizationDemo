//
//  ContentView.swift
//  AlertComponentizationDemo
//
//  Created by 陳囿豪 on 2019/9/13.
//  Copyright © 2019 yasuoyuhao. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var show = false
    @State var viewState = CGSize.zero
    
    var body: some View {
        ZStack {
            
            TitleView()
                .blur(radius: show ? 20 : 0)
                .animation(.default)
            
            CardBottomView()
                .blur(radius: show ? 20 : 0)
                .animation(.default)
            
            CardView()
                .background(Color("background9"))
                .cornerRadius(10)
                .shadow(radius: 20)
                .offset(x: 0, y: -40)
                .scaleEffect(0.85)
                .rotationEffect(Angle(degrees: show ? 15 : 0))
                //                .rotation3DEffect(Angle(degrees: show ? 50 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.hardLight)
                .animation(.easeInOut(duration: 0.7))
                .offset(x: viewState.width, y: viewState.height)
            
            CardView()
                .background(Color("background8"))
                .cornerRadius(10)
                .shadow(radius: 20)
                .offset(x: 0, y: -20)
                .scaleEffect(0.9)
                .rotationEffect(Angle(degrees: show ? 10 : 0))
                //                .rotation3DEffect(Angle(degrees: show ? 40 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.hardLight)
                .animation(.easeInOut(duration: 0.5))
                .offset(x: viewState.width, y: viewState.height)
            
            
            CertificateView()
                .offset(x: viewState.width, y: viewState.height)
                .scaleEffect(0.95)
                .rotationEffect(Angle(degrees: show ? 5 : 0))
                //                .rotation3DEffect(Angle(degrees: show ? 30 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
                .animation(.spring())
                .onTapGesture {
                    // self.show.toggle()
                    _ = MessageService.shared.showTableSelectionView(title: "餐點", description: "請選擇你的餐點", data: FoodKind.self).done { (kind) in
                        
                        print("你選擇了: \(kind.rawValue)")
                        
                        // to something for your seletion
                        switch kind {
                            
                        case .steak:
                            ()
                        case .chickenChops:
                            ()
                        case .italianNoodles:
                            ()
                        case .hainanChickenRice:
                            ()
                        }
                    }.catch({ (error) in
                        if let error = error as? UIError {
                            print(error.localizedDescription)
                        }
                    })
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.viewState = value.translation
                        self.show = true
                }
                .onEnded { value in
                    self.viewState = CGSize.zero
                    self.show = false
                }
            )
        }
    }
}

struct CertificateView: View {
    var body: some View {
        return VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("yasuoyuhao")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("accent"))
                        .padding(.top)
                    Text("Alert Demo")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
            
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 340.0, height: 150, alignment: .center)
                .clipped()
        }
        .frame(width: 340.0, height: 220)
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}


struct CardView: View {
    var body: some View {
        return VStack {
            Text("Card Back")
        }
        .frame(width: 300, height: 220)
        .cornerRadius(10)
        .shadow(radius: 20)
        .offset(x: 0, y: -20)
        
    }
}

struct TitleView : View {
    var body: some View {
        return VStack {
            HStack {
                Text("Alert Demo")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
            }
            Image("Illustration5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 210.0, height: 210.0, alignment: .center)
                .onTapGesture {
                    _ = MessageService.shared.showTableSelectionView(title: "英雄", description: "請選擇您的英雄職位", data: HeroKind.self).done { (hero) in
                        print("你選擇了: \(hero.rawValue)")
                        
                        switch hero {
                            
                        case .fighter:
                            ()
                        case .assassin:
                            ()
                        case .mage:
                            ()
                        case .shooter:
                            ()
                        case .support:
                            ()
                            
                        }
                    }.catch({ (error) in
                        if let error = error as? UIError {
                            print(error.localizedDescription)
                        }
                    })
            }
            
            Spacer()
        }
        .padding()
    }
}

struct CardBottomView : View {
    var body: some View {
        return VStack(spacing: 20.0) {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
            Text("請點擊卡片、數據圖查看提示效果")
                .lineLimit(10)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
        .offset(y: 600)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
