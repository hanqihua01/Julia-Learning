# Exercise 1
## Professor's solution
@everywhere workers() begin
    using MPI
    comm = MPI.Comm_dup(MPI.COMM_WORLD)
    function jacobi_mpi(n, niters)
        nranks = MPI.Comm_size(comm)
        rank = MPI.Comm_rank(comm)
        if mod(n, nranks) != 0
            println("n must be a multiple of nranks")
            MPI.Abort(comm, 1)
        end
        n_own = div(n, nranks)
        u = zeros(n_own + 2)
        u[1] = -1
        u[end] = 1
        u_new = copy(u)
        for t in 1:niters
            reqs = MPI.Request[]
            if rank != 0
                neig_rank = rank - 1
                req = MPI.Isend(view(u, 2:2), comm, dest=neig_rank, tag=0)
                push!(reqs, req)
                req = MPI.Irecv!(view(u, 1:1), comm, source=neig_rank, tag=0)
                push!(reqs, req)
            end
            if rank != (nranks - 1)
                neig_rank = rank + 1
                s = n_own + 1
                r = n_own + 2
                req = MPI.Isend(view(u, s:s), comm, dest=neig_rank, tag=0)
                push!(reqs, req)
                req = MPI.Irecv!(view(u, r:r), comm, source=neig_rank, tag=0)
                push!(reqs, req)
            end
            for i in 3:n_own
                u_new[i] = 0.5 * (u[i-1] + u[i+1])
            end
            MPI.Waitall(reqs)
            for i in (2, n_own + 1)
                u_new[i] = 0.5 * (u[i-1] + u[i+1])
            end
            u, u_new = u_new, u
        end
        return u
    end
end