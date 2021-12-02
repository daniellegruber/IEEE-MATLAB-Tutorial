%% Description
% Simulates spontaneous brain activity based on paper "An Evolutionary Game
% Theory Model of Spontaneous Brain Functioning" (Madeo et al., 2017)
%
% Find info on parameters adjMatrix, propensity1 = propensity2, activations
% (all generated randomly in this script) in paper

%% Set options
numNodes = 10;
maxStrength = 10;
numIter = 1;
% tspan = [0 15];
tRes = 0.1;
tspan = 0:tRes:15;


%% Start simulation
for i = 1:numIter

%% Create adjacency matrix
% weights must be greater than equal to 0, with magnitude corresponding to
% strength of influence region v has on region w

adjMatrix = random('Exponential',1,numNodes);

figure('units','normalized','outerposition',[0 0 0.6 1]);image(adjMatrix)
xticks(5:5:numNodes);
xticklabels(string(5:5:numNodes));
yticks(5:5:numNodes);
yticklabels(string(5:5:numNodes));
xlabel('Area (v)')
ylabel('Area (w)')
title('Adjacency Matrix','FontSize',60,'FontName','Times New Roman')
set(gca,'FontSize',40,'FontName','Times New Roman')
set(gca,'TickLength',[0 0])
colormap(jet(maxStrength+1))
colorbar('Ticks',1.5:2:maxStrength+1.5,'TickLabels',string(0:2:maxStrength),'TickLength',0)
set(gcf,'color','w')

%% Calculate propensity values
% propensity for node v to fire when node w fires

propensity1 = randsample([-1:1],numNodes^2,true);
propensity1 = reshape(propensity1,numNodes,numNodes);
propensity2 = propensity1;
for n = 1:numNodes
    propensity1(n,n) = 0;
    propensity2(n,n) = 0;
end


figure('units','normalized','outerposition',[0 0 0.6 1]); image(propensity1+2)
xticks(5:5:numNodes);
xticklabels(string(5:5:numNodes));
yticks(5:5:numNodes);
yticklabels(string(5:5:numNodes));
xlabel('Area (v)')
ylabel('Area (w)')
title('Propensity Matrix','FontSize',60,'FontName','Times New Roman')
set(gca,'FontSize',40,'FontName','Times New Roman')
set(gca,'TickLength',[0 0])
colormap(jet(3))
ticks = -1:1;
colorbar('Ticks',1.5:3.5,'TickLabels',string(ticks),'TickLength',0)
set(gcf,'color','w')

%% Calculate payoffs for activation/inactivation
% starting activations

activationDivider = 10;
activations = randsample(0:activationDivider,numNodes,true)/activationDivider;


activationPayoffs = zeros(numNodes);
inactivationPayoffs = zeros(numNodes);
for v = 1:numNodes
    for w = 1:numNodes
    activationPayoffs(v,w) = activations(w)*propensity1(v,w); 
    % the payoff for v activating when w activates is activationPayoffs(v,w)
    inactivationPayoffs(v,w) = (1-activations(w))*propensity2(v,w);
    % the payoff for v inactivating when w inactivates is inactivationPayoffs(v,w)
    end
end
payoffDiffs = activationPayoffs - inactivationPayoffs;

%% Display signed adjacency matrix
figure('units','normalized','outerposition',[0 0 0.6 1]); image(adjMatrix.*propensity1+maxStrength+1)
xticks(5:5:numNodes);
xticklabels(string(5:5:numNodes));
yticks(5:5:numNodes);
yticklabels(string(5:5:numNodes));
xlabel('Area (v)')
ylabel('Area (w)')
title('Signed Adjacency Matrix','FontSize',60,'FontName','Times New Roman')
set(gca,'FontSize',40,'FontName','Times New Roman')
set(gca,'TickLength',[0 0])
colormap(jet(length(-maxStrength:maxStrength)))
colorbar('Ticks',(1.5:5:maxStrength*2+1.5),'TickLabels',string(-maxStrength:5:maxStrength),'TickLength',0)
set(gcf,'color','w')

%% Evaluate differential equation
str = '[';
for v = 1:numNodes
    if v == numNodes
        eval(strcat('str = [str, ''activations(',num2str(v),')]''];'))
    else
        eval(strcat('str = [str, ''activations(',num2str(v),');''];'))
    end
end
eval(strcat('[t,x] = ode23(@(t,x) dfun(t,x,propensity1,propensity2,adjMatrix,numNodes),tspan,',str,');'))
 
figure('units','normalized','outerposition',[0 0 1 1]);
hold on
for v = 1:numNodes
    eval(['plot(t,x(:,',num2str(v),'),''LineWidth'',3);'])
end
title('Activations for Different Nodes (Calculated with ODE23)','FontSize',60,'FontName','Times New Roman')
xlabel('Time');
ylabel('Activation');
set(gca,'FontSize',40,'FontName','Times New Roman')
xlim(tspan([1,end]))
ylim([-0.2,1.2])
yticks(0:0.2:1)
set(gca,'TickLength',[0 0])
set(gcf,'color','w')

end
%% ODE function
function dxdt = dfun(t,x,propensity1,propensity2,adjMatrix,numNodes)
str4 = '';
vcount = 0;
for v = 1:numNodes
    vcount = vcount + 1;
    eval(strcat('str1 = ''x(',num2str(v),')*(1-x(',num2str(v),...
        '))*'';'))
    str2 = '(';
    wcount = 0;
    for w = 1:numNodes
        
        if v ~= w
            wcount = wcount + 1;
            p1 = num2str(propensity1(v,w));
            p2 = num2str(propensity2(v,w));
            a = num2str(adjMatrix(v,w));
            
            if wcount == numNodes - 1
                eval(strcat('str2 = [str2, ''',a,'*((',p1,'+',p2,')*x(',num2str(w),')-',p2,'))''];'))
            else
                eval(strcat('str2 = [str2, ''',a,'*((',p1,'+',p2,')*x(',num2str(w),')-',p2,')+''];'))
            end
        end
    end
    
    str3 = [str1,str2]; 
    if vcount == 1
        str4 = str3;
    elseif vcount == numNodes
        str4 = [str4,';',str3,';'];
        
    else
        str4 = [str4,';',str3];
    end
end
        
eval(strcat('dxdt = [',str4,'];'))
end