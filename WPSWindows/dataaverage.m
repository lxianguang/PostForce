function [ndata] = dataaveraging(data)
    ndata  = zeros(size(data));
    datal2 = zeros(size(data));
    datal1 = zeros(size(data));
    datar1 = zeros(size(data));
    datar2 = zeros(size(data));
    
    datal2(3:end,  :) = data(1:end-2,:);
    datal1(2:end,  :) = data(1:end-1,:);
    datar1(1:end-1,:) = data(2:end,:  );
    datar2(1:end-2,:) = data(3:end,:  );
    
    ndata(1,       :) = (data(1,:)       + data(2,:)    )/2;
    ndata(2,       :) = (data(2,:)       + 0.5*(datal1(2,:      ) + datar1(2,:))    )/2;
    ndata(3:end-2, :) = (data(3:end-2,:) + 0.5*(datal2(3:end-2,:) + datar2(3:end-2,:)) + 0.5*(datal1(3:end-2,:) + datar1(3:end-2,:)))/3;
    ndata(end-1  , :) = (data(end-1,:)   + 0.5*(datal1(end-1,:  ) + datar1(end-1,:)))/2;
    ndata(end    , :) = (data(end,:)     + data(end-1,:))/2;
end
