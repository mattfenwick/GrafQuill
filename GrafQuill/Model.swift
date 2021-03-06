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
    case IllegalVariableInDefaultValue(name: String)
}

struct Variable {
    let name: String
    init(name: String) throws {
        // TODO check for allowed, disallowed characters
        self.name = name
    }
}

struct Argument {
    let name: String
    let value: Value
}

typealias KeyVal = Argument

struct Directive {
    let name: String
    let args: [Argument]
    init(name: String, args: [Argument] = []) {
        self.name = name
        self.args = args
    }
}

struct NamedType {
    let name: String
    init(name: String) throws {
        // TODO check for matching /[_A-Za-z][_0-9A-Za-z]*/
        self.name = name
    }
}

class ListType {
    let type: Type
    init(type: Type) {
        self.type = type
    }
}

struct Type {
    let type: Either<NamedType, ListType>
    let isNonNull: Bool
}

struct Number {
    let int: Int
    let fraction: UInt?
    let exponent: Int?
    init(int: Int, fraction: UInt? = nil, exponent: Int? = nil) {
        self.int = int
        self.fraction = fraction
        self.exponent = exponent
    }
}

struct Enum {
    static let disallowedNames = Set(["true", "false", "null"])
    let name: String
    init(name: String) throws {
        if Enum.disallowedNames.contains(name) {
            throw ModelError.IllegalName(name: name)
        }
        self.name = name
    }
}

struct List {
    let values: [Value]
}

struct Object {
    let keyvals: [KeyVal]
}

indirect enum Value {
    case Number_(Number)
    case String_(String)
    case Boolean_(Bool)
    case Enum_(Enum)
    case List_(List)
    case Object_(Object)
    case Variable_(Variable)
}

struct DefaultValue {
    let value: Value
    init(value: Value) throws {
        self.value = value
        // TODO recursively ensure that there's no variables in `value`
    }
}

struct VariableDefinition {
    let variable: Variable
    let type: Type
    let defaultValue: DefaultValue?
    init(variable: Variable, type: Type, defaultValue: DefaultValue? = nil) {
        self.variable = variable
        self.type = type
        self.defaultValue = defaultValue
    }
}

struct TypeCondition {
    let namedType: NamedType
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
    init(fragmentName: FragmentName, typeCondition: TypeCondition, directives: [Directive] = [], selectionSet: SelectionSet) {
        self.fragmentName = fragmentName
        self.typeCondition = typeCondition
        self.directives = directives
        self.selectionSet = selectionSet
    }
}

// can't be a struct -- Swift disallows recursive value types
class SelectionSet {
    let selections: Array1<Selection>
    init(selections: Array1<Selection>) {
        self.selections = selections
    }
}

enum Selection {
    case Field_(Field)
    case FragmentSpread_(FragmentSpread)
    case InlineFragment_(InlineFragment)
}

struct Alias {
    let name: String
}

struct Field {
    let alias: Alias?
    let name: String
    let arguments: [Argument]
    let directives: [Directive]
    let selectionSet: SelectionSet?
    init(alias: Alias? = nil, name: String, arguments: [Argument] = [], directives: [Directive] = [], selectionSet: SelectionSet? = nil) {
        self.alias = alias
        self.name = name
        self.arguments = arguments
        self.directives = directives
        self.selectionSet = selectionSet
    }
}

struct FragmentSpread {
    let fragmentName: FragmentName
    let directives: [Directive]
    init(fragmentName: FragmentName, directives: [Directive] = []) {
        self.fragmentName = fragmentName
        self.directives = directives
    }
}

struct InlineFragment {
    let typeCondition: TypeCondition?
    let directives: [Directive]
    let selectionSet: SelectionSet
    init(typeCondition: TypeCondition? = nil, directives: [Directive] = [], selectionSet: SelectionSet) {
        self.typeCondition = typeCondition
        self.directives = directives
        self.selectionSet = selectionSet
    }
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
    init(operationType: OperationType, name: String? = nil, variableDefinitions: [VariableDefinition] = [], directives: [Directive] = [], selectionSet: SelectionSet) {
        self.operationType = operationType
        self.name = name
        self.variableDefinitions = variableDefinitions
        self.directives = directives
        self.selectionSet = selectionSet
    }
}

enum Definition {
    case Fragment_(FragmentDefinition)
    case Operation_(OperationDefinition)
    case SelectionSet_(SelectionSet)
}

struct Document {
    let definitions: [Definition]
}

// MARK: - type definitions -- these are all REALLY rough and need to figure out a TON of corner cases

// interface NamedEntity {
//    name: String
// }
struct Interface {
    let name: String
    // TODO shouldn't this be Dict1<FieldName, Type>  ?
    let fields: Array1<Type> // TODO had Array1<ConstKeyVal> in an earlier version: not sure why
}

// type Person {
//   name: String
//   age: Int
// }
// type Person implements NamedEntity {
//   name: String
//   age: Int
// }
struct TypeDefinition {
    let name: String
    let interfaces: [Interface]
    // TODO shouldn't this be Dict1<FieldName, Type>  ?
    let fields: Array1<Type> // TODO had Array1<ConstKeyVal> in an earlier version: not sure why
}

// union SearchResult = Photo | Person
struct Union {
    let name: String
    let types: Array1<Type> // TODO or should it be [BaseType]  ?
}

// TODO don't know what this is
// extend type QueryRoot {
//   findDog(complex: ComplexInput): Dog
//   booleanList(booleanListArg: [Boolean!]): Boolean
// }
struct Extends {

}
