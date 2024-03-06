//
//  Digest.swift
//  SwiftCommonCrypto
//
//  Created by idz on 9/19/14.
//  Copyright (c) 2014 iOS Developer Zone. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - Public Interface
 /**
  Public API for message digests.

  Usage is straightforward

    ````
    let  s = "The quick brown fox jumps over the lazy dog."
    var md5 : Digest = Digest(algorithm:.MD5)
    md5.update(s)
    let digest = md5.final()
    ````
  */
open class Digest : Updateable
{
    ///
    /// The status of the Digest.
    /// For CommonCrypto this will always be `.Success`.
    /// It is here to provide for engines which can fail.
    ///
    open var status = Status.success

    ///
    /// Enumerates available Digest algorithms
    ///
    public enum Algorithm
    {
        /// Secure Hash Algorithm 2 256-bit
        case sha256,
        /// Secure Hash Algorithm 2 384-bit
        sha384,
        /// Secure Hash Algorithm 2 512-bit
        sha512
    }

    var engine: DigestEngine
    /**
       Create an algorithm-specific digest calculator
       - parameter alrgorithm: the desired message digest algorithm
     */
    public init(algorithm: Algorithm)
    {
        switch algorithm {
        case .sha256:
            engine = DigestEngineCC<CC_SHA256_CTX>(initializer:CC_SHA256_Init, updater:CC_SHA256_Update, finalizer:CC_SHA256_Final, length:CC_SHA256_DIGEST_LENGTH)
        case .sha384:
            engine = DigestEngineCC<CC_SHA512_CTX>(initializer:CC_SHA384_Init, updater:CC_SHA384_Update, finalizer:CC_SHA384_Final, length:CC_SHA384_DIGEST_LENGTH)
        case .sha512:
            engine = DigestEngineCC<CC_SHA512_CTX>(initializer:CC_SHA512_Init, updater:CC_SHA512_Update, finalizer:CC_SHA512_Final, length:CC_SHA512_DIGEST_LENGTH)
        }
    }
    /**
        Low-level update routine. Updates the message digest calculation with
        the contents of a byte buffer.

        - parameter buffer: the buffer
        - parameter the: number of bytes in buffer
        - returns: this Digest object (for optional chaining)
    */
    open func update(buffer: UnsafeRawPointer, byteCount: size_t) -> Self?
    {
        engine.update(buffer: buffer, byteCount: CC_LONG(byteCount))
        return self
    }

    /**
       Completes the calculate of the messge digest
       - returns: the message digest
     */
    open func final() -> [UInt8]
    {
        return engine.final()
    }
}

// MARK: Internal Classes

/**
 * Defines the interface between the Digest class and an
 * algorithm specific DigestEngine
 */
protocol DigestEngine
{
    func update(buffer: UnsafeRawPointer, byteCount: CC_LONG)
    func final() -> [UInt8]
}
/**
 * Wraps the underlying algorithm specific structures and calls
 * in a generic interface.
 */
class DigestEngineCC<C> : DigestEngine {
    typealias Context = UnsafeMutablePointer<C>
    typealias Buffer = UnsafeRawPointer
    typealias Digest = UnsafeMutablePointer<UInt8>
    typealias Initializer = (Context) -> (Int32)
    typealias Updater = (Context, Buffer, CC_LONG) -> (Int32)
    typealias Finalizer = (Digest, Context) -> (Int32)

    let context = Context.allocate(capacity: 1)
    var initializer : Initializer
    var updater : Updater
    var finalizer : Finalizer
    var length : Int32

    init(initializer : @escaping Initializer, updater : @escaping Updater, finalizer : @escaping Finalizer, length : Int32)
    {
        self.initializer = initializer
        self.updater = updater
        self.finalizer = finalizer
        self.length = length
        _ = initializer(context)
    }

    deinit
    {
        context.deallocate()
    }

    func update(buffer: Buffer, byteCount: CC_LONG)
    {
        _ = updater(context, buffer, byteCount)
    }

    func final() -> [UInt8]
    {
        let digestLength = Int(self.length)
        var digest = Array<UInt8>(repeating: 0, count: digestLength)
        _ = finalizer(&digest, context)
        return digest
    }
}
