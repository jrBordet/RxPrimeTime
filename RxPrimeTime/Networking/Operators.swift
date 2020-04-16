//
//  Operators.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 28/11/2019.
//  Copyright © 2019 Bordet. All rights reserved.
//

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: AdditionPrecedence
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

precedencegroup SingleTypeComposition {
    associativity: right
    higherThan: ForwardApplication
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A,
               f: (A) -> B) -> B {
    return f(a)
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B,
                   g: @escaping (B) -> C) -> (A) -> C {
    return { a in
        g(f(a))
    }
}

infix operator <>: SingleTypeComposition
func <> <A>(f: @escaping (A) -> A,
                   g: @escaping (A) -> A) -> (A) -> A {
    return f >>> g
}

func <> <A>(f: @escaping (inout A) -> Void,
                   g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

func <> <A: AnyObject>(f: @escaping (A) -> Void,
                              g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}
