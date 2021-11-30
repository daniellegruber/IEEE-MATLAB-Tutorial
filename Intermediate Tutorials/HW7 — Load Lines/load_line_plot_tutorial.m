function load_line_plot_tutorial(V_D, I_D, I_R, plt_name, save_dir)
%LOAD_LINE_PLOT_TUTORIAL Creates a load line plot given diode voltages to plot and
%corresponding values for the current accross the diode and resistor.
%   Inputs
%   ----------
%   V_D: array of diode voltages to plot
%
%   I_D: array of corresponding values for current across diode
%
%   I_R: array of corresponding values for current across resistor
%
%   plt_name: title to display on figure
%
%   save_dir: directory to save figure
    
    %% YOUR CODE HERE: Create figure
    load_plt = figure('units','normalized','outerposition',[0 0 0.6 0.9]);
    
    % Use the command that ensures any new plots are added to the same axes

    % YOUR CODE HERE
    % ...
    
    %% YOUR CODE HERE: Plot I_R and I_D
    
    % First plot I_R vs V_D, then plot I_D vs V_D
    
    % YOUR CODE HERE
    % plot( ... );
    % plot( V_D, I_D );
    
    %% YOUR CODE HERE: Set title, x label, y label
    % Set title to be ['Load Line Plot, ', plt_name] with font size 50
    % (note this uses concatenation)
    % Set x label to be $V_D$ (latex format)
    % Set y label to be Voltage $i$ (latex format)
    
    % YOUR CODE HERE
    % title( ... )
    % xlabel( ... );
    % ylabel( ... );

    set(gca,'FontSize',20)
    set(gcf,'color','w')

    %% YOUR CODE HERE: Find idx of intersection
    % Get the idx of intersection idx_intersection by finding the idx
    % where the absolute difference between I_D and I_R is at a minimum
    
    % YOUR CODE HERE
    % [~,idx_intersect] = min( ... );
    
    x_intersect = V_D(idx_intersect);
    y_intersect = I_D(idx_intersect);
    
    %% YOUR CODE HERE: Plot point of intersection 
    
    % Plot y_intersect vs x_intersect using:
    % a linestyle of 'o' (a marker without a line),
    % a marker size of 10 (use 'MarkerSize'), 
    % and a blue edge color (use 'MarkerEdgeColor')
    
    % YOUR CODE HERE
    % plot( ... )
    
    text(x_intersect + V_D(end)/10, y_intersect + 0.0001,...
        ['(',num2str(round(x_intersect,2)), ', ', num2str(round(y_intersect,4)),')'],...
        'VerticalAlignment','bottom','HorizontalAlignment','center',...
        'interpreter','latex','FontSize',20)
    
    xlim([0, V_D(end)*1.05])
    xticks(linspace(0,V_D(end)/1.05,5))
    ylim([0,0.01])
    yticks(linspace(0,0.01,6));
    
    legend({'$i = \frac{V_0 - V_D}{R}$', '$i = 10^{-14} (e^{\frac{V_D}{0.026}} - 1)$'})

    % Export figure
    % export_fig([save_dir, filesep, 'Load Line Plot, ', plt_name], '-png',load_plt)
end