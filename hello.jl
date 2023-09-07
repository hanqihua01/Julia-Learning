using Distributed
addprocs(3)
@everywhere println("Hello, world! I am proc $(myid()) from $(nprocs())")
