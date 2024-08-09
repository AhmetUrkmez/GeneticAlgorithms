Population <- function(N, d, lb, ub) {
    return(
        matrix(data = runif(N*d, min = lb, max = ub),
            nrow = N,
            ncol = d,
            byrow = TRUE)
        )
}

Objective <- function(population) {
    return(
        apply(population**2, 1, sum)
    )
}

Roulette <- function(objective, population, N, d) {
    objective <- 1/objective
    probs <- objective/sum(objective) 
    c.probs <- cumsum(probs)
    offspring <- matrix(nrow = N, ncol = d)

    for(i in 1: N) {
        offspring[i, ] <- population[which(c.probs >= runif(1))[1], ]
    }

    return(offspring)
}

RankSelection <- function(objective, population, N, d) {
    objective <- 1/objective
    probs <- rank(objective, ties.method = "min")/sum(objective)
    selected <- sample(objective, N, replace = TRUE, prob = probs)
    offspring <- matrix(nrow = N, ncol = d)

    for(i in 1: N) {
        if (length(population[objective == selected[i], ]) > d)
            offspring[i, ] <- population[objective == selected[i], ][1, ]
        else {
            offspring[i, ] <- population[objective == selected[i], ]
        }
    }

    return(offspring)
}

CrossOver <- function(offspring, N, d, p.cross) {
    pairs <- sample(N)

    for(i in 1: (N / 2)) {
        parent1 <- offspring[pairs[2*i-1], ]
        parent2 <- offspring[pairs[2*i], ]
        if (runif(1) < p.cross) {
            c.point <- sample(d - 1, 1)
            dummy <- parent1[(c.point + 1): d]
            parent1[(c.point + 1): d] <- parent2[(c.point + 1): d]
            parent2[(c.point + 1): d] <- dummy
            offspring[pairs[2*i-1], ] <- parent1
            offspring[pairs[2*i], ] <- parent2
        }
    }

    return(offspring)
}

Mutation <- function(N, d, offspring, lb, ub, delta, p.mutation) {
    offspring <- c(t(offspring))

    for (i in 1: (N*d)) {
        rn <- runif(1)
        if (rn < p.mutation) {
            rnm <- runif(1, -1, 1)
            offspring[i] <- offspring[i] + rnm*delta*(ub - lb)  
            if(offspring[i] < lb) {
                offspring[i] <- lb
            } else if (offspring[i] > ub) {
                offspring[i] <- ub
            }
        }
    }
    
    offspring <- matrix(offspring, nrow = N, byrow = TRUE)
    
    return(offspring)
}

GA <- function(N, d, lb, ub, p.cross, p.mutation, delta = .05, iter.bound = 100) {
    iter <- 0
    population <- Population(N, d, lb, ub)
    
    best_fitness <- Inf
    fitness_values <- numeric(iter.bound)

    while(iter < iter.bound) {
        objective <- Objective(population)

        if(min(objective) < best_fitness) {
            best_fitness <- min(objective)
            best_chromosome <- population[which(objective == min(objective)), ]
            fitness_values[iter + 1] <- best_fitness
        } else {
            fitness_values[iter + 1] <- best_fitness
        }

        if(iter < iter.bound/2) {
            offspring <- RankSelection(objective, population, N, d)
        } else {
           offspring <- Roulette(objective, population, N, d)
        }

        offspring <- CrossOver(offspring, N, d, p.cross)
        population <- Mutation(N, d, offspring, lb, ub, delta, p.mutation)

        iter <- iter + 1
    }

    plot(fitness_values, type = "l", lwd = 3, col = "navy blue", xlim = c(0, iter.bound),
        ylim = c(0, max(fitness_values) + .25), xlab = "iteration", ylab = "Objective")

    return(list("best.chromosome" = best_chromosome[c(1: d)],
                "best.fitness" = best_fitness,
                "fitness.values" = fitness_values))
}

GA(500, 10, -100, 100, .95, .05, .01)

Benchmark <- function(...) {
    fitness_values <- numeric(100)
    pb <- progress::progress_bar$new(
        format = "[:bar] :percent",
        total = 100, clear = FALSE, width = 60
        )

    start <- Sys.time()

    for(i in 1: 100) {
        fitness_values[i] <- GA(500, 8, -5, 5, .95, .05, .01, 100)$best.fitness
        pb$tick()
    }
    
    end <- Sys.time()

    return(list("mean.fitness" = mean(fitness_values),
                "var.fitness" = var(fitness_values),
                "max.fitness" = max(fitness_values),
                "time" = c(end-start)))
}

Benchmark()
