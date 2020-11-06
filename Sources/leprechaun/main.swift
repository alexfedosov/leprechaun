//
//  main.swift
//  R6Scraper
//
//  Created by Alexander Fedosov on 6.11.2020.
//
//

import Foundation
import ArgumentParser

struct LeprechaunOptions: ParsableArguments {
  @Option(help: ArgumentHelp("Operator name (or names separated by string)", valueName: "names"))
  var names: String

  static let supportedLanguages = [Language.en, .ru, .de, .es].map({ $0.rawValue }).joined(separator: ", ")
  @Option(help: ArgumentHelp("Choose language to use (en by default)",
      discussion: "Supported languages: \(supportedLanguages)",
      valueName: "language"))
  var language = Language.en.rawValue
}

let options = LeprechaunOptions.parseOrExit()

guard let lang = Language(rawValue: options.language) else {
  print("Unsupported language")
  exit(0)
}

options.names.split(separator: ",", omittingEmptySubsequences: true)
    .map({ $0.trimmingCharacters(in: .whitespaces) })
    .forEach({ name in
      do {
        print("---------------------------------------------")
        print("Loading data for \(name)")
        print("---------------------------------------------")
        let url = ServiceUrl.operator(name: name, language: lang)
        let operatorInfo = try Operator(url: url)
        print(operatorInfo)
        print("---------------------------------------------")
      } catch {
        print(error)
      }
    })
