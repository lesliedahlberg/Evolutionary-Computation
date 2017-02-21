function x = SnakeTest(weights, dimension, verbose)
    %dimension = [5, 5];
    snake_length = 1;
    snake_init_head = [dimension(1)/2, dimension(2)/2];
    snake = [floor(snake_init_head)];
    direction = [-1, 0];
    alive = true;
    grow = false;
    %food = zeros(dimension(1), dimension(2));
    
    food_eaten = 0;
    moves_made = 0;
    
    starv_th = dimension(1)*dimension(2);
    starvation = starv_th;
    
    %new_food = randi(10, 1, 2);
    %food(new_food(1), new_food(2)) = 1;
    food = randi(min(dimension(1), dimension(2)), 1, 2);
    
    
    
    inputSize = 9;
    hiddenSize = floor(inputSize/2);
    outputSize = 4;
    layers = [inputSize,hiddenSize,outputSize];
    dim = NeuralNetworkSize(layers);
    %weights = rand(1, dim);
    
    function l = render_snake()
        game = zeros(dimension(1), dimension(2));
        
        for ii=1:snake_length
            if ii == 1
                game(snake(ii,1), snake(ii,2)) = 2;
            else
                game(snake(ii,1), snake(ii,2)) = 1;
            end
            
        end
        
        game(food(1), food(2)) = -1;
        snake
        game
    end

    function d = get_ai_direction(rep)
        
        rep_t = reshape(rep, [1 9]);
        output = NeuralNetwork(rep_t, weights, layers);
        
        d = [ 0, 0 ];
        
        [m,mi] = max(output);
        
        if mi == 1
            d = [ 1, 0];
        end
        
        if mi == 2
            d = [ -1, 0];
        end
        
        if mi == 3
            d = [ 0, 1];
        end
        
        if mi == 4
            d = [ 0, -1];
        end
       
    end

    function rep = get_representation()
        rep = zeros(3,3);
        if food(1) <= snake(1,1)
            if food(2) <= snake(1,2)
                rep(1,1) = 1;
            else
                rep(1,3) = 1;
            end
        else
            if food(2) <= snake(1,2)
                rep(3,1) = 1;
            else
                rep(3,3) = 1;
            end
        end
        
        for k=2:snake_length
            if snake(k,1) <= snake(1,1)
                rep(1,2) = -1;
            else
                rep(3,2) = -1;
            end
            
            if snake(k,2) <= snake(1,2)
                rep(2,1) = -1;
            else
                rep(2,3) = -1;
            end
        end
    end
    
    while alive
        if verbose == true
            render_snake();
        end
        old_direction = direction;
        direction = get_ai_direction(get_representation());
        
        self_invert = false;
        
        %if (direction(1) == -old_direction(1) && direction(2) == old_direction(2)) ||  (direction(2) == -old_direction(2) && direction(1) == old_direction(1)) && snake_length > 1
            if snake_length > 1
                if (direction(1) == -old_direction(1) && direction(2) == old_direction(2) && direction(1) ~= 0) || (direction(2) == -old_direction(2) && direction(1) == old_direction(1) && direction(2) ~= 0)
                    self_invert = true;
                end
            end
        %end
        
        new_head = snake(1,:) + direction;
        if new_head(1) < 1 || new_head(1) > dimension(1) || new_head(2) < 1 || new_head(2) > dimension(2) || self_invert == true
            alive = false;
            %disp('Kill for out-of-bound OR self-inversion');
        else
            for i=2:snake_length
                if snake(i,1) == snake(1,1) && snake(i,2) == snake(1,2)
                    alive = false;
                end
            end
            if grow
                snake = [new_head; snake];
                grow = false;
                snake_length = snake_length + 1;
            else
                if snake_length > 1
                    new_tail = snake(1:snake_length-1,:);
                else
                    new_tail = [];
                end
                snake = [new_head; new_tail];
            end
            if food(1) == snake(1,1) && food(2) == snake(1,2)
                grow = true;
                food_eaten = food_eaten + 1;
                food = randi(10, 1, 2);
                starvation = starvation + starv_th;
            end
            
            moves_made = moves_made + 1;
            starvation = starvation - 1;
        end
        if starvation < 1
            alive = false;
        end
    end
    
    %x = food_eaten + min(moves_made, max(dimension));
    x = food_eaten + sigmoid(moves_made)-0.5;
    
end


