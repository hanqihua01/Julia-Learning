# Exercise 1
## My solution
using Distributed
using MPI
using MPIClusterManagers
if procs() == workers()
    nranks = 3
    manager = MPIWorkerManager(nranks)
    addprocs(manager)
end
@everywhere workers() begin
    using MPI
    MPI.Init()
    comm = MPI.COMM_WORLD
    nranks = MPI.Comm_size(comm)
    rank = MPI.Comm_rank(comm)
    println("Hello, I am process $rank of $nranks processes!")
end
@everywhere workers() begin
    comm = MPI.Comm_dup(MPI.COMM_WORLD)
    rank = MPI.Comm_rank(comm)
    nranks = MPI.Comm_size(comm)
    snder = rank == 0 ? (nranks - 1) : (rank - 1)
    rcver = rank == (nranks - 1) ? 0 : (rank + 1)
    buffer = Ref(0)
    if rank == 0
        msg = 0
        println("Rank$rank is sending: $msg")
        buffer[] = msg
        MPI.Send(buffer, comm; dest=rcver, tag=0)
        MPI.Recv!(buffer, comm, source=snder, tag=0)
        msg = buffer[]
        println("Rank$rank has received: $msg")
    else
        MPI.Recv!(buffer, comm, source=snder, tag=0)
        msg = buffer[]
        println("Rank$rank has received: $msg")
        msg = msg + 1
        println("Rank$rank is sending: $msg")
        buffer[] = msg
        MPI.Send(buffer, comm; dest=rcver, tag=0)
    end
end
## Professor's solution
using MPI
MPI.Init()
comm = MPI.Comm_dup(MPI.COMM_WORLD)
rank = MPI.Comm_rank(comm)
nranks = MPI.Comm_size(comm)
buffer = Ref(0)
if rank == 0
    msg = 2
    buffer[] = msg
    println("msg = $(buffer[])")
    MPI.Send(buffer, comm; dest=rank + 1, tag=0)
    MPI.Recv!(buffer, comm; source=nranks - 1, tag=0)
    println("msg = $(buffer[])")
else
    dest = if (rank != nranks - 1)
        rank + 1
    else
        0
    end
    MPI.Recv!(buffer, comm; source=rank - 1, tag=0)
    buffer[] += 1
    println("msg = $(buffer[])")
    MPI.Send(buffer, comm; dest, tag=0)
end

# Exercise 2
## My solution
using Distributed
addprocs(2)
num = nprocs()
chnls = [RemoteChannel(() -> Channel{Int}(1)) for i in 1:num]
msg = 1
put!(chnls[1], msg)
println("Proc1 is sending: $msg")
for i in 2:num
    @spawnat i begin
        msg = take!(chnls[i-1])
        println("Proc$i has received: $msg")
        msg = msg + 1
        put!(chnls[i], msg)
        println("Proc$i is sending: $msg")
    end
end
msg = take!(chnls[num])
println("Proc1 has received: $msg")
## Professor's solution
f = () -> Channel{Int}(1)
chnls = [RemoteChannel(f, w) for w in workers()]
@sync for (iw, w) in enumerate(workers())
    @spawnat w begin
        chnl_snd = chnls[iw]
        if w == 2
            chnl_rcv = chnls[end]
            msg = 2
            println("msg = $msg")
            put!(chnl_snd, msg)
            msg = take!(chnl_rcv)
            println("msg = $msg")
        else
            chnl_rcv = chnls[iw-1]
            msg = take!(chnl_rcv)
            msg += 1
            println("msg = $msg")
            put!(chnl_snd, msg)
        end
    end
end
