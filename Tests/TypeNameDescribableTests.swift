import XCTest
@testable import TypeName

// MARK: - Test Types
class TestClass: TypeNameDescribable {}

struct TestStruct: TypeNameDescribable {}

enum TestEnum: TypeNameDescribable {
    case value
}

class GenericClass<T>: TypeNameDescribable {}

struct GenericStruct<T, U>: TypeNameDescribable {}

class Object: NSObject {}

final class TypeNameDescribableTests: XCTestCase {
    
    // MARK: - Basic Type Name Tests
    
    func testBasicTypeName() {
        let testClass = TestClass()
        let testStruct = TestStruct()
        let testEnum = TestEnum.value
        
        XCTAssertEqual(testClass.typeName, "TestClass")
        XCTAssertEqual(testStruct.typeName, "TestStruct")
        XCTAssertEqual(testEnum.typeName, "TestEnum")
    }
    
    func testStaticTypeName() {
        XCTAssertEqual(TestClass.typeName, "TestClass")
        XCTAssertEqual(TestStruct.typeName, "TestStruct")
        XCTAssertEqual(TestEnum.typeName, "TestEnum")
    }
    
    // MARK: - Generic Type Tests
    
    func testGenericTypeNames() {
        let genericClass = GenericClass<String>()
        let genericStruct = GenericStruct<Int, String>()
        
        XCTAssertEqual(genericClass.typeName, "GenericClass<String>")
        XCTAssertEqual(genericStruct.typeName, "GenericStruct<Int, String>")
    }
    
    func testRootTypeName() {
        let testClass = TestClass()
        let genericClass = GenericClass<String>()
        let genericStruct = GenericStruct<Int, String>()
        
        XCTAssertEqual(testClass.rootTypeName, "TestClass")
        XCTAssertEqual(genericClass.rootTypeName, "GenericClass")
        XCTAssertEqual(genericStruct.rootTypeName, "GenericStruct")
    }
    
    func testGenericTypeNamesExtraction() {
        let genericClass = GenericClass<String>()
        let genericStruct = GenericStruct<Int, String>()
        let testClass = TestClass()
        
        XCTAssertEqual(genericClass.genericTypeNames, ["String"])
        XCTAssertEqual(genericStruct.genericTypeNames, ["Int", "String"])
        XCTAssertEqual(testClass.genericTypeNames, [])
    }
    
    func testIsGenericType() {
        let testClass = TestClass()
        let genericClass = GenericClass<String>()
        let genericStruct = GenericStruct<Int, String>()
        
        XCTAssertFalse(testClass.isGenericType)
        XCTAssertTrue(genericClass.isGenericType)
        XCTAssertTrue(genericStruct.isGenericType)
    }
    
    // MARK: - Foundation Types Tests
    
    func testNSObjectTypeName() {
        let object = Object()
        
        XCTAssertEqual(object.typeName, "Object")
        XCTAssertEqual(Object.typeName, "Object")
        XCTAssertEqual(object.rootTypeName, "Object")
        XCTAssertFalse(object.isGenericType)
    }
    
    // MARK: - Built-in Collection Types Tests
    
    func testArrayTypeName() {
        let stringArray = ["hello", "world"]
        let intArray = [1, 2, 3]
        let emptyArray: [Double] = []
        
        XCTAssertEqual(stringArray.typeName, "Array<String>")
        XCTAssertEqual(intArray.typeName, "Array<Int>")
        XCTAssertEqual(emptyArray.typeName, "Array<Double>")
        
        XCTAssertEqual(stringArray.rootTypeName, "Array")
        XCTAssertEqual(stringArray.genericTypeNames, ["String"])
        XCTAssertTrue(stringArray.isGenericType)
    }
    
    func testDictionaryTypeName() {
        let stringDict = ["key": "value"]
        let intDict = [1: "one", 2: "two"]
        let emptyDict: [String: Int] = [:]
        
        XCTAssertEqual(stringDict.typeName, "Dictionary<String, String>")
        XCTAssertEqual(intDict.typeName, "Dictionary<Int, String>")
        XCTAssertEqual(emptyDict.typeName, "Dictionary<String, Int>")
        
        XCTAssertEqual(stringDict.rootTypeName, "Dictionary")
        XCTAssertEqual(stringDict.genericTypeNames, ["String", "String"])
        XCTAssertTrue(stringDict.isGenericType)
    }
    
    func testSetTypeName() {
        let stringSet: Set<String> = ["hello", "world"]
        let intSet: Set<Int> = [1, 2, 3]
        let emptySet: Set<Double> = []
        
        XCTAssertEqual(stringSet.typeName, "Set<String>")
        XCTAssertEqual(intSet.typeName, "Set<Int>")
        XCTAssertEqual(emptySet.typeName, "Set<Double>")
        
        XCTAssertEqual(stringSet.rootTypeName, "Set")
        XCTAssertEqual(stringSet.genericTypeNames, ["String"])
        XCTAssertTrue(stringSet.isGenericType)
    }
    
    func testOptionalTypeName() {
        let someString: String? = "hello"
        let noneString: String? = nil
        let someInt: Int? = 42
        
        XCTAssertEqual(someString.typeName, "Optional<String>")
        XCTAssertEqual(noneString.typeName, "Optional<String>")
        XCTAssertEqual(someInt.typeName, "Optional<Int>")
        
        XCTAssertEqual(someString.rootTypeName, "Optional")
        XCTAssertEqual(someString.genericTypeNames, ["String"])
        XCTAssertTrue(someString.isGenericType)
    }
    
    // MARK: - Complex Generic Types Tests
    
    func testNestedGenericTypes() {
        let nestedArray = [["hello", "world"], ["foo", "bar"]]
        let nestedDict = ["key": ["nested": "value"]]
        let arrayOfSets: [Set<String>] = [["a", "b"], ["c", "d"]]
        
        XCTAssertEqual(nestedArray.typeName, "Array<Array<String>>")
        XCTAssertEqual(nestedDict.typeName, "Dictionary<String, Dictionary<String, String>>")
        XCTAssertEqual(arrayOfSets.typeName, "Array<Set<String>>")
        
        XCTAssertEqual(nestedArray.rootTypeName, "Array")
        // The current implementation has limitations with nested generics
        XCTAssertEqual(nestedArray.genericTypeNames, ["Array<String>"])
        XCTAssertTrue(nestedArray.isGenericType)
    }
    
    // MARK: - Edge Cases Tests
    
    func testEmptyGenericTypeNames() {
        let testClass = TestClass()
        let testStruct = TestStruct()
        
        XCTAssertTrue(testClass.genericTypeNames.isEmpty)
        XCTAssertTrue(testStruct.genericTypeNames.isEmpty)
    }
    
    func testTypeNameConsistency() {
        let testClass = TestClass()
        
        // Instance and static type names should be the same
        XCTAssertEqual(testClass.typeName, TestClass.typeName)
        
        let genericClass = GenericClass<String>()
        XCTAssertEqual(genericClass.typeName, GenericClass<String>.typeName)
    }
    
    func testGenericTypeNamesWithSpaces() {
        // Test that generic type names handle spaces correctly
        let complexDict: [String: (Int, String)] = ["key": (1, "value")]
        
        XCTAssertEqual(complexDict.rootTypeName, "Dictionary")
        XCTAssertTrue(complexDict.isGenericType)
        // The implementation correctly handles tuples as single types
        XCTAssertEqual(complexDict.genericTypeNames.count, 2)
        XCTAssertEqual(complexDict.genericTypeNames[0], "String")
        XCTAssertEqual(complexDict.genericTypeNames[1], "(Int, String)")
    }
}
