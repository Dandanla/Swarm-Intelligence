function [trace,xbest,Cost,Rou,TimeUse,LoadRank,CarUse] = PSO(x,xfit,xCost,xRou,xTimeUse,xLoadRank,xCarUse)
%PSO—∞”≈
LoadGlobal;
w = 3;
c1 = 1.5;c2=1.5;
vmax = 5;vmin = -5;
v = rand(NP,D)*(vmax-vmin)+vmin;
[trace(1),index] = min(xfit);
xbest = x(index,:);
Cost(1) = xCost(index);
Rou(1) = xRou(index);
TimeUse(1) = xTimeUse(index);
LoadRank(1) = mean(xLoadRank(index,:));
CarUse(1) = xCarUse(index);
gCost = xCost(index);
gRou = xRou(index);
gTimeUse = xTimeUse(index);
gLoadRank = mean(xLoadRank(index,:));
gCarUse = xCarUse(index);
g = 1;
gfit = xfit(index);
pbest = x;
pfit = xfit;
while g < G
    for i = 1:NP
        if g==1
            break;
        end
        if xfit(i) < pfit(i)
            pbest(i,:) = x(i,:);
            pfit(i) = xfit(i);
        end
        if gfit > xfit(i)
            xbest = x(i,:);
            gfit = xfit(i);
            gCost = xCost(i);
            gRou = xRou(i);
            gTimeUse = xTimeUse(i);
            gLoadRank = mean(xLoadRank(i,:));
            gCarUse = xCarUse(i);
        end
    end
    for i = 1:NP
        v(i,:) = w.*v(i,:)+c1*rand.*(xbest-x(i,:))+c2*rand.*(pbest(i,:)-x(i,:));
        x(i,:) = floor(x(i,:)+v(i,:));
        for j = 1:D
            if v(i,j) > vmax || v(i,j) <vmin
                v(i,j) = rand*(vmax-vmin)+vmin;
            end
            if OrderBound(j)
                if x(i,j) <= 0 || x(i,j) > SmallCar
                    x(i,j) = randi([1,SmallCar],1,1);
                end
            else
                if x(i,j) <= 0 || x(i,j) > CarNum
                    x(i,j) = randi([1,CarNum],1,1);
                end
            end
        end
    end
    for i = 1:NP
        [xfit(i),xCost(i),xRou(i),xTimeUse(i),xLoadRank(i,:),xCarUse(i)] = fitness(x(i,:));
    end
    g = g+1;
    trace(g) = gfit;
    Cost(g) = gCost;
    Rou(g) = gRou;
    TimeUse(g) = gTimeUse;
    LoadRank(g) = gLoadRank;
    CarUse(g) = gCarUse;
end
end

