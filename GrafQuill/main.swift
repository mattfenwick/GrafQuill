//
//  main.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

let value = Value.List_(List(values: [
    false,
    true,
    Value.Object_(Object(keyvals: [
        KeyVal(name: "abc", value: Value.Variable_("qrs")),
        KeyVal(name: "a_name", value: Value.Variable_("long_variable_name")),
        KeyVal(name: "obj", value: Value.List_(List(values: [
            Value.Number_(22)
        ])))
    ])),
    Value.Enum_("hi")]))

let field1 = Field(alias: Alias(name: "my_first_alias"),
                   name: "first_field",
                   arguments: [Argument(name: "my_first_argument", value: value)],
                   directives: [Directive(name: "skip_directive"), Directive(name: "ignore_directive")])
let field2 = Field(name: "second_field")
let field3 = Field(name: "third_field")
// let selections = Array1(x: Selection.Field_(field1), xs: [field2, field3].map(Selection.Field_))
let selections = Array1(x: field1, xs: [field2, field3]).map(Selection.Field_)
let fragmentDefinition = FragmentDefinition(fragmentName: "My_cute_fragment",
    typeCondition: TypeCondition(namedType: "OrangeType"),
    directives: [
        Directive(name: "my_first_directive")
    ],
    selectionSet: SelectionSet(selections: selections))

let document = Document(definitions: [
        Definition.Fragment_(fragmentDefinition)
    ])

var text = [String]()
value.code(&text, tabs: 0)
print(text.joinWithSeparator(""))

print("\n")

var text2 = [String]()
document.code(&text2, tabs: 0)
print(text2.joinWithSeparator(""))

print("\n")

var text3 = [String]()
zomgDocument.code(&text3, tabs: 0)
print(text3.joinWithSeparator(""))

array1Tests()
