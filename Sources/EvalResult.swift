//public protocol EvalResultKind {
//  var clang: CXEvalResultKind { get }
//}
//
//public struct IntResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct FloatResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct ObjCStrLiteralResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct StrLiteralResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct CFStrResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct OtherResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
//public struct UnExposedResult: EvalResultKind {
//  let clang: CXEvalResultKind
//}
//
///// Converts a CXEvalResultKind to a EvalResultKind, returning `nil` if it was unsuccessful
//func convertEvalResultKind(_ clang: CXEvalResultKind) -> EvalResultKind? {
//  if <#clang thing is null?#> { return nil }
//  switch <#Get clang kind#> {
//  case CXEval_Int: return IntResult(clang: clang)
//  case CXEval_Float: return FloatResult(clang: clang)
//  case CXEval_ObjCStrLiteral: return ObjCStrLiteralResult(clang: clang)
//  case CXEval_StrLiteral: return StrLiteralResult(clang: clang)
//  case CXEval_CFStr: return CFStrResult(clang: clang)
//  case CXEval_Other: return OtherResult(clang: clang)
//  case CXEval_UnExposed: return UnExposedResult(clang: clang)
//  default: fatalError("invalid CXEvalResultKindKind \(clang)")
//  }
//}
