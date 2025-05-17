enum ErrorType {
  badRequest, // 400
  unauthorized, // 401
  forbidden, // 403
  notFound, // 404
  conflict, // 409
  validationError, // 422
  serverError, // 500
  connectionError, // 네트워크 오류
  unknown, // 기타
}
