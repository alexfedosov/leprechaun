//
// Created by Alexander Fedosov on 6.11.2020.
//

import Foundation
import SwiftSoup

struct Operator {
  struct Stats {
    var title: String
    var value: Int8
  }

  var name: String = ""
  var iconUrl: String = ""
  var factionUrl: String = ""
  var side: String = ""
  var roles: [String] = []
  var stats: [Stats] = []
  var shortDescription: String
}

extension Operator.Stats: CustomDebugStringConvertible {
  public var debugDescription: String {
    let rating = Array(1...3).map({ $0 <= Int(value) ? "[x]" : "[ ]" }).joined()
    return "\(title) (\(value)): \t \(rating)"
  }
}

extension Operator: CustomDebugStringConvertible {
  var iconDescription: String {
    get {
      [
        "icon: \(iconUrl)",
        "faction: \(factionUrl)",
      ].joined(separator: "\n")
    }
  }

  var statsDescription: String {
    get {
      let statsArray = stats.map {
        $0.debugDescription
      }
      let maxLength = statsArray.map({ $0.count }).max() ?? 0
      return statsArray.map({ Array(repeating: " ", count: maxLength - $0.count).joined() + $0 }).joined(separator: "\n")
    }
  }
  var debugDescription: String {
    [
      name, iconDescription,
      side,
      roles.joined(separator: ", "),
      statsDescription,
      shortDescription
    ].joined(separator: "\n")
  }
}

extension Operator {
  init(url: ServiceUrl) throws {
    let html = try String(contentsOf: url.url())
    let doc: Document = try SwiftSoup.parse(html)
    let images = try doc.select("div.operator__header__icons__names img")
    for image in images {
      let alt = try image.attr("alt").components(separatedBy: " ").last
      let src = try image.attr("src")
      switch alt {
      case .some(let alt) where alt == "icon": iconUrl = src
      case .some(let alt) where alt == "faction": factionUrl = src
      default: print("unknown or nil alt)")
      }
    }

    if let name = try? doc.select("div.operator__header__icons__names h1").first()?.text() {
      self.name = name
    }

    if let side = try? doc.select("div.operator__header__side__detail span").first()?.text() {
      self.side = side
    }

    let roles = try doc.select("div.operator__header__roles span.operator__header__roles")
    self.roles = try roles.map {
      try $0.text().replacingOccurrences(of: ",", with: "")
    }

    let stats = try doc.select("div.operator__header__stat")
    self.stats = try stats.map { s in
      let title = try s.select("div.operator__header__stat__title span").first()!.text()
      let stars = try s.select("div.is-active").array().count
      return Stats(title: title, value: Int8(stars))
    }

    shortDescription = try doc.select("div.promo__wrapper__content p").compactMap({
      do {
        return try $0.text()
      } catch {
        return nil
      }
    }).joined(separator: "\n")
  }
}
