
clear z1;a=findobj('Tag','exp'); z1(:,1)=get(a,'XData');z1(:,2)=get(a,'YData'); 
name=get(a,'DisplayName');
save([name '_xmcd_exp.dat'],'z1','-ascii')

clear z1;a=findobj('Tag','fit'); z1(:,1)=get(a,'XData');z1(:,2)=get(a,'YData'); 
save([name '_xmcd_fit.dat'],'z1','-ascii')

%clear z1;a=findobj('Tag','fe2'); z1(:,1)=get(a,'XData');z1(:,2)=get(a,'YData'); save('Fe2_xmcd_simulation.dat','z1','-ascii')
%clear z1;a=findobj('Tag','fe3'); z1(:,1)=get(a,'XData');z1(:,2)=get(a,'YData'); save('Fe3_xmcd_simulation.dat','z1','-ascii')