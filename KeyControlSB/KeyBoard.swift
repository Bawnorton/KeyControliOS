//
//  KeyBoard.swift
//  KeyControl
//
//  Created by Benjamin Norton on 2021-12-03.
//

import Foundation
import SwiftUI

struct Device {
    static let keyWidthConst: Float = 896.0
    static let keyHeightConst: Float = 414.0
    
    static let width = Float(UIScreen.main.bounds.width)
    static let height = Float(UIScreen.main.bounds.height)
    
    static func getAspectRatio() -> CGFloat {
        return CGFloat(width / height)
    }
}

struct KeyBoard: Identifiable {
    let id = UUID()
    let keyRows: [KeyRow]
}

struct KeyRow: Identifiable {
    let id = UUID()
    
    let keyNum: Int
    let keys: [Key]
}


struct Key: Identifiable {
    let id = UUID()
    
    let display: String
    let actionID: Int
    let width: Float
}

struct KeyBoardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(keyboard.keyRows) { keyRow in
                KeyRowView(keyRow: keyRow).body
            }
        }.frame(alignment: .top)
            .padding()
//          For Testing
///            .overlay(
///                RoundedRectangle(cornerRadius: 12)
///                    .stroke(Color.green, lineWidth: 2)
///            )
    }
}

struct KeyRowView: View {
    var keyRow: KeyRow
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(keyRow.keys) { key in
                KeyView(key: key).body
            }
        }
    }
}

struct KeyView: View {
    var key: Key
    
    var body: some View {
        Button(action: {}) {
            Text(key.display)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.system(size: CGFloat(12 * Device.width / Device.keyWidthConst)))
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }.pressAction {
            ViewController().onPress(actionID: key.actionID)
        } onRelease: {
            ViewController().onRelease(actionID: key.actionID)
        }.frame(width: CGFloat(key.width * 50 * Device.width / Device.keyWidthConst),
                height: CGFloat(49 * Device.width / Device.keyWidthConst),
                alignment: .center)
    }
}

struct PressAction: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(
                minimumDistance: 0)
                .onChanged({ _ in
                    onPress()
                })
                .onEnded({ _ in
                    onRelease()
                })
            )
    }
}

extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressAction(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

var keyboard: KeyBoard = KeyBoard(keyRows: [
    KeyRow(keyNum: 14, keys: [
        Key(display: "esc", actionID: 0, width: 1.3),
        Key(display: "f1", actionID: 1, width: 1),
        Key(display: "f2", actionID: 2, width: 1),
        Key(display: "f3", actionID: 3, width: 1),
        Key(display: "f4", actionID: 4, width: 1),
        Key(display: "f5", actionID: 5, width: 1),
        Key(display: "f6", actionID: 6, width: 1),
        Key(display: "f7", actionID: 7, width: 1),
        Key(display: "f8", actionID: 8, width: 1),
        Key(display: "f9", actionID: 9, width: 1),
        Key(display: "f10", actionID: 10, width: 1),
        Key(display: "f11", actionID: 11, width: 1),
        Key(display: "f12", actionID: 12, width: 1),
        Key(display: "⏏", actionID: 13, width: 1)
      ]),
    KeyRow(keyNum: 14, keys: [
        Key(display: "§", actionID: 14, width: 1),
        Key(display: "1", actionID: 15, width: 1),
        Key(display: "2", actionID: 16, width: 1),
        Key(display: "3", actionID: 17, width: 1),
        Key(display: "4", actionID: 18, width: 1),
        Key(display: "5", actionID: 19, width: 1),
        Key(display: "6", actionID: 20, width: 1),
        Key(display: "7", actionID: 21, width: 1),
        Key(display: "8", actionID: 22, width: 1),
        Key(display: "9", actionID: 23, width: 1),
        Key(display: "0", actionID: 24, width: 1),
        Key(display: "-", actionID: 25, width: 1),
        Key(display: "+", actionID: 26, width: 1),
        Key(display: "⌫", actionID: 27, width: 1.3)
      ]),
    KeyRow(keyNum: 13, keys: [
        Key(display: "tab", actionID: 28, width: 1.3),
        Key(display: "q", actionID: 29, width: 1),
        Key(display: "w", actionID: 30, width: 1),
        Key(display: "e", actionID: 31, width: 1),
        Key(display: "r", actionID: 32, width: 1),
        Key(display: "t", actionID: 33, width: 1),
        Key(display: "y", actionID: 34, width: 1),
        Key(display: "u", actionID: 35, width: 1),
        Key(display: "i", actionID: 36, width: 1),
        Key(display: "o", actionID: 37, width: 1),
        Key(display: "p", actionID: 38, width: 1),
        Key(display: "[", actionID: 39, width: 1),
        Key(display: "]", actionID: 40, width: 1),
        Key(display: "\\", actionID: 41, width: 1)
      ]),
    KeyRow(keyNum: 13, keys: [
        Key(display: "⇪", actionID: 42, width: 1.6),
        Key(display: "a", actionID: 43, width: 1),
        Key(display: "s", actionID: 44, width: 1),
        Key(display: "d", actionID: 45, width: 1),
        Key(display: "f", actionID: 46, width: 1),
        Key(display: "g", actionID: 47, width: 1),
        Key(display: "h", actionID: 48, width: 1),
        Key(display: "j", actionID: 49, width: 1),
        Key(display: "k", actionID: 50, width: 1),
        Key(display: "l", actionID: 51, width: 1),
        Key(display: ";", actionID: 52, width: 1),
        Key(display: "'", actionID: 53, width: 1),
        Key(display: "⏎", actionID: 54, width: 1.85)
      ]),
    KeyRow(keyNum: 13, keys: [
        Key(display: "⇧", actionID: 55, width: 1.25),
        Key(display: "`", actionID: 56, width: 1),
        Key(display: "z", actionID: 57, width: 1),
        Key(display: "x", actionID: 58, width: 1),
        Key(display: "c", actionID: 59, width: 1),
        Key(display: "v", actionID: 60, width: 1),
        Key(display: "b", actionID: 61, width: 1),
        Key(display: "n", actionID: 62, width: 1),
        Key(display: "m", actionID: 63, width: 1),
        Key(display: ",", actionID: 64, width: 1),
        Key(display: ".", actionID: 65, width: 1),
        Key(display: "/", actionID: 66, width: 1),
        Key(display: "⇧", actionID: 67, width: 2.2)
      ]),
    KeyRow(keyNum: 7, keys: [
        Key(display: "⌃", actionID: 68, width: 1.4),
        Key(display: "⌥", actionID: 69, width: 1.4),
        Key(display: "⌘", actionID: 70, width: 1.4),
        Key(display: "space", actionID: 71, width: 7.03),
        Key(display: "⌘", actionID: 72, width: 1.4),
        Key(display: "⌥", actionID: 73, width: 1.4),
        Key(display: "⌃", actionID: 74, width: 1.4)
      ])
])
