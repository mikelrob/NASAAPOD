@testable import Nimble
import Quick
import XCTest
import Foundation

/// Replacement for Quick's `it` which runs using swift concurrency.
public func asyncIt(
    _ description: String,
    flags: FilterFlags = [:],
    file: StaticString = #file,
    line: UInt = #line,
    closure: @MainActor @escaping () async throws -> Void
) {
    it(description, flags: flags, file: file, line: line) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = QuickSpec.current.expectation(description: description)

        Task {
            do {
                try await closure()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        QuickSpec.current.wait(for: [expectation], timeout: 60)

        if let error = thrownError {
            XCTFail("Async error thrown: \(error)", file: file, line: line)
        }
    }
}

/// Replacement for Quick's `fit` which runs using swift concurrency.
public func asyncFit(
    _ description: String,
    flags: FilterFlags = [:],
    file: StaticString = #file,
    line: UInt = #line,
    closure: @MainActor @escaping () async throws -> Void
) {
    fit(description, flags: flags, file: file, line: line) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = QuickSpec.current.expectation(description: description)

        Task {
            do {
                try await closure()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        QuickSpec.current.wait(for: [expectation], timeout: 60)

        if let error = thrownError {
            XCTFail("Async error thrown: \(error)", file: file, line: line)
        }
    }
}

/// Replacement for Quick's `beforeEach` which runs using swift concurrency.
public func asyncBeforeEach(_ closure: @MainActor @escaping (ExampleMetadata) async -> Void) {
    beforeEach({ exampleMetadata in
        let expectation = QuickSpec.current.expectation(description: "asyncBeforeEach")
        Task {
            await closure(exampleMetadata)
            expectation.fulfill()
        }
        QuickSpec.current.wait(for: [expectation], timeout: 60)
    })
}

/// Replacement for Quick's `afterEach` which runs using swift concurrency.
public func asyncAfterEach(_ closure: @MainActor @escaping (ExampleMetadata) async -> Void) {
    afterEach({ exampleMetadata in
        let expectation = QuickSpec.current.expectation(description: "asyncAfterEach")
        Task {
            await closure(exampleMetadata)
            expectation.fulfill()
        }
        QuickSpec.current.wait(for: [expectation], timeout: 60)
    })
}

/// Replacement for Nimble's `waitUntil` which waits using swift concurrency.
func waitUntilAsync<R>(
    timeout: DispatchTimeInterval = AsyncDefaults.timeout,
    action: @escaping () async throws -> R
) async throws -> R {
    return try await withThrowingTaskGroup(of: R.self) { group in
        group.addTask {
            return try await action()
        }

        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(timeout.timeInterval * 1_000_000_000))
            throw CancellationError()
        }

        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}

extension Expectation {

    /// Replacement for Nimble's `toEventually` which waits using swift concurrency.
    @MainActor
    func toAsyncEventually(
        _ predicate: Predicate<T>,
        timeout: DispatchTimeInterval = AsyncDefaults.timeout,
        pollInterval: DispatchTimeInterval = AsyncDefaults.pollInterval,
        description: String? = nil
    ) async {
        await innerAsyncEventually(style: .toMatch, predicate, timeout: timeout, pollInterval: pollInterval, description: description)
    }

    /// Replacement for Nimble's `toEventuallyNot` which waits using swift concurrency.
    @MainActor
    func toAsyncEventuallyNot(
        _ predicate: Predicate<T>,
        timeout: DispatchTimeInterval = AsyncDefaults.timeout,
        pollInterval: DispatchTimeInterval = AsyncDefaults.pollInterval,
        description: String? = nil
    ) async {
        await innerAsyncEventually(style: .toNotMatch, predicate, timeout: timeout, pollInterval: pollInterval, description: description)
    }

    @MainActor
    private func innerAsyncEventually(
        style: ExpectationStyle,
        _ predicate: Predicate<T>,
        timeout: DispatchTimeInterval = AsyncDefaults.timeout,
        pollInterval: DispatchTimeInterval = AsyncDefaults.pollInterval,
        description: String? = nil
    ) async {

        let msg = FailureMessage()
        msg.userDescription = description
        msg.to = "to eventually"

        let uncachedExpression = expression.withoutCaching()
        var lastPredicateResult: PredicateResult?
        do {
            try await waitUntilAsync(timeout: timeout) { @MainActor in
                var hasCompleted = false
                while !hasCompleted {
                    let result = try predicate.satisfies(uncachedExpression)
                    hasCompleted = result.toBoolean(expectation: style)
                    lastPredicateResult = result
                    try await Task.sleep(nanoseconds: UInt64(pollInterval.timeInterval * 1_000_000_000))
                }
            }
        } catch is CancellationError {
            // Async function timedout, error formatting handled as a normal completion
        } catch {
            msg.stringValue = "unexpected error thrown: <\(error)>"
            verify(false, msg)
            return
        }

        let result = lastPredicateResult ?? PredicateResult(status: .fail, message: .fail("timed out before returning a value"))
        // Note: update is an internal function which I've manually changed to public
        result.message.update(failureMessage: msg)
        if msg.actualValue == "" {
            msg.actualValue = "<\(stringify(try? expression.evaluate()))>"
        }
        let passed = result.toBoolean(expectation: style)
        verify(passed, msg)
    }
}

fileprivate extension DispatchTimeInterval {
    var timeInterval: TimeInterval {
        switch self {
        case let .seconds(s):
            return TimeInterval(s)
        case let .milliseconds(ms):
            return TimeInterval(TimeInterval(ms) / 1000.0)
        case let .microseconds(us):
            return TimeInterval(Int64(us)) * TimeInterval(NSEC_PER_USEC) / TimeInterval(NSEC_PER_SEC)
        case let .nanoseconds(ns):
            return TimeInterval(ns) / TimeInterval(NSEC_PER_SEC)
        case .never:
            return .infinity
        @unknown default:
            return .infinity
        }
    }
}
