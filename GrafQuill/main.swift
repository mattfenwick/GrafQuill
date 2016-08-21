//
//  main.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

let value = Value.List_(list: List(values: [
    Value.Boolean_(bool: false),
    Value.Boolean_(bool: true),
    Value.Object_(object: Object(keyvals: [
        KeyVal(name: "abc", value: Value.Variable_(variable: "qrs")),
        KeyVal(name: "a_name", value: Value.Variable_(variable: "long_variable_name")),
        KeyVal(name: "obj", value: Value.List_(list: List(values: [
            Value.Number_(number: Number(int: 22, fraction: 33, exponent: nil))
        ])))
    ])),
    Value.Enum_(value: try Enum(name: "hi"))]))

let field1 = Field(alias: Alias(name: "my_first_alias"), name: "first_field", arguments: [Argument(name: "my_first_argument", value: value)], directives: [Directive(name: "skip_directive", args: []), Directive(name: "ignore_directive", args: [])], selectionSet: nil)
let field2: Field = Field(alias: nil, name: "second_field", arguments: [], directives: [], selectionSet: nil)
let field3 = Field(alias: nil, name: "third_field", arguments: [], directives: [], selectionSet: nil)
let selections = Array1(x: Selection.Field_(field: field1), xs: [field2, field3].map(Selection.Field_))
let fragmentDefinition = FragmentDefinition(fragmentName: try FragmentName(name: "My_cute_fragment"), typeCondition: TypeCondition(namedType: try NamedType(name: "OrangeType")), directives: [
        Directive(name: "my_first_directive", args: [])
    ], selectionSet: SelectionSet(selections: selections))

let document = Document(definitions: [
        Definition.Fragment_(fragment: fragmentDefinition)
    ])

var text = [String]()
value.code(&text, tabs: 0)
print(text.joinWithSeparator(""))

print("\n")

var text2 = [String]()
document.code(&text2, tabs: 0)
print(text2.joinWithSeparator(""))
