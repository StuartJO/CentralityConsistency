function Null = make_ConstrainedNull(adj)



if max(max(adj)) ~= 1
    weighted = 1;
else
    weighted = 0;
end

if weighted
    while 1
        Null = null_model_und_sign(adj,5,0.1);
        [~, k] = graphComponents(Null);
       if k == 1
           break
       end
    end        
else
    Null = randmio_und_connected(adj,50);
end