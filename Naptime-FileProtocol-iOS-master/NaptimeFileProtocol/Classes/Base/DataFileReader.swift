//
//  DataFileReader.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/24.
//  Copyright © 2016年 EnterTech. All rights reserved.
//

import Foundation

/// 数据文件读取器
open class DataFileReader: DataFileReadable {

    open var protocolVersion: String {
        return _protocolVersion
    }
    open var headerLength: Byte {
        return _headerLength
    }
    open var fileType: Byte {
        return _fileType
    }
    open var dataVersion: String {
        return _dataVersion
    }
    open var dataLength: UInt64 {
        return _dataLength
    }
    open var checksum: UInt16 {
        return _checksum
    }
    open var timestamp: Timestamp {
        return _timestamp
    }
    open var data: Data {
        return _data
    }

    fileprivate var _protocolVersion: String!
    fileprivate var _headerLength: Byte!
    fileprivate var _fileType: Byte!
    fileprivate var _dataVersion: String!
    fileprivate var _dataLength: UInt64!
    fileprivate var _checksum: UInt16!
    fileprivate var _timestamp: UInt!
    fileprivate var _data: Data!

    public init() {}

    open func loadFile(_ fileURL: URL) throws {
        if let fileData = try? Data(contentsOf: fileURL) {
            self.parseProtocolVersion(fileData)
            self.parseHeaderLength(fileData)

            let headerData = fileData.subdata(in: Range<Int>(uncheckedBounds: (0, Int(_headerLength))))
            _data = fileData.subdata(in:  Range<Int>(uncheckedBounds: (Int(_headerLength), fileData.count)))


            self.parseFileType(headerData)
            self.parseDataVersion(headerData)
            self.parseDataLength(headerData)
            self.parseChecksum(headerData)
            self.parseTimestamp(headerData)
        } else {
            throw DataFileError()
        }
    }

    // MARK: - 解析文件头字段

    fileprivate func parseProtocolVersion(_ data: Data) {
        do {
            var protocolVersionBytes = try data.bytesInRange(NSMakeRange(0, 2))
            _protocolVersion = String(protocolVersionBytes[0]) + "." + String(protocolVersionBytes[1])
        } catch {}
    }

    fileprivate func parseHeaderLength(_ data: Data) {
        do {
            _headerLength = try data.byteAtIndex(2)
        } catch {}
    }

    fileprivate func parseFileType(_ data: Data) {
        do {
            _fileType = try data.byteAtIndex(3)
        } catch {}
    }

    fileprivate func parseDataVersion(_ data: Data) {
        do {
            let versionBytes = try data.bytesInRange(NSMakeRange(4, 4))
            _dataVersion = versionBytes.componentsJoinedByString(".")
        } catch {}
    }

    fileprivate func parseDataLength(_ data: Data) {
        do {
            let dataLengthBytes = try data.bytesInRange(NSMakeRange(8, 6))
            var length: UInt64 = 0
            for item in dataLengthBytes {
                length = length << 8 + UInt64(item)
            }
            _dataLength = length
        } catch {}
    }

    fileprivate func parseChecksum(_ data: Data) {
        do {
            let checksumBytes = try data.bytesInRange(NSMakeRange(14, 2))
            _checksum = UInt16(checksumBytes[0]) << 8 + UInt16(checksumBytes[1])
        } catch {}
    }

    fileprivate func parseTimestamp(_ data: Data) {
        do {
            let timestampBytes = try data.bytesInRange(NSMakeRange(16, 4))
            var time: Timestamp = 0
            for item in timestampBytes {
                time = time << 8 + UInt(item)
            }
            _timestamp = time
        } catch {}
    }
}
