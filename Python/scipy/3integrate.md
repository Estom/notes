## Breif
The scipy.integrate sub-package provides several integration techniques including an ordinary differential equation integrator.

```py
>>> help(integrate)
 Methods for Integrating Functions given function object.

   quad          -- General purpose integration.
   dblquad       -- General purpose double integration.
   tplquad       -- General purpose triple integration.
   fixed_quad    -- Integrate func(x) using Gaussian quadrature of order n.
   quadrature    -- Integrate with given tolerance using Gaussian quadrature.
   romberg       -- Integrate func using Romberg integration.

 Methods for Integrating Functions given fixed samples.

   trapz         -- Use trapezoidal rule to compute integral from samples.
   cumtrapz      -- Use trapezoidal rule to cumulatively compute integral.
   simps         -- Use Simpson's rule to compute integral from samples.
   romb          -- Use Romberg Integration to compute integral from
                    (2**k + 1) evenly-spaced samples.

   See the special module's orthogonal polynomials (special) for Gaussian
      quadrature roots and weights for other weighting factors and regions.

 Interface to numerical integrators of ODE systems.

   odeint        -- General integration of ordinary differential equations.
   ode           -- Integrate ODE using VODE and ZVODE routines.
```


## General integration (quad)
$$
I = \int_0^{4.5}f(x)dx
$$

```py
def f(x,y):
    pass
# 可以用lambda函数补充其他参数。
result = integrate.quad(lambda x:f(x,19), 0, 4.5)
```

## 带参数积分

$$
I(a,b)=\int_0^1ax^2+bxdx
$$
```
from scipy.integrate import quad
def integrand(x, a, b):
    return a*x**2 + bx

a = 2
b = 1
I = quad(integrand, 0, 1, args=(a,b))
I
(1.6666666666666667, 1.8503717077085944e-14)
```
## 使用单积分实现多重积分
$$
I_n=\int_0^{\infin}\int_1^{\infin}\frac{e^{-xt}}{t^n}dtdx=\frac{1}{n}
$$

```py
# 内层积分
from scipy.integrate import quad
def integrand(t, n, x):
    return np.exp(-x*t) / t**n

>>>
def expint(n, x):
    return quad(integrand, 1, np.inf, args=(n, x))[0]
# 外层积分

result = quad(lambda x: expint(3, x), 0, np.inf)
print(result)
(0.33333333324560266, 2.8548934485373678e-09)
```
## General multiple integration (dblquad, tplquad, nquad)¶

$$
I_n=\int_0^{\infin}\int_1^{\infin}\frac{e^{-xt}}{t^n}dtdx=\frac{1}{n}
$$
```
from scipy.integrate import quad, dblquad
def I(n):
    return dblquad(lambda t, x: np.exp(-x*t)/t**n, 0, np.inf, lambda x: 1, lambda x: np.inf)
```

## Gaussian quadrature

## Romberg Integration

## Integrating using Samples

## Faster integration using low-level callback functions

## Ordinary differential equations (solve_ivp)

