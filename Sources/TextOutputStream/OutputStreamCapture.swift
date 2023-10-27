//
//  OutputStreamCapture.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

class OutputStreamCapture {
    
    var capturedOutput: String = ""

    func capturePrint(_ items: Any...,
                      separator: String = " ",
                      terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator) + terminator
        capturedOutput += output // 將輸出串接到取得的字串中
    }
}
