//
//  ViewController.swift
//  AesWebViewSample
//
//  Created by Rebert Matheus Teixeira on 03/04/24.
//

import UIKit
import CryptoSwift

protocol ViewControllerDelegate: AnyObject {
    func updateAesResult(result:String)
}

final class ViewController: UIViewController {
    
    public weak var delegate: ViewControllerDelegate?

    let mainView: MainView = MainView()
    
    let number: String = "11111111111"
    let document: String = "48707475020"
    let type: String = "Default"
    let secret = "YOUR_SECRET_KEY"
    var iv: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = mainView
        self.delegate = mainView
        
        let data: [String: Any] = [
            "number": "\(number)",
            "document": "\(document)",
            "type": "\(type)"
        ]
        
        iv = generateRandomIV()
        if let encryptedInput = aesEncrypt(data: data, aesSecret: secret, iv: iv) {
            delegate?.updateAesResult(result: encryptedInput)
        }
    }
    
    private func aesEncrypt(data: [String: Any], aesSecret: String, iv: [UInt8]) -> String? {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                
                print("aesSecret.bytes: \(String(describing: aesSecret.bytes))")
                
                let encrypted = try AES(key: aesSecret.bytes, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(Array(jsonString.utf8))
                let encryptedData = Data(encrypted)

                print("encryptedData: \(String(describing: encrypted))")
                print("encryptedBASE64URL: \(String(describing: encryptedData.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")))")

                return encryptedData.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
            } catch {
                debugPrint("Error: \(error)")
                return nil
            }
    }
    
    private func aesDecrypt(encryptedBase64String: String, keyString: String, iv: [UInt8]) -> String? {
        if let keyData = keyString.data(using: .utf8),
           let encryptedData = Data(base64Encoded: encryptedBase64String) {
            let key = keyData.bytes
            do {
                let decrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encryptedData.bytes)
                if let decryptedString = String(bytes: decrypted, encoding: .utf8) {
                    return decryptedString
                } else {
                    print("Erro ao decodificar a string descriptografada.")
                    return nil
                }
            } catch {
                debugPrint("Erro durante a descriptografia: \(error)")
                return nil
            }
        } else {
            print("Erro ao converter a string para dados ou decodificar a string criptografada.")
            return nil
        }
    }
    
    private func generateRandomIV() -> [UInt8] {
        let ivSize = AES.blockSize
        var iv = [UInt8](repeating: 0, count: ivSize)
        for i in 0..<ivSize {
//            iv[i] = UInt8.random(in: UInt8.min..<UInt8.max)
            iv[i] = 0
        }
//        print("IV: \(String(describing: iv))")
        return iv
    }
}
