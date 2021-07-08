# Task

Simple library to manage and throttle `Task`s.

## Definitions

A `Task` is as simple as an entity which executes on demand and calls a completion handler when done.
This is analogous to the `Runnable` interface in Java.

A `TaskManager` can run a single `Task` at a time. It also, if required, can handle throttling and invalidating old `Task`s.
A common use case is when searching and hitting an API when the text updates.
