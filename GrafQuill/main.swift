//
//  main.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

let value = Value.ListValue(values: [
    Value.BooleanValue(bool: false),
    Value.BooleanValue(bool: true),
    Value.ObjectValue(keyvals: [
        KeyVal(name: "abc", value: Value.VariableValue(variable: "qrs")),
        KeyVal(name: "a_name", value: Value.VariableValue(variable: "long_variable_name")),
        KeyVal(name: "obj", value: Value.ListValue(values: [
            Value.FloatValue(int: 22, decimal: 33)
        ]))
    ]),
    Value.EnumValue(string: "hi")])

let field1 = SelectionField(alias: Alias(name: "my_first_alias"), name: "first_field", arguments: [Argument(name: "my_first_argument", value: value)], directives: [Directive(name: "skip_directive", args: []), Directive(name: "ignore_directive", args: [])], selectionSet: nil)
let field2: SelectionField = SelectionField(alias: nil, name: "second_field", arguments: [], directives: [], selectionSet: nil)
let field3 = SelectionField(alias: nil, name: "third_field", arguments: [], directives: [], selectionSet: nil)
let selections = Array1(x: Selection.Field(field: field1), xs: [field2, field3].map(Selection.Field))
let fragmentDefinition = FragmentDefinition(fragmentName: try FragmentName(name: "My_cute_fragment"), typeCondition: TypeCondition(namedType: "OrangeType"), directives: [
        Directive(name: "my_first_directive", args: [])
    ], selectionSet: SelectionSet(selections: selections))

let document = Document(definitions: [
        Definition.Fragment(fragmentDefinition: fragmentDefinition)
    ])

var text = [String]()
value.code(&text, tabs: 0)
print(text.joinWithSeparator(""))

print("\n")

var text2 = [String]()
document.code(&text2, tabs: 0)
print(text2.joinWithSeparator(""))
