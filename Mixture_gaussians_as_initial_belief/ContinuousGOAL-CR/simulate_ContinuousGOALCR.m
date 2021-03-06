function [StatisticsDCF, policies] = simulate_ContinuousGOALCR(span, mu1, mu2, sigma, prop1, prop2, execs)
    
    [dist, obj] = get_distribution(mu1, mu2, sigma, prop1, prop2, 0:span, false);   
    DCF = zeros(1, execs);
    
    str = sprintf('ContinuousGOAL-CR/OptimalPolicy_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);
    load(str);    
    
    policies = optimal_unrestricted_prob_set;
    T = length(optimal_unrestricted_prob_set);        
     
    for e = 1:execs
        if mod(e, 10) == 0
            e
        end
        K = ceil(random(obj));
        
        t = 1;    
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
                if t > T
                    tao = policies(T);                    
                else
                    tao = policies(t);                    
                end
                q = rand();
                if q <= tao
                    wanting_nodes = wanting_nodes + 1;
                end
            end        
            if wanting_nodes == 1
                K = K - 1;
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
    
    str = sprintf('ContinuousGOAL-CR/Results_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);  
    save(str,'DCF', 'StatisticsDCF');
