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
    let fraction: Int?
    let exponent: Int?
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
    case Number_(number: Number)
    case String_(string: String)
    case Boolean_(bool: Bool)
    case Enum_(value: Enum)
    case List_(list: List)
    case Object_(object: Object)
    case Variable_(variable: Variable)
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
}

// can't be a struct -- Swift disallows recursive value types
class SelectionSet {
    let selections: Array1<Selection>
    init(selections: Array1<Selection>) {
        self.selections = selections
    }
}

enum Selection {
    case Field_(field: Field)
    case FragmentSpread_(fragmentSpread: FragmentSpread)
    case InlineFragment_(inlineFragment: InlineFragment)
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
}

struct FragmentSpread {
    let fragmentName: FragmentName
    let directives: [Directive]
}

struct InlineFragment {
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
    case Fragment_(fragment: FragmentDefinition)
    case Operation_(operation: OperationDefinition)
    case SelectionSet_(selectionSet: SelectionSet)
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
