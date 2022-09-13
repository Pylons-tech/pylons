<!--
order: 3
-->

# Events

The `epochs`  module emits Cosmos SDK `TypedEvent`s in the form of proto messages to provide state updates for applications like block explorers.

The `epochs` module emits the following events:

## EventBeginEpoch

Emitted when an epoch begins.

```protobuf
message EventBeginEpoch {
  int64 current_epoch = 1;
  google.protobuf.Timestamp start_time = 2 [
    (gogoproto.stdtime) = true,
    (gogoproto.nullable) = false,
    (gogoproto.moretags) = "yaml:\"start_time\""
  ];
}
```

## EventEndEpoch

Emitted when an epoch ends.

```protobuf
message EventEndEpoch {
  int64 current_epoch = 1;
}
```

These two events in tandem can be used to calculate epoch running time.