function [StatisticsDCF, policies] = simulate_PerfectInformation(N, g, execs)
    rng default
    
    DCF = zeros(1, execs);
     
    for e = 1:execs
        if mod(e, 100) == 0
            e
        end
        
        % ----- Each node tries to access the resource after s slots ------
        % -- Therefore, each node has a diferent policy with s zeros at ---
        % -- the beginning. -----------------------------------------------
        
        async_starts = geornd(g, 1, N);     
        T = max(async_starts) + 1;   
        policies = zeros(N, T);

        for n = 1:N
            delay = async_starts(n);
            policies(n, 1 + delay:end) = 1;
        end

        status = ones(1, N);    % Each node starts with status 1 = active -
        t = 1;    
        while sum(status) > 0
            wanting_nodes = zeros(1, N);
            K = sum(status);
            for idx = 1:length(status)            
                if status(idx) == 1
                    if t > T
                        tao = policies(idx, T);
                    else
                        tao = policies(idx, t);
                    end
                    if tao > 0
                        tao = tao/K;
                        q = rand();
                        if q <= tao
                            wanting_nodes(idx) = 1;
                        end
                    end
                end
            end        
            if sum(wanting_nodes) == 1
                status(wanting_nodes == 1) = 0;
            end
            t = t + 1;             
        end
        DCF(e) = t;    
    end   

    m = mean(DCF);
    s = sqrt(var(DCF));
    min_value = min(DCF);
    max_value = max(DCF);
    t_value = 1.962;
    left = - t_value*s/sqrt(execs) + m;
    right = t_value*s/sqrt(execs) + m;
    StatisticsDCF = [m, s, left, right, min_value, max_value];

    str = sprintf('PerfectInformation/Results_%d_%d', N, g*1000);
    save(str,'DCF', 'StatisticsDCF', 'g');

