function [pars_out,line1,line2]=update_line_slater_out(fid1,handles,bindE,fin_state,swap_SO)
   line_in1 = fgets(fid1);
    num_param=str2num(line_in1(19:20));
    SO1=-1;SO2=-1; numSO=0; SOcounter=0;
    %looking for which is the largest SO value
    for jj=4:7;
        indx=jj*10;
        reduced_val=str2num(line_in1((indx-9):(indx-1)));
        switch str2num(line_in1(indx))
            case 2
               numSO=numSO+1; 
               str2num(line_in1(indx));
               if SO1==-1,
                   SO1=reduced_val; 
               else
                   SO2=reduced_val; 
               end
        end
    end
    if num_param >5
    line_in2 = fgets(fid1);
        for jj=1:(num_param-5);
            indx=jj*10;
            reduced_val=str2num(line_in2((indx-9):(indx-1)));
            str2num(line_in2(indx))
            switch str2num(line_in2(indx))
                case 2
                    numSO=numSO+1;
                    str2num(line_in2(indx));
                    if SO1==-1,
                        SO1=reduced_val;
                    else
                        SO2=reduced_val;
                    end
            end
        end
    end
    % Addition in the version 5.1 
    % Check which SO coupling is greater 
    if SO2==-1
        if SO1~=-1
            SO1=SO1*handles.so_reduc_3d; % only one value - valence!
        end
    else
        if SO1>SO2,
            SO1=SO1*handles.so_reduc_2p; %first SO value is a core
            SO2=SO2*handles.so_reduc_3d;
        else
            SO2=SO2*handles.so_reduc_2p; %second SO value is a core
            SO1=SO1*handles.so_reduc_3d;
        end
    end
    if swap_SO&&numSO>1 
        tempSO=SO1; SO1=SO2; SO2=tempSO;
    end
    % end check
    for jj=4:7;
        indx=jj*10;
        reduced_val=str2num(line_in1((indx-9):(indx-1)));

        switch str2num(line_in1(indx)),
            case 0
                reduced_string='0';
            case 1
                line_in1((indx-9):(indx-1))='         ';
                reduced_val=reduced_val*handles.slater_Fdd; 
                reduced_string=num2str(reduced_val,'%5.3f\n');
                l_red_str=length(reduced_string);
                line_in1((indx-l_red_str):(indx-1))=reduced_string;
            case 2
                line_in1((indx-9):(indx-1))='         ';
                SOcounter=SOcounter+1;
                if SOcounter==1,
                    reduced_val=SO1;
                else
                    reduced_val=SO2;
                end
                reduced_string=num2str(reduced_val,'%5.3f\n');
                l_red_str=length(reduced_string);
                line_in1((indx-l_red_str):(indx-1))=reduced_string; 
            case 3
                line_in1((indx-9):(indx-1))='         ';
                reduced_val=reduced_val*handles.slater_Fpd;
                reduced_string=num2str(reduced_val,'%5.3f\n');
                l_red_str=length(reduced_string);
                line_in1((indx-l_red_str):(indx-1))=reduced_string; 
            case 4
                line_in1((indx-9):(indx-1))='         ';
                reduced_val=reduced_val*handles.slater_Gpd;
                reduced_string=num2str(reduced_val,'%5.3f\n');
                l_red_str=length(reduced_string);
                line_in1((indx-l_red_str):(indx-1))=reduced_string; 
        end
        pars_out(jj-3,1)=str2num(line_in1(indx));
        pars_out(jj-3,2)=str2num(reduced_string);
    end
    %correct binding energy
    if bindE>-1
        bindEs=num2str(bindE,'%10.3f');
        lBE=length(bindEs);
        line_in1(21:29)='         ';
        line_in1((29-lBE+1):29)=bindEs;
    end
    
    if handles.XES 
        if fin_state
            temp_l=line_in1(51:60); line_in1(51:60)=line_in1(61:70); line_in1(61:70)=temp_l;
        else
            line_in1(61:70)='     0.000';
        end
    end
    line1=line_in1;
    if num_param >5
        for jj=1:(num_param-5);
            indx=jj*10;
            reduced_val=str2num(line_in2((indx-9):(indx-1)));
            str2num(line_in2(indx))
            switch str2num(line_in2(indx))
                case 1
                    line_in2((indx-9):(indx-1))='         ';
                    reduced_val=reduced_val*handles.slater_Fdd;
                    reduced_string=num2str(reduced_val,'%5.3f\n');
                    l_red_str=length(reduced_string);
                    line_in2((indx-l_red_str):(indx-1))=reduced_string;
                case 2
                    line_in2((indx-9):(indx-1))='         ';
                    SOcounter=SOcounter+1;
                    if SOcounter==1,
                        reduced_val=SO1;
                    else
                        reduced_val=SO2;
                    end
                    reduced_string=num2str(reduced_val,'%5.3f\n');
                    l_red_str=length(reduced_string);
                    line_in2((indx-l_red_str):(indx-1))=reduced_string;
                case 3
                    line_in2((indx-9):(indx-1))='         ';
                    reduced_val=reduced_val*handles.slater_Fpd;
                    reduced_string=num2str(reduced_val,'%5.3f\n');
                    l_red_str=length(reduced_string);
                    line_in2((indx-l_red_str):(indx-1))=reduced_string;
                case 4
                    line_in2((indx-9):(indx-1))='         ';
                    reduced_val=reduced_val*handles.slater_Gpd;
                    reduced_string=num2str(reduced_val,'%5.3f\n');
                    l_red_str=length(reduced_string);
                    line_in2((indx-l_red_str):(indx-1))=reduced_string;
            end
            pars_out(jj+4,1)=str2num(line_in2(indx));
            pars_out(jj+4,2)=str2num(reduced_string);
        end
        line2=line_in2;
    else
        line2='';
    end