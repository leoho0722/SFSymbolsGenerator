//
//  FileWriter.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/2.
//

import Foundation

class FileWriter: NSObject {
    
    private let outputPath: String = "SFSymbols+Enum.swift"
    
    func write(with data: String) {
        do {
            let fileManager = FileManager.default
            
            let currentDirectory = fileManager.currentDirectoryPath
            print("當前目錄：", currentDirectory)
            let url = URL(fileURLWithPath: currentDirectory + "/" + outputPath)
            
            // 判斷指定路徑下，檔案是否存在，不存在就新增一個
            if !fileManager.fileExists(atPath: outputPath) {
                fileManager.createFile(atPath: outputPath, contents: nil)
            }
            
            let fileHandle = try FileHandle(forWritingTo: url)
            
            // 將字串轉換為 Data
            if let data = data.data(using: .utf8) {
                // 開始寫檔
                fileHandle.write(data)
                
                // 關閉檔案
                fileHandle.closeFile()
                
                print("寫入成功：\(outputPath)")
            }
        } catch {
            print("寫入失敗，錯誤：\(error)")
        }
    }
}
