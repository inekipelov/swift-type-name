# swift-type-name

Utility Swift package for getting type names at runtime and compile time. Protocol-oriented approach for convenient and consistent type name access.

## Features

- **Runtime type name detection** - Get type names for any instance
- **Static type name access** - Access type names without instances
- **Generic type support** - Parse and extract generic type information

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-type-name.git", from: "0.1.0")
]
```

Or add it through Xcode: File → Add Package Dependencies

## Usage

### Basic Type Names

```swift
import TypeName

class MyClass: TypeNameDescribable {}
struct MyStruct: TypeNameDescribable {}
enum MyEnum: TypeNameDescribable { case value }

let myClass = MyClass()
let myStruct = MyStruct()
let myEnum = MyEnum.value

// Instance type names
print(myClass.typeName)  // "MyClass"
print(myStruct.typeName) // "MyStruct"
print(myEnum.typeName)   // "MyEnum"

// Static type names
print(MyClass.typeName)  // "MyClass"
print(MyStruct.typeName) // "MyStruct"
print(MyEnum.typeName)   // "MyEnum"
```

### Generic Types

```swift
class GenericClass<T>: TypeNameDescribable {}
struct GenericStruct<T, U>: TypeNameDescribable {}

let genericClass = GenericClass<String>()
let genericStruct = GenericStruct<Int, String>()

// Full generic type name
print(genericClass.typeName) // "GenericClass<String>"
print(genericStruct.typeName) // "GenericStruct<Int, String>"

// Root type name (without generics)
print(genericClass.genericRootTypeName) // "GenericClass"
print(genericStruct.genericRootTypeName) // "GenericStruct"

// Generic child type names
print(genericClass.genericChildTypeNames) // ["String"]
print(genericStruct.genericChildTypeNames) // ["Int", "String"]
```

### Built-in Types

```swift
// Built-in types work out of the box
extension Array: TypeNameDescribable {}
extension Dictionary: TypeNameDescribable {}

let array = Array<String>()
let dict = Dictionary<String, Int>()

print(array.typeName) // "Array<String>"
print(dict.typeName) // "Dictionary<String, Int>"

print(array.genericChildTypeNames) // ["String"]
print(dict.genericChildTypeNames) // ["String", "Int"]
```

### NSObject Integration

```swift
// NSObject types automatically conform to TypeNameDescribable
let object = NSObject()
print(object.typeName) // "NSObject"
```

## API Reference

### Protocol

```swift
protocol TypeNameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}
```

### Instance Properties

- `typeName: String` - Full type name including generics
- `genericRootTypeName: String` - Type name without generic parameters
- `genericChildTypeNames: [String]` - Array of generic type parameters

### Static Properties

- `typeName: String` - Static type name

## Requirements

- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+
- Swift 5.5+

## License

MIT License. See LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.