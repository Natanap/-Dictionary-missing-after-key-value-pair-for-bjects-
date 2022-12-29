//
//  main.swift
//  PbxprojFixer
//
//  Created by Natanael Alves Pereira on 29/12/22.
//

/*
  Este arquivo executavel se refere ao bug encontrado ao realizar o merge de um projeto grande.
 
  This executable file refers to the bug encountered when merging a large project.
 
  [!] Dictionary missing ';'after key-value pair for öbjects", found ""(Nanaimo::Reader::ParseError)
 
    rootObject
 
 */

import Foundation

/*
 
    Modifique o caminho do pbxproject na linha 31 e aponte para seu projeto. Exemplo a seguir:
 
    /Users/Exemplo/Documents/projects/SeuProjeto.xcodeproj/project.pbxproj
    
    Modify pbxproject path on line 31 and point to your project. Example to follow:
    
    /Users/Example/Documents/projects/YourProject.xcodeproj/project.pbxproj
 
    Para exercutar aperte command + R
 
    To exercise press command + R
*/

let pathToPbxproj = "/Users/Exemplo/Documents/projects/SeuProjeto.xcodeproj/project.pbxproj"

func readFile(_ path: String) {
    errno = 0
    if freopen(path, "r", stdin) == nil {
        perror(path)
        return
    }

    let regexBegin = try! NSRegularExpression(pattern: ".*\\s\\/.\\s.*\\s.*\\/\\s=\\s\\{$")
    let regexClose = try! NSRegularExpression(pattern: "\\s*\\}\\;")
    
    let regexBeginParentesis = try! NSRegularExpression(pattern: ".*\\s=\\s\\($")
    let regexCloseParentesis = try! NSRegularExpression(pattern: "\\s*\\)\\;")
    
    var lineNumber = 0
    var opendBracket = false
    var opendParentesis = false
    while let line = readLine() {
        let range = NSRange(location: 0, length: line.utf16.count)
        if regexBegin.firstMatch(in: line, options: [], range: range) != nil {
            if opendBracket {
                print(line)
                print("Missing bracket at line number: \(lineNumber)")
                return
            }
            opendBracket = true
        }
        if opendBracket
            && regexClose.firstMatch(in: line, options: [], range: range) != nil {
            opendBracket = false
        }
        if regexBeginParentesis.firstMatch(in: line, options: [], range: range) != nil {
            if opendParentesis {
                print(line)
                print("Missing parentesis at line number: \(lineNumber)")
                return
            }
            opendParentesis = true
        }
        if opendParentesis
            && regexCloseParentesis.firstMatch(in: line, options: [], range: range) != nil {
            opendParentesis = false
        }
        lineNumber += 1
    }
    
    print("Não foi encontrada nenhuma inconsistência.")
    print("Varredura concluída.")
}

print("Varredura iniciada...")
readFile(pathToPbxproj)

