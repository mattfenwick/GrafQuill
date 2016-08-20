//
//  CodeGeneratorFail.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/18/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

/*
func stuff(inout arr: [String]) -> Void {
    arr.append("abc")
}

func vars(var arr: [String]) {
    arr.append("def")
}

func run() {
    var x = ["3"]
    print("x: \(x)")
    stuff(&x)
    print("x: \(x)")
    vars(x)
    print("x: \(x)")
    vars(x)
    print("x: \(x)")
}
*/

/*
 protocol CodeGeneratorType {
 func newline()
 func addToken(token: String)
 func indent()
 func dedent()
 func generate() throws -> String
 }

 enum CodeAction {
 case Indent
 case Dedent
 case Newline
 case Token(String)
 }

 extension CodeAction: Equatable {}

 func ==(left: CodeAction, right: CodeAction) -> Bool {
 switch (left, right) {
 case (.Indent, .Indent):
 return true
 case (.Dedent, .Dedent):
 return true
 case (.Newline, .Newline):
 return true
 case let (.Token(left), .Token(right)):
 return left == right
 default:
 return false
 }
 }

 enum CodeGeneratorError: ErrorType {
 case InvalidIndentationLevel
 }

 enum Either<A, B> {
 case Left(A)
 case Right(B)
 }

 class Scope {
 let open: String?
 private var lines: [[Either<Scope, String>]]
 let close: String?
 init(open: String?, close: String?) {
 self.open = open
 self.lines = []
 self.close = close
 }
 func addLine(line: [Either<Scope, String>]) {
 lines.append(line)
 }
 private func addItem(item: Either<Scope, String>) {
 var lastLine: [Either<Scope, String>]
 if let last = lines.last {
 lastLine = last
 } else {
 lastLine = []
 addLine(lastLine)
 // do changes to `lastLine` end up in self.lines?  not 100% of Swift's semantics
 }
 lastLine.append(item)
 }
 func addToken(token: String) {
 addItem(.Right(token))
 }
 func addScope(scope: Scope) {
 addItem(.Left(scope))
 }
 }

 class CodeGenerator: CodeGeneratorType {
 private var actions = [CodeAction]()
 init() {}
 func newline() {
 actions.append(.Newline)
 }
 func indent() {
 actions.append(.Indent)
 }
 func dedent() {
 actions.append(.Dedent)
 }
 func addToken(token: String) {
 actions.append(.Token(token))
 }
 func generate() throws -> String {
 var buffer = [String]()
 var indentLevel = 0
 let lines = actions.split(allowEmptySlices: true, isSeparator: { $0 == CodeAction.Newline })
 for line in lines {
 //            buffer.append(indent(indentLevel))
 buffer.append("\n")
 }
 for action in actions {
 switch action {
 case .Indent:
 indentLevel += 1
 case .Dedent:
 indentLevel -= 1
 guard indentLevel >= 0 else {
 throw CodeGeneratorError.InvalidIndentationLevel
 }
 case .Newline:
 buffer.append("\n")
 //                actions.spl
 default:
 break
 }
 }
 return ""
 }
 }

 class CodeGenerator2: CodeGeneratorType {
 private var buffer = [String]()
 private var indentLevel = 0
 init() {}
 func newline() {

 }
 func addToken(token: String) {

 }
 func indent() {
 indentLevel += 1
 }
 func dedent() {
 indentLevel -= 1
 }
 private func indent() -> String {
 return String(count: indentLevel, repeatedValue: Character("\t"))
 }
 func generate() -> String {
 return buffer.joinWithSeparator("")
 }
 }
*/

// Variable
/*    func code(scope: Scope) {
 scope.addToken("$\(self.name)")
 }*/

// Argument
/*    func code(scope: Scope) {
 scope.addToken(self.name)
 self.value.code(scope)
 }*/

// Value
/*    func code(scope: Scope) {
 switch self {
 case .BooleanValue(let bool):
 scope.addToken("\(bool)")
 case .EnumValue(let string):
 scope.addToken(string)
 case let .FloatValue(int, decimal):
 scope.addToken("\(int).\(decimal)")
 case let .IntValue(int):
 scope.addToken("\(int)")
 case let .ListValue(vals):
 let newScope = Scope(open: "[", close: "]")
 for val in vals {
 val.code(newScope)
 }
 scope.addScope(newScope)
 case let .ObjectValue(keyvals):
 text.append("{\n")
 // TODO indentation? newline?
 for keyval in keyvals {
 text.append(indent(tabs + 1))
 keyval.code(&text, tabs: tabs + 1)
 text.append("\n")
 }
 text.append(indent(tabs) + "}")
 case let .StringValue(string):
 text.append("\"\(string)\"")
 case let .VariableValue(variable):
 variable.code(&text, tabs: tabs)
 }
 }*/