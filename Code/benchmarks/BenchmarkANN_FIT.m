clc
ALG = {@DE @PSO @EDA_UMDA @DEDA};
algorithms = 4;
algNames = {'DE' 'PSO' 'UMDA' 'DEDA'};

[xxxx{1},tt{1}] = simplefit_dataset;
[xxxx{2},tt{2}] = bodyfat_dataset; 
[xxxx{3},tt{3}] = chemical_dataset;
[xxxx{4},tt{4}] = cho_dataset;
[xxxx{5},tt{5}] = engine_dataset;
[xxxx{6},tt{6}] = house_dataset;
setNames = {'simple' 'bodyfat' 'chemical' 'cho' 'engine' 'house'};
%setNames = {'simple'};

datasets = 6;

objectiveValue = 0;
individuals = 50;
generations = 250;
lower = -1;
upper = 1;
repeat = 5;

v = ones(datasets,algorithms);
s = ones(datasets,algorithms);
tic
for ds=1:datasets
    xx = xxxx{ds};
    t = tt{ds};

    inputSize = size(xx,1);
    hiddenSize = inputSize;
    outputSize = size(t,1);

    layers = [inputSize,hiddenSize,outputSize];
    ds
    dim = NeuralNetworkSize(layers)
    
    g = generations;
    
    for alg=1:algorithms
        mins = zeros(1, repeat);
        fprintf(strcat('\ta=',num2str(alg)));
        
        for r=1:repeat
            
            eval = @(x)ann_dataset_sse(x, layers, xx, t);
            [success, iterations, minimum, value] = ALG{alg}(eval, dim, lower, upper, g, individuals, objectiveValue);
            
            mins(r) = value;
            fprintf('*');
        end
        v(ds,alg) = mean(mins);
        s(ds,alg) = std(mins);
        fprintf('\n');
        
        
    end
    
end
time = toc

tm = table(v(:,1), v(:,2), v(:,3), v(:,4), 'RowNames', setNames, 'VariableNames', algNames)
td = table(s(:,1), s(:,2), s(:,3), s(:,4), 'RowNames', setNames, 'VariableNames', algNames)

writetable(tm,strcat('ann_fit_mean.xlsx'));
writetable(td,strcat('ann_fit_dev.xlsx'));