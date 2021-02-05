load("//scala:scala_grpc_compile.bzl", "scala_grpc_compile")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")
load("@io_bazel_rules_scala//scala_proto:default_dep_sets.bzl", "DEFAULT_SCALAPB_COMPILE_DEPS", "DEFAULT_SCALAPB_GRPC_DEPS")

def scala_grpc_library(**kwargs):
    # Compile protos
    name_pb = kwargs.get("name") + "_pb"
    scala_grpc_compile(
        name = name_pb,
        **{k: v for (k, v) in kwargs.items() if k in ("deps", "verbose")} # Forward args
    )

    # Create scala library
    scala_library(
        name = kwargs.get("name"),
        srcs = [name_pb],
        deps = GRPC_DEPS,
        exports = GRPC_DEPS,
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GRPC_DEPS = [
    # One dependency in this list is not valid outside of rules_scala workspace, fix up
    "@io_bazel_rules_scala" + dep if not dep.startswith("//external") else dep
    for dep in DEFAULT_SCALAPB_COMPILE_DEPS
] + DEFAULT_SCALAPB_GRPC_DEPS
