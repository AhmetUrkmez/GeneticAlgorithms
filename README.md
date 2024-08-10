## Genetic Algorithms

**Objective Function**

$MinZ = \sum_{i=1}^8 x_{i}^2$

**Components of Algorithm**

+ Selection
+ Crossover
+ Mutation(Value Based)

**Parameters of Algorithm**

+ Population Size
+ Dimension
+ Lower Bound
+ Upper Bound
+ Crossover Rate
+ Mutation
    + Rate
    + Delta
+ Iteration Bound

**Benchmark Results**

```r
GA(500, 8, -5, 5, 0.95, 0.05, 0.01, 100)
```

| Selection Type | Descriptive Statistics | Time |
| --- | --- | --- |
| Roulette | Mean: $6.06\times{10}^{-6}$ <br> Variance: $8.20\times{10}^{-11}$ <br> Max: $6.83\times{10}^{-5}$ | $3.38$ mins
| Rank  | Mean: $1.24\times{10}^{-5}$ <br> Variance: $5.58\times{10}^{-11}$ <br> Max: $3.67\times{10}^{-5}$ | $3.77$ mins
| Hybrid <br> (Rank + Roulette)  | Mean: $3.28\times{10}^{-6}$ <br> Variance: $5.85\times{10}^{-12}$ <br> Max: $1.34\times{10}^{-5}$ | $3.26$ mins
