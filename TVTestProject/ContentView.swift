//
//  ContentView.swift
//  TVTestProject
//
//  Created by admin on 10.02.2021.
//

import SwiftUI

enum Windows {
    case auth
    case home
}


struct ContentView: View {
    @State
    var windows: Windows = .auth
    var body: some View {
        switch windows {
            case .auth:
                return AnyView(AuthView(windows: self.$windows))
            case .home:
                return AnyView(HomeView(windows: self.$windows))
        }
    }
}

struct AuthView: View {
    @Binding
    var windows: Windows
    @Namespace
    private var namespace
    @State
    var inFocus: Bool = false
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack {
                TextField("", text: .constant("Login"))
                    //Данный модификатор устанавливает какой объект будет сфокусирован по-дефолту
                    //Но для того чтоб он работал еще нужен модификатор focusScope
                    .prefersDefaultFocus(in: namespace)
                SecureField("", text: .constant("Pass"))
                    .textFieldStyle(PlainTextFieldStyle())
                //Тут так же как и с часами чтобы свободно менять дизайн нужно указать style
                //Но у TVOS есть такая функция как фокусировка
                //Она срабатывает когда наводишь на какой-нибуд объект
                //У нас это кнопка
                //Для того чтобы ее убрать нужно у модификатора focusable поставить true
                Button(action: {
                    self.windows = .home
                }) {
                    Text("Go")
                        .foregroundColor(self.inFocus ? .yellow : .black)
                }
                .background(self.inFocus ? Color.black : Color.yellow)
                .scaleEffect(self.inFocus ? 1.2 : 1)
                .animation(.easeInOut, value: self.inFocus)
                //Вот так
//                .focusable(true)
                // Но в задании может быть сказано что при фокусировке должно что-то происходить
                // Для это нужно создать переменную и присваивать ей состояния фокусировки
                // В данном случае я меня цвет текста, заднего фона и увеличиваю размер
                
                
                // Но тут у нас есть проблема если делать кастомную фокусировку то
                // не работает action в кнопке но я придумал лайфхак
                // можно использовать модификатор onLongPressGesture и выставить задержку минимальную
                // и туда перенести действия
                .focusable(true) { newState in
                    inFocus = newState
                }
                .onLongPressGesture(minimumDuration: 0.01) {
                    self.windows = .home
                }
                .buttonStyle(PlainButtonStyle())
                
            }.focusScope(namespace)
        }
    }
}

struct HomeView: View {
    @Binding
    var windows: Windows
    
    var list: [String] = ["1","2","3","4","5","6","5fasd","fads","2","3","4","5","6","5fasd","fads","2","3","4","5","6","5fasd","fads","2","3","4","5","6","5fasd","fads","2","3","4","5","6","5fasd","fads"]
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack {
                //Скролл работает
                ScrollView(.vertical) {
                    ForEach(self.list, id: \.self) { item in
                        Button(action: {
                            self.windows = .auth
                        }) {
                            Text(item)
                        }
                    }
                }
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(self.list, id: \.self) { item in
                            Button(action: {
                                self.windows = .auth
                            }) {
                                Text(item)
                            }
                        }
                    }
                }
            }
        }
    }
}
