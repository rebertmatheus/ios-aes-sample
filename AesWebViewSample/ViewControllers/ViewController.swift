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
    
    let name: String = "John the Ripper"
    let id: String = "11999999999"
    let type: String = "Default"
    let keyString = "ASERTYUJHGFDVB1234567890*h%gDE3@"
    var iv: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = mainView
        self.delegate = mainView
        
        let input = "\(name)\(id)\(type)"
        iv = generateRandomIV()
        if let encryptedInput = aesEncrypt(input: input, keyString: keyString, iv: iv) {
            delegate?.updateAesResult(result: encryptedInput)
            print("Retorno Encrypt: \(encryptedInput)")
            
            print("------Iniciando Decrypt------")
            if let decryptedData = aesDecrypt(encryptedBase64String: encryptedInput, keyString: keyString, iv: iv) {
                print("Retorno Decrypt: \(decryptedData)")
            }
        }
        
    }
    
    private func aesEncrypt(input: String, keyString: String, iv: [UInt8]) -> String? {
        if let keyData = keyString.data(using: .utf8) {
            let key: [UInt8] = keyData.bytes
            do {
                let encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(Array(input.utf8))
                let encryptedData = Data(encrypted)
                print("Input: \(input)")
                print("key: \(key)")
                print("IV: \(iv)")
                return encryptedData.base64EncodedString()
            } catch {
                debugPrint("Error: \(error)")
                return nil
            }
        } else {
            print("Erro ao converter a string para dados.")
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
            iv[i] = UInt8.random(in: UInt8.min..<UInt8.max)
        }
        return iv
    }
}
