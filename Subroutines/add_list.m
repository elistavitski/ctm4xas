function add_list(tag_list, data_in)
    old_list=getsTag(tag_list);
    if isempty(old_list)
        old_list_cell{1}=data_in;
        setvalTag(tag_list,1);
        new_entry_indx=1;
    else
        if iscell(old_list)
            old_list_cell=old_list;
        else
            old_list_cell{1}=old_list;
        end
        ln_list=length(old_list_cell);
        old_list_cell{ln_list+1}=data_in;
        new_entry_indx=ln_list+1;
    end

    setsTag(tag_list,old_list_cell);
    setvalTag(tag_list,new_entry_indx);
   