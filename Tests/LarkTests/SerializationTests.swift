import Foundation
import XCTest

@testable import Lark

extension XMLDeserializable {
    init(deserialize xmlString: String) throws {
        let element = try XMLElement(xmlString: xmlString)
        self = try Self(deserialize: element)
    }
}

class TypesTests: XCTestCase {

    // MARK: Signed integers

    func testInt8() {
        test(value: Int8(-128), expected: "<test>-128</test>")
        test(value: Int8(0), expected: "<test>0</test>")
        test(value: Int8(127), expected: "<test>127</test>")
        testFails(try Int8(deserialize: "<test>abc</test>"))
        testFails(try Int8(deserialize: "<test>128</test>"))
        testFails(try Int8(deserialize: "<test/>"))
    }

    func testInt16() {
        test(value: Int16(-1234), expected: "<test>-1234</test>")
        test(value: Int16(0), expected: "<test>0</test>")
        test(value: Int16(1234), expected: "<test>1234</test>")
    }

    func testInt32() {
        test(value: Int32(-1234), expected: "<test>-1234</test>")
        test(value: Int32(0), expected: "<test>0</test>")
        test(value: Int32(1234), expected: "<test>1234</test>")
    }

    func testInt64() {
        test(value: Int64(-1234), expected: "<test>-1234</test>")
        test(value: Int64(0), expected: "<test>0</test>")
        test(value: Int64(1234), expected: "<test>1234</test>")
    }

    // MARK: Unsigned integers

    func testUInt8() {
        test(value: UInt8(0), expected: "<test>0</test>")
        test(value: UInt8(127), expected: "<test>127</test>")
    }

    func testUInt16() {
        test(value: UInt16(0), expected: "<test>0</test>")
        test(value: UInt16(1234), expected: "<test>1234</test>")
    }

    func testUInt32() {
        test(value: UInt32(0), expected: "<test>0</test>")
        test(value: UInt32(1234), expected: "<test>1234</test>")
    }

    func testUInt64() {
        test(value: UInt64(0), expected: "<test>0</test>")
        test(value: UInt64(1234), expected: "<test>1234</test>")
    }

    // MARK: Numeric types

    func testBool() {
        test(value: Bool(true), expected: "<test>true</test>")
        test(value: Bool(false), expected: "<test>false</test>")
        test(serialized: "<test>1</test>", expected: Bool(true))
        test(serialized: "<test>0</test>", expected: Bool(false))
    }

