# Implement a function ex1(a) that finds the largest item in the array a.
# It should return the largest item and its corresponding position in the array.
# If there are multiple maximal elements, then the first one will be returned. 
# Assume that the array is not empty.
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

# Implement a function ex2(f,g) that takes two functions f(x) and g(x) and returns a new function h(x) representing the sum of f and g, i.e., h(x)=f(x)+g(x).
function ex2(f, g)
    return x -> f(x) + g(x)
end

# Function mandel estimates if a given point (x,y) in the complex plane belongs to the Mandelbrot set.
function mandel(x, y, max_iters)
    z = Complex(x, y)
    c = z
    threshold = 2
    for n in 1 : max_iters
        if abs(z) > threshold
            return n - 1
        end
        z = z^2 + c
    end
    max_iters
end
# If the value of mandel is less than max_iters, the point is provably outside the Mandelbrot set. If mandel is equal to max_iters, then the point is provably inside the set. The larger max_iters, the better the quality of the estimate (the nicer will be your plot).
# Plot the value of function mandel for each pixel in a 2D grid of the box.
# (-0.7,0.7) x (-1.2,1.2)
# Use a grid resolution of at least 1000 points in each direction and max_iters at least 10. You can increase these values to get nicer plots. To plot the values use function heatmap from the Julia package GLMakie. Use LinRange to divide the horizontal and vertical axes into pixels. See the documentation of these functions for help. GLMakie is a GPU-accelerated plotting back-end for Julia. It is a large package and it can take some time to install and to generate the first plot. Be patient.
# # Implement here
using GLMakie
x = LinRange(-0.7, 0.7, 1000)
y = LinRange(-1.2, 1.2, 1000)
z = [mandel(i, j, 10) for i in x, j in y]
heatmap(x, y, z)
