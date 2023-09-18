# Exercises1
function matmul_dist_3!(C,A,B)
    m = size(C,1)
    n = size(C,2)
    l = size(A,2)
    @assert size(A,1) == m
    @assert size(B,2) == n
    @assert size(B,1) == l
    @assert mod(m,nworkers()) == 0
    # Implement here
    inc = convert(Int,m/nworkers())
    z = zero(eltype(C))
    iw = 0
    @sync for i in 1:nworkers()
        Ai = A[(i-1)*inc+1:i*inc,:]
        iw += 1
        w = workers()[iw]
        ftr = @spawnat w begin
            Ci = fill(z,(inc,l))
            for ii in 1:inc
                for jj in 1:n
                    for kk in 1:l
                        @inbounds Ci[ii,jj] += Ai[ii,kk]*B[kk,jj]
                    end
                end
            end
            Ci
        end
        @async C[(i-1)*inc+1:i*inc,:] = fetch(ftr)
    end
    C
end