clear;clc;
for i=5:8
    load_command = sprintf('load Compensated_data_no_k/L%d_no_k',i);
    eval(load_command);
    load_command = sprintf('load Compensated_data_k/L%d_k',i);
    eval(load_command);
    plt_command = sprintf('subplot(41%d)',i-4);
    eval(plt_command);
    plot(OptMagDataBeforeCom,'--');
    hold on;
    plot(OptMagDataAfterCom_no_k);
    hold on;
    plot(OptMagDataAfterCom_k)
    hold off;
    xlabel('Sample');
    ylabel('Mag(nT)');
    legend('OptMagDataBeforeCom','OptMagDataAfterCom no k','OptMagDataAfterCom k');
end