/// A protocol that provides type name information for conforming types.
///
/// Types conforming to `TypeNameDescribable` gain the ability to introspect their type names,
/// including support for generic types and their parameters.
///
/// ## Overview
///
/// This protocol provides both instance and static properties to retrieve type names,
/// along with utilities for working with generic types.
///
/// ## Example Usage
///
/// ```swift
/// struct MyStruct: TypeNameDescribable {}
/// let instance = MyStruct()
/// print(instance.typeName) // "MyStruct"
///
/// struct GenericStruct<T>: TypeNameDescribable {}
/// let genericInstance = GenericStruct<String>()
/// print(genericInstance.typeName) // "GenericStruct<String>"
/// print(genericInstance.rootTypeName) // "GenericStruct"
/// print(genericInstance.genericTypeNames) // ["String"]
/// ```
public protocol TypeNameDescribable {
    /// The type name of the instance.
    var typeName: String { get }
    
    /// The type name of the type itself.
    static var typeName: String { get }
}

public extension TypeNameDescribable {
    /// Returns the type name of the instance.
    ///
    /// This property uses Swift's `String(describing:)` function to get the type name
    /// of the current instance, including any generic parameters.
    ///
    /// - Returns: A string representation of the instance's type.
    var typeName: String {
        return String(describing: type(of: self))
    }

    /// Returns the type name of the type itself.
    ///
    /// This static property uses Swift's `String(describing:)` function to get the type name,
    /// including any generic parameters.
    ///
    /// - Returns: A string representation of the type.
    static var typeName: String {
        return String(describing: self)
    }

    /// Returns the root type name without generic parameters.
    ///
    /// For generic types like `Array<String>`, this returns just `Array`.
    /// For non-generic types, this returns the same as `typeName`.
    ///
    /// ## Example
    /// ```swift
    /// let array = [1, 2, 3]
    /// print(array.rootTypeName) // "Array"
    /// ```
    ///
    /// - Returns: The type name without generic parameters.
    var rootTypeName: String {
        guard let angleIndex = typeName.firstIndex(of: "<") else {
            return typeName
        }
        return String(typeName[..<angleIndex])
    }

    /// Returns an array of generic type parameter names.
    ///
    /// This property parses the type name and extracts all generic parameters,
    /// handling nested generics and complex types like tuples.
    ///
    /// ## Example
    /// ```swift
    /// let dict = ["key": "value"]
    /// print(dict.genericTypeNames) // ["String", "String"]
    ///
    /// let nestedArray = [["a", "b"], ["c", "d"]]
    /// print(nestedArray.genericTypeNames) // ["Array<String>"]
    /// ```
    ///
    /// - Returns: An array of generic type parameter names, or empty array if not generic.
    var genericTypeNames: [String] {
        genericParsing(typeName)
    }

    /// Returns `true` if the type has generic parameters.
    ///
    /// This is a convenience property that checks if `genericTypeNames` is not empty.
    ///
    /// ## Example
    /// ```swift
    /// struct SimpleStruct: TypeNameDescribable {}
    /// struct GenericStruct<T>: TypeNameDescribable {}
    ///
    /// let simple = SimpleStruct()
    /// let generic = GenericStruct<Int>()
    ///
    /// print(simple.isGenericType) // false
    /// print(generic.isGenericType) // true
    /// ```
    ///
    /// - Returns: `true` if the type has generic parameters, `false` otherwise.
    var isGenericType: Bool {
        typeName.contains("<")
    }
}

private extension TypeNameDescribable {
    /// Parses a type name string to extract generic parameters.
    ///
    /// This method handles complex generic type parsing, including nested generics,
    /// tuples, and function types within generic parameters.
    ///
    /// - Parameter typeName: The full type name string to parse.
    /// - Returns: An array of generic parameter type names.
    func genericParsing(_ typeName: String) -> [String] {
        // Quick check for generic types presence
        guard typeName.contains("<"), typeName.contains(">") else {
            return []
        }
        
        // Find first '<' and last '>'
        guard let startIndex = typeName.firstIndex(of: "<"),
              let endIndex = typeName.lastIndex(of: ">") else {
            return []
        }
        
        // Extract content between < and >
        let genericContent = typeName[typeName.index(after: startIndex)..<endIndex]
        
        // Return empty array if content is empty
        guard !genericContent.isEmpty else {
            return []
        }
        
        // Parse with nesting support
        return parseGenericParameters(String(genericContent))
    }
    
    /// Parses the content between generic brackets to extract individual parameters.
    ///
    /// This method correctly handles nested brackets and parentheses to split
    /// generic parameters at the appropriate comma boundaries.
    ///
    /// - Parameter content: The string content between generic brackets.
    /// - Returns: An array of individual generic parameter names.
    func parseGenericParameters(_ content: String) -> [String] {
        var result: [String] = []
        var currentParameter = ""
        var bracketDepth = 0
        var parenthesesDepth = 0
        
        for char in content {
            switch char {
            case "<":
                bracketDepth += 1
                currentParameter.append(char)
            case ">":
                bracketDepth -= 1
                currentParameter.append(char)
            case "(":
                parenthesesDepth += 1
                currentParameter.append(char)
            case ")":
                parenthesesDepth -= 1
                currentParameter.append(char)
            case ",":
                if bracketDepth == 0 && parenthesesDepth == 0 {
                    // Add parameter, trimming whitespace
                    let trimmedParameter = currentParameter.trimmingCharacters(in: .whitespaces)
                    if !trimmedParameter.isEmpty {
                        result.append(trimmedParameter)
                    }
                    currentParameter = ""
                } else {
                    currentParameter.append(char)
                }
            default:
                currentParameter.append(char)
            }
        }
        
        // Add the last parameter
        let trimmedParameter = currentParameter.trimmingCharacters(in: .whitespaces)
        if !trimmedParameter.isEmpty {
            result.append(trimmedParameter)
        }
        
        return result
    }
}

#if canImport(Foundation)
import Foundation
extension NSObject: TypeNameDescribable {}
#endif

extension Array: TypeNameDescribable {}
extension Dictionary: TypeNameDescribable {}
extension Set: TypeNameDescribable {}
extension Optional: TypeNameDescribable {}