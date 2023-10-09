# Exercise 1
## My solution
function ex1(a)
    max_value = a[1]
    max_index = 1
    for (index, value) in enumerate(a)
        if (value > max_value)
            max_value = value
            max_index = index
        end
    end
    return (max_value, max_index)
end
## Professor's solution
function ex1(a)
    j = 1
    m = a[j]
    for (i, ai) in enumerate(a)
        if m < ai
            m = ai
            j = i
        end
    end
    (m, j)
end

# Exercise 2
## My solution
function ex2(f, g)
    return x -> f(x) + g(x)
end
## Professor's solution
ex2(f, g) = x -> f(x) + g(x)

# Exercise 3
## My solution
using GLMakie
x = LinRange(-0.7, 0.7, 1000)
y = LinRange(-1.2, 1.2, 1000)
z = [mandel(i, j, 10) for i in x, j in y]
heatmap(x, y, z)
## Professor's solution
using GLMakie
max_iters = 100
n = 1000
x = LinRange(-1.7, 0.7, n)
y = LinRange(-1.2, 1.2, n)
heatmap(x, y, (i, j) -> mandel(i, j, max_iters))
