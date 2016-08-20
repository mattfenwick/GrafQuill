//
//  Model.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

enum ModelError: ErrorType {
    case IllegalName(name: String)
}

// TODO add Name struct in order to house name validation logic (disallowed chars)

struct Variable {
    let name: String // TODO check for allowed, disallowed characters
}

struct Argument {
    let name: String
    let value: Value
}

typealias KeyVal = Argument

struct ConstKeyVal {
    let name: String
    let value: ConstValue
}

struct Directive {
    let name: String
    let args: [Argument]
}

indirect enum Type {
    case NamedType(name: String, isNonNull: Bool)
    case ListType(type: Type, isNonNull: Bool)
}

enum ConstValue {
    case IntValue(int: Int)
    case FloatValue(int: Int, decimal: Int)
    case StringValue(string: String)
    case BooleanValue(bool: Bool)
    case EnumValue(string: String)
    case ConstListValue(values: [ConstValue]) // interesting that this doesn't force the enum to be labeled 'indirect'
    case ConstObjectValue(keyvals: [ConstKeyVal])
}

indirect enum Value {
    case IntValue(int: Int)
    case FloatValue(int: Int, decimal: Int)
    case StringValue(string: String)
    case BooleanValue(bool: Bool)
    case EnumValue(string: String)
    case ListValue(values: [Value])
    case ObjectValue(keyvals: [KeyVal])
    case VariableValue(variable: Variable)
}

struct EnumValue {
    static let disallowedNames = Set(["true", "false", "null"])
    let name: String
    init(name: String) throws {
        if EnumValue.disallowedNames.contains(name) {
            throw ModelError.IllegalName(name: name)
        }
        self.name = name
    }
}

typealias DefaultValue = ConstValue

struct VariableDefinition {
    let variable: Variable
    let type: Type
    let defaultValue: DefaultValue?
}

struct TypeCondition {
    let namedType: String
}

struct FragmentName {
    let name: String
    init(name: String) throws {
        if name == "on" {
            throw ModelError.IllegalName(name: name)
        }
        self.name = name
    }
}

struct FragmentDefinition {
    let fragmentName: FragmentName
    let typeCondition: TypeCondition
    let directives: [Directive]
    let selectionSet: SelectionSet
}

// can't be a struct -- Swift disallows recursive value types
class SelectionSet {
    let selections: Array1<Selection>
    init(selections: Array1<Selection>) {
        self.selections = selections
    }
}

enum Selection {
    case Field(field: SelectionField)
    case FragmentSpread(fragmentSpread: SelectionFragmentSpread)
    case InlineFragment(inlineFragment: SelectionInlineFragment)
}

struct Alias {
    let name: String
}

struct SelectionField {
    let alias: Alias?
    let name: String
    let arguments: [Argument]
    let directives: [Directive]
    let selectionSet: SelectionSet?
}

struct SelectionFragmentSpread {
    let fragmentName: FragmentName
    let directives: [Directive]
}

struct SelectionInlineFragment {
    let typeCondition: TypeCondition?
    let directives: [Directive]
    let selectionSet: SelectionSet
}

enum OperationType: String {
    case Query = "query"
    case Mutation = "mutation"
}

struct OperationDefinition {
    let operationType: OperationType
    let name: String?
    let variableDefinitions: [VariableDefinition]
    let directives: [Directive]
    let selectionSet: SelectionSet
}

enum Definition {
    case Fragment(fragmentDefinition: FragmentDefinition)
    case Operation(operationDefinition: OperationDefinition)
    case SelectionSetDefinition(selectionSet: SelectionSet)
}

struct Document {
    let definitions: [Definition]
}

// type definitions

struct Interface {
    let name: String
    let fields: Array1<ConstKeyVal>
}

struct TypeDefinition {
    let name: String
    let interfaces: [Interface]
    let fields: Array1<ConstKeyVal>
}

struct Union {
    let name: String
    let types: Array1<String> // TODO or should it be [Type] or [BaseType]?
}
