import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';

class ExecutionListByRecipeResponse {
  final List<Execution> completedExecutions;
  final List<Execution> pendingExecutions;

  ExecutionListByRecipeResponse(
      {required this.completedExecutions, required this.pendingExecutions});
  factory ExecutionListByRecipeResponse.empty() {
    return ExecutionListByRecipeResponse(
        pendingExecutions: [], completedExecutions: []);
  }

  Map<String, dynamic> toJson() => {
        'completedExecutions': completedExecutions
            .map((execution) => execution.toProto3Json())
            .toList(),
        'pendingExecutions': pendingExecutions
            .map((execution) => execution.toProto3Json())
            .toList()
      };

  factory ExecutionListByRecipeResponse.fromJson(Map<String, dynamic> json) {
    return ExecutionListByRecipeResponse(
        pendingExecutions: List.from(json['pendingExecutions'])
            .map((execution) =>
                Execution.create()..mergeFromProto3Json(execution))
            .toList(),
        completedExecutions: List.from(json['completedExecutions'])
            .map((execution) =>
                Execution.create()..mergeFromProto3Json(execution))
            .toList());
  }

  @override
  String toString() {
    return 'ExecutionListByRecipeResponse{completedExecutions: $completedExecutions, pendingExecutions: $pendingExecutions}';
  }
}
