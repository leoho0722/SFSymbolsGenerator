//
//  FileWriter.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

class FileWriter: NSObject {
    
    private let fileManager = FileManager.default
    
    /// 檔案寫入
    /// - Parameters:
    ///   - data: 要寫入的檔案
    ///   - filename: 輸出的檔案名稱
    ///   - filepath: 輸出的檔案路徑
    func write(with data: String, and filename: String, to filepath: String) {
        let type = ".swift"
        let file = filename + type
        do {
            let currentDirectory = fileManager.currentDirectoryPath
            let tempPath = currentDirectory + "/" + filename + type
            let tempURL = URL(fileURLWithPath: tempPath)
            
            // 判斷指定路徑下，檔案是否存在，不存在就新增一個，存在就進行複寫
            if !fileManager.fileExists(atPath: file) {
                fileManager.createFile(atPath: file, contents: nil)
            }
            
            let fileHandle = try FileHandle(forWritingTo: tempURL)
            
            // 將字串轉換為 Data
            if let data = data.data(using: .utf8) {
                // 開始寫檔
                fileHandle.write(data)
                
                // 關閉檔案
                fileHandle.closeFile()
                
                #if DEBUG
                print("成功：\(file)")
                #else
                print("Success: \(file)")
                #endif
                
                let destinationPath = filepath + "/" + file // 目標要儲存的路徑
                #if DEBUG
                print(destinationPath)
                #endif
                if !fileManager.fileExists(atPath: destinationPath) {
                    // 不存在的話...
                    #if DEBUG
                    print("指定的路徑下不存在檔案")
                    #endif
                    try fileManager.moveItem(atPath: tempPath, toPath: destinationPath)
                } else {
                    // 存在的話...
                    #if DEBUG
                    print("指定的路徑下存在檔案")
                    #endif
                    try fileManager.removeItem(atPath: destinationPath)
                    #if DEBUG
                    print("先移除舊檔案成功")
                    #endif
                    fileManager.createFile(atPath: destinationPath, contents: data)
                    #if DEBUG
                    print("再建立新檔案成功")
                    #endif
                }
            }
        } catch {
            #if DEBUG
            print("錯誤：\(error)")
            #else
            print("Error: \(error)")
            #endif
        }
    }
}
