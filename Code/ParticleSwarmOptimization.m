function [ success, iterations, minimum, value ] = ParticleSwarmOptimization( CostFunction, dimension, lowerBound, upperBound, maxIterations, populationSize, objectiveValue )
    vmax = (abs(upperBound)+abs(lowerBound))/2/100;
    omega = 0.8;
    c1 = 2;
    c2 = 2;
    
    %Init population
    position = lowerBound + (upperBound - lowerBound) * rand(populationSize, dimension);
    best = position;
    bestValue = zeros(1,populationSize);
    for i=1:populationSize
        bestValue = CostFunction(best);
    end
    globalBest = best(1,:);
    globalBestValue = CostFunction(globalBest);
    velocity = -vmax + (vmax + vmax) * rand(populationSize, dimension);
    
    iterations = 0;
    while (globalBestValue > objectiveValue) && (iterations < maxIterations)
        %track(iterations+1) = globalBestValue;
        for i = 1:populationSize
            cost = CostFunction(position(i,:));
            if cost <= bestValue(i)
                best(i,:) = position(i,:);
                bestValue(i) = cost;
                if cost <= globalBestValue
                    globalBest = best(i,:);
                    globalBestValue = bestValue(i);
                    %disp(globalBestValue);
                end
            end
        end
        
        %Update
        for i = 1:populationSize
            f1 = rand(1,dimension);
            f2 = rand(1,dimension);
            velocity(i,:) = omega * velocity(i,:) + c1 * f1 .* (best(i,:) - position(i,:)) + c2 * f2 .* (globalBest - position(i,:));
            position(i,:) = position(i,:) + velocity(i,:);
        end
        
        iterations = iterations + 1;
    end
    
    if globalBestValue <= objectiveValue
        success = true;
    else
        success = false;
    end
    minimum = globalBest(1,:);
    value = globalBestValue;
    
    %plot(1:iterations, track)
    
end
