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

extension Enum: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append(self.name + " ")
    }
}

extension Number: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("\(self.int)")
        if let fraction = self.fraction {
            text.append(".\(fraction)")
        }
        if let exponent = self.exponent {
            text.append("e\(exponent)")
        }
    }
}

extension List: CodeType {
    func code(inout text: [String], tabs: Int) {
        // TODO -- check.  is this right?
        text.append("[\n")
        for val in self.values {
            text.append(indent(tabs + 1))
            val.code(&text, tabs: tabs + 1)
            text.append("\n")
        }
        text.append(indent(tabs) + "]")
    }
}

extension Object: CodeType {
    func code(inout text: [String], tabs: Int) {
        // TODO check. is this right?
        text.append("{\n")
        for keyval in keyvals {
            text.append(indent(tabs + 1))
            keyval.code(&text, tabs: tabs + 1)
            text.append("\n")
        }
        text.append(indent(tabs) + "}")
    }
}

extension Value: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case let .Boolean_(bool):
            text.append("\(bool)")
        case let .Enum_(value):
            value.code(&text, tabs: tabs)
        case let .Number_(number):
            number.code(&text, tabs: tabs)
        case let .List_(list):
            list.code(&text, tabs: tabs)
        case let .Object_(object):
            object.code(&text, tabs: tabs)
        case let .String_(string):
            text.append("\"\(string)\"")
        case let .Variable_(variable):
            variable.code(&text, tabs: tabs)
        }
    }

}

extension TypeCondition: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("on ")
        self.namedType.code(&text, tabs: tabs)
    }
}

extension Alias: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("\(self.name): ")
    }
}

extension Field: CodeType {
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
            text.append(") ")
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
        text.append(" ")
    }
}

extension FragmentSpread: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("... ")
        self.fragmentName.code(&text, tabs: tabs)
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
    }
}

extension InlineFragment: CodeType {
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
        case let .Field_(field):
            field.code(&text, tabs: tabs)
        case let .FragmentSpread_(fragmentSpread):
            fragmentSpread.code(&text, tabs: tabs)
        case let .InlineFragment_(inlineFragment):
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
        self.fragmentName.code(&text, tabs: tabs)
        self.typeCondition.code(&text, tabs: tabs)
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
        self.selectionSet.code(&text, tabs: tabs)
    }
}

extension OperationType: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append(self.rawValue + " ")
    }
}

extension NamedType: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append(name)
        text.append(" ")
    }
}

extension ListType: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("[")
        type.code(&text, tabs: tabs)
        text.append("]")
    }
}

extension Type: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self.type {
        case let .Left(namedType):
            namedType.code(&text, tabs: tabs)
        case let .Right(listType):
            listType.code(&text, tabs: tabs)
        }
        if self.isNonNull {
            text.append("!")
        }
    }
}

extension DefaultValue: CodeType {
    func code(inout text: [String], tabs: Int) {
        text.append("= ")
        self.value.code(&text, tabs: tabs)
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
                text.append(", ")
            }
            text.append(") ")
        }
        for directive in self.directives {
            directive.code(&text, tabs: tabs)
        }
        self.selectionSet.code(&text, tabs: tabs)
    }
}

extension Definition: CodeType {
    func code(inout text: [String], tabs: Int) {
        switch self {
        case let .Fragment_(fragment):
            fragment.code(&text, tabs: tabs)
        case let .Operation_(operation):
            operation.code(&text, tabs: tabs)
        case let .SelectionSet_(selectionSet):
            selectionSet.code(&text, tabs: tabs)
        }
    }
}

extension Document: CodeType {
    func code(inout text: [String], tabs: Int) {
        for definition in self.definitions {
            definition.code(&text, tabs: tabs)
            text.append("\n")
        }
    }
}
