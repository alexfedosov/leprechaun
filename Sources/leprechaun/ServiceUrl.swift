//
// Created by Alexander Fedosov on 6.11.2020.
//

import Foundation

enum Language: String {
  case ru = "ru-ru"
  case en = "en-us"
  case de = "de-de"
  case es = "es-es"
}

enum ServiceUrl {
  case `operator`(name: String, language: Language)

  func url() -> URL {
    switch self {
    case .operator(let name, let language):
      guard let url = URL(string: "https://www.ubisoft.com/\(language.rawValue)/game/rainbow-six/siege/game-info/operators/\(name)") else {
        fatalError("Coudn't resolve valid url for operator \(name) and \(language)")
      }
      return url
    }
  }
}

