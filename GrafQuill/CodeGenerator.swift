//
//  CodeGenerator.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation


protocol CodeType {
    func code(inout text: [String], tabs: Int)
}

func indent(tabs: Int) -> String {
    return String(count: tabs, repeatedValue: Character("\t"))
}

extension Variable: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("$" + self.name)
    }
}

extension Argument: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("\(self.name): ")
        self.value.code(&text, tabs: tabs)
    }
}

extension Directive: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("@\(self.name)")
        if self.args.count > 0 {
            text.append("(")
            for arg in self.args {
                arg.code(&text, tabs: tabs)
            }
        }
        text.append(" ")
    }
}

extension Value: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case .BooleanValue(let bool):
            text.append("\(bool)")
        case .EnumValue(let string):
            text.append(string)
        case let .FloatValue(int, decimal):
            text.append("\(int).\(decimal)")
        case let .IntValue(int):
            text.append("\(int)")
        case let .ListValue(vals):
            text.append("[\n")
            for val in vals {
                text.append(indent(tabs + 1))
                val.code(&text, tabs: tabs + 1)
                text.append("\n")
            }
            text.append(indent(tabs) + "]")
        case let .ObjectValue(keyvals):
            text.append("{\n")
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
    }

}

extension TypeCondition: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("on \(self.namedType) ")
    }
}

extension Alias: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("\(self.name): ")
    }
}

extension SelectionField: CodeType {
    func code(inout text: [String], tabs: Int) {
        if let alias = self.alias {
            alias.code(&text, tabs: tabs)
        }
        text.append("\(self.name) ")
        if self.arguments.count > 0 {
            text.append("(")
            for arg in self.arguments {
                arg.code(&text, tabs: tabs)
            }
            text.append(")")
        }
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
        if let selectionSet = self.selectionSet {
            selectionSet.code(&text, tabs: tabs)
        }
    }
}

extension FragmentName: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append(self.name)
    }
}

extension SelectionFragmentSpread: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("... ")
        self.fragmentName.code(&text, tabs: tabs)
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
    }
}

extension SelectionInlineFragment: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("... ")
        if let typeCondition = self.typeCondition {
            typeCondition.code(&text, tabs: tabs)
        }
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
        self.selectionSet.code(&text, tabs: tabs)
    }
}

extension Selection: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case let .Field(field):
            field.code(&text, tabs: tabs)
        case let .FragmentSpread(fragmentSpread):
            fragmentSpread.code(&text, tabs: tabs)
        case let .InlineFragment(inlineFragment):
            inlineFragment.code(&text, tabs: tabs)
        }
    }
}

extension SelectionSet: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("{\n")
        for selection in self.selections {
            text.append(indent(tabs + 1))
            selection.code(&text, tabs: tabs + 1)
            text.append("\n")
        }
        text.append(indent(tabs) + "}")
    }
}

extension FragmentDefinition: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("fragment \(self.fragmentName) ")
        self.typeCondition.code(&text, tabs: tabs)
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
        self.selectionSet.code(&text, tabs: tabs)
    }
}

extension OperationType: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append(self.rawValue)
    }
}

extension ConstKeyVal: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("\(self.name):")
        self.value.code(&text, tabs: tabs)
    }
}

extension ConstValue: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case .BooleanValue(let bool):
            text.append("\(bool)")
        case .EnumValue(let string):
            text.append(string)
        case let .FloatValue(int, decimal):
            text.append("\(int).\(decimal)")
        case let .IntValue(int):
            text.append("\(int)")
        case let .ConstListValue(vals):
            text.append("[\n")
            for val in vals {
                text.append(indent(tabs + 1))
                val.code(&text, tabs: tabs + 1)
                text.append("\n")
            }
            text.append(indent(tabs) + "]")
        case let .ConstObjectValue(keyvals):
            text.append("{\n")
            for keyval in keyvals {
                text.append(indent(tabs + 1))
                keyval.code(&text, tabs: tabs + 1)
                text.append("\n")
            }
            text.append(indent(tabs) + "}")
        case let .StringValue(string):
            text.append("\"\(string)\"")
        }
    }
}

extension Type: CodeType {
    func code(inout text: [String], tabs: Int) {
        let addBang: Bool
        switch self {
        case let .ListType(type, isNonNull):
            text.append("[")
            type.code(&text, tabs: tabs)
            text.append("]")
            addBang = isNonNull
        case let .NamedType(name, isNonNull):
            text.append(name)
            addBang = isNonNull
        }
        if addBang {
            text.append("!")
        }
    }
}

extension VariableDefinition: CodeType {
    func code(inout text: [String], tabs: Int) {
        self.variable.code(&text, tabs: tabs)
        text.append(": ")
        self.type.code(&text, tabs: tabs)
        if let defaultValue = self.defaultValue {
            defaultValue.code(&text, tabs: tabs)
        }
    }
}

extension OperationDefinition: CodeType {
    func code(inout text: [String], tabs: Int) {
        self.operationType.code(&text, tabs: tabs)
        if let name = self.name {
            text.append("\(name) ")
        }
        if self.variableDefinitions.count > 0 {
            text.append("(")
            for variableDefinition in self.variableDefinitions {
                variableDefinition.code(&text, tabs: tabs)
            }
            text.append(")")
        }
    }
}

extension Definition: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case let .Fragment(fragmentDefinition):
            fragmentDefinition.code(&text, tabs: tabs)
        case let .Operation(operationDefinition):
            operationDefinition.code(&text, tabs: tabs)
        case let .SelectionSetDefinition(selectionSet):
            selectionSet.code(&text, tabs: tabs)
        }
    }
}

extension Document: CodeType {
    func code(inout text: [String], tabs: Int) {
        for definition in self.definitions {
            definition.code(&text, tabs: tabs)
        }
    }
}