    func testFloat() {
        test(value: Float(0), expected: "<test>0.0</test>")
        test(value: Float(0.0), expected: "<test>0.0</test>")
        test(value: Float(-12.34), expected: "<test>-12.34</test>")
        test(value: Float(12.34), expected: "<test>12.34</test>")
        test(value: Float(-1234), expected: "<test>-1234.0</test>")
        test(value: Float(1234), expected: "<test>1234.0</test>")

        test(value: Float(1.23e13), expected: "<test>1.23e13</test>")
        test(value: Float(1.23e-13), expected: "<test>1.23e-13</test>")
        test(value: Float(-1.23e13), expected: "<test>-1.23e13</test>")
        test(value: Float(-1.23e-13), expected: "<test>-1.23e-13</test>")
        test(value: Float.infinity, expected: "<test>INF</test>")
        test(value: -Float.infinity, expected: "<test>-INF</test>")

        test(serialized: "<test>1.23E13</test>", expected: Float(1.23e13))
        test(serialized: "<test>-0</test>", expected: Float(0))

        do {
            let element = XMLElement(name: "test")
            try Float.nan.serialize(element)
            XCTAssertEqual(element.xmlString, "<test>NaN</test>")
            XCTAssertTrue(try Float(deserialize: element).isNaN)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testDouble() {
        test(value: Double(0), expected: "<test>0.0</test>")
        test(value: Double(0.0), expected: "<test>0.0</test>")
        test(value: Double(-12.34), expected: "<test>-12.34</test>")
        test(value: Double(12.34), expected: "<test>12.34</test>")
        test(value: Double(-1234), expected: "<test>-1234.0</test>")
        test(value: Double(1234), expected: "<test>1234.0</test>")

        test(value: Double(1.23e45), expected: "<test>1.23e45</test>")
        test(value: Double(1.23e-45), expected: "<test>1.23e-45</test>")
        test(value: Double(-1.23e45), expected: "<test>-1.23e45</test>")
        test(value: Double(-1.23e-45), expected: "<test>-1.23e-45</test>")
        test(value: Double.infinity, expected: "<test>INF</test>")
        test(value: -Double.infinity, expected: "<test>-INF</test>")

        test(serialized: "<test>1.23E13</test>", expected: Double(1.23e13))
        test(serialized: "<test>-0</test>", expected: Double(0))

        do {
            let element = XMLElement(name: "test")
            try Double.nan.serialize(element)
            XCTAssertEqual(element.xmlString, "<test>NaN</test>")
            XCTAssertTrue(try Double(deserialize: element).isNaN)
        } catch {
            XCTFail("\(error)")
        }

    }

    func testInt() {
        test(value: Int(-1234), expected: "<test>-1234</test>")
        test(value: Int(0), expected: "<test>0</test>")
        test(value: Int(1234), expected: "<test>1234</test>")
    }

    func testDecimal() {
        test(value: Decimal(0), expected: "<test>0</test>")
        test(value: Decimal(0.0), expected: "<test>0</test>")
        test(value: Decimal(-12.34), expected: "<test>-12.34</test>")
        test(value: Decimal(12.34), expected: "<test>12.34</test>")
        test(value: Decimal(-1234), expected: "<test>-1234</test>")
        test(value: Decimal(1234), expected: "<test>1234</test>")
    }

    // MARK: Other types

    func testString() {
        test(value: "foo", expected: "<test>foo</test>")
        test(value: "foo\nbar", expected: "<test>foo\nbar</test>")
        test(value: "\"bar\"", expected: "<test>\"bar\"</test>")
    }

    func testURL() {
        test(value: URL(string: "http://swift.org")!, expected: "<test>http://swift.org</test>")
        test(value: URL(string: "ssh://github.com")!, expected: "<test>ssh://github.com</test>")
    }

    func testData() {
        test(value: Data(base64Encoded: "deadbeef")!, expected: "<test>deadbeef</test>")
        test(value: Data(), expected: "<test></test>")
    }

    func testDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        test(value: Date(timeIntervalSinceReferenceDate: 0), expected: "<test>2001-01-01T00:00:00Z</test>")
        test(serialized: "<test>2001-01-01T00:00:00Z</test>", expected: Date(timeIntervalSinceReferenceDate: 0))

        Date.dateFormatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")!
        test(value: Date(timeIntervalSinceReferenceDate: 0), expected: "<test>2001-01-01T01:00:00+01:00</test>")
        test(serialized: "<test>2001-01-01T00:00:00Z</test>", expected: Date(timeIntervalSinceReferenceDate: 0))
        Date.dateFormatter.timeZone = TimeZone(identifier: "UTC")!

        // needs a fallback dateformatter as the timezone is missing
        test(serialized: "<test>2001-01-01T00:00:00</test>", expected: Date(timeIntervalSinceReferenceDate: 0))

        // needs a fallback dateformatter as it contains milliseconds
        test(serialized: "<test>2014-04-11T09:01:33.241Z</test>",
             expected: formatter.date(from: "2014-04-11T09:01:33.241Z")!)

        // needs a fallback dateformatter as it contains milliseconds and no timezone identifier
        test(serialized: "<test>2014-04-11T09:01:33.241</test>",
             expected: formatter.date(from: "2014-04-11T09:01:33.241Z")!)
    }

    func testQualifiedName() {
        let qname = QualifiedName(uri: "http://tempuri.org/", localName: "foo")
        test(value: qname, expected: "<test xmlns:ns1=\"http://tempuri.org/\">ns1:foo</test>")

        do {
            let node = XMLElement(name: "test")
            node.addAttribute(XMLNode.attribute(withName: "targetNamespace", stringValue: "http://tempuri.org/") as! XMLNode)
            try qname.serialize(node)
            XCTAssertEqual(node.xmlString, "<test targetNamespace=\"http://tempuri.org/\">foo</test>")
            let deserialized = try QualifiedName(deserialize: node)
            XCTAssertEqual(qname, deserialized)
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testAnyType() throws {
        // Note that the node name doesn't matter; only AnyType's content will be (de)serialized.
        do {
            let element = AnyType(name: "test", stringValue: "bar")
            test(value: element, expected: "<test>bar</test>")

            element.addAttribute(XMLNode.attribute(withName: "hello", stringValue: "world") as! XMLNode)
            element.addAttribute(XMLNode.attribute(withName: "baz", stringValue: "buz") as! XMLNode)
            test(value: element, expected: "<test hello=\"world\" baz=\"buz\">bar</test>")
        }
        do {
            let xml = "<test><!-- some comment --></test>"
            test(value: try AnyType(xmlString: xml), expected: xml)
        }
        do {
            let xml = "<test xmlns:ns=\"http://tempuri.org/test\" ns:foo=\"bar\"><!-- some comment --></test>"
            test(value: try AnyType(xmlString: xml), expected: xml)
        }
    }
}

/// Asserts that the given serialization deserializes into the expected value
///
/// - Parameters:
///   - serialized: String XML element
///   - expected: T expected value
///   - file: (set automatically)
///   - line: (set automatically)
func test<T>(serialized: String, expected: T, file: StaticString = #file, line: UInt = #line) where T: XMLSerializable, T: XMLDeserializable, T: Equatable {
    do {
        let element = try XMLElement(xmlString: serialized)
        let actual = try T(deserialize: element)
        XCTAssertEqual(actual, expected, file: file, line: line)
    } catch {
        XCTFail("Failed with error: \(error)", file: file, line: line)
    }
}

/// Asserts that the given value serializes into the expected serialization, and deserializes back to the original value
///
/// - Parameters:
///   - value: T value to test
///   - expected: String expected XML serialization
///   - file: (set automatically)
///   - line: (set automatically)
func test<T>(value: T, expected: String, file: StaticString = #file, line: UInt = #line) where T: XMLSerializable, T: XMLDeserializable, T: Equatable {
    do {
        let element = XMLElement(name: "test")
        try value.serialize(element)
        XCTAssertEqual(element.xmlString, expected, "serialization failed", file: file, line: line)
        let deserialized = try T(deserialize: element)
        XCTAssertEqual(deserialized, value, "deserialization failed", file: file, line: line)
    } catch {
        XCTFail("Failed with error: \(error)", file: file, line: line)
    }
}

func testFails<T>(_ deserialization: @autoclosure () throws -> T, file: StaticString = #file, line: UInt = #line) where T: XMLSerializable, T: XMLDeserializable, T: Equatable {
    do {
        _ = try deserialization()
        XCTFail("Deserialization should have failed", file: file, line: line)
    } catch { }
}
