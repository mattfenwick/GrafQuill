//
//  Examples.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/21/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

/*
{
    zomg: __type(name:"Int") {
        name
        kind
    }
    __schema {
        types {
            name
            kind
            description
        }
        queryType {
            name
            kind
            description
        }
        mutationType {
            name
            kind
            description
        }
        subscriptionType {
            name
            kind
            description
        }
        directives {
            name
        }
    }
}
*/

let zomgName = Selection.Field_(field: Field(name: "name"))
let zomgKind = Selection.Field_(field: Field(name: "kind"))
let zomg = Selection.Field_(field:
    Field(alias: Alias(name: "zomg"),
        name: "__type",
        arguments: [Argument(name: "name", value: Value.String_(string: "Int"))],
        directives: [],
        selectionSet: SelectionSet(selections: Array1(x: zomgName, xs: [zomgKind]))))
func nameKindDescField(name: String) -> Field {
    let selections = Array1(x: "name", xs: ["kind", "description"])
        .map( { Selection.Field_(field: Field(name: $0)) } )
    return Field(name: name, selectionSet: SelectionSet(selections: selections))
}
let schemaSelections = Array1(x: "types", xs: ["queryType", "mutationType", "subscriptionType"])
    .map( { Selection.Field_(field: nameKindDescField($0)) } )
    .push(Selection.Field_(field: Field(name: "directives", selectionSet: SelectionSet(selections: Array1(x: Selection.Field_(field: Field(name: "name")), xs: [])))))
let schemaSelectionSet = SelectionSet(selections: schemaSelections)
let schema = Selection.Field_(field: Field(name: "__schema", selectionSet: schemaSelectionSet))
let zomgSelectionSet = SelectionSet(selections: Array1(x: zomg, xs: [schema]))
let zomgDocument = Document(definitions: [Definition.SelectionSet_(selectionSet: zomgSelectionSet)])
