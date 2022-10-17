enum MockError: Error {
    case createDirectoryError(String)
    case moveItemError(String)
    case removeItemError(String)
    case cacheSaveError(String)
    case networkError(String)
}
