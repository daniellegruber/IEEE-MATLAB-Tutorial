function load_line_plot(V_D, I_D, I_R, plt_name, save_dir)
%LOAD_LINE_PLOT Creates a load line plot given diode voltages to plot and
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
    
    load_plt = figure('units','normalized','outerposition',[0 0 0.6 0.9]);
    hold on
    
    plot(V_D, I_R);
    plot(V_D, I_D);
    
    title(['Load Line Plot, ', plt_name],'FontSize',50)
    xlabel('$V_D$');
    ylabel('$i$');

    set(gca,'FontSize',20)
    set(gcf,'color','w')

    [~,idx_intersect] = min(abs(I_D - I_R));
    x_intersect = V_D(idx_intersect);
    y_intersect = I_D(idx_intersect);
    
    
    plot(x_intersect, y_intersect,'o','MarkerSize',10,'MarkerEdgeColor','b')
    text(x_intersect + V_D(end)/10, y_intersect + 0.0001,...
        ['(',num2str(round(x_intersect,2)), ', ', num2str(round(y_intersect,4)),')'],...
        'VerticalAlignment','bottom','HorizontalAlignment','center',...
        'interpreter','latex','FontSize',20)
    
    xlim([0, V_D(end)*1.05])
    xticks(linspace(0,V_D(end)/1.05,5))
    ylim([0,0.01])
    yticks(linspace(0,0.01,6));
    
    legend({'$i = \frac{V_0 - V_D}{R}$', '$i = 10^{-14} (e^{\frac{V_D}{0.026}} - 1)$'})

    export_fig([save_dir, filesep, 'Load Line Plot, ', plt_name], '-png',load_plt)
end