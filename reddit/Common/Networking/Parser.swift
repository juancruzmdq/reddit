//
//  Parser.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Protocol to be implemented by a model that can be parsed after the service call finish
protocol Parseable {

    /// Class of the parser for this parseable element
    associatedtype ParserType: Parser
}

/// Protocol to be implemented by a class that can parse an API response to a Model object
protocol Parser {

    /// Class of the object returned by the parse
    associatedtype ParsedObject = Parseable

    /// Given a dictionary try tu parse it and return an instance of the class ParsedObject, if is not posible create the instance retun nil
    ///
    /// - Parameter dictionaryRepresentation: (key, value) dictionary
    /// - Returns: instance of ParsedObject
    static func parse(_ dictionaryRepresentation: [String: Any]) -> ParsedObject?
}
