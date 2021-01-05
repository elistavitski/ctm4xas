function add_list_sort(tag_list, data_in)
    old_list=getvTagM1(tag_list);

   if isempty(old_list)
        old_list{1}=data_in;
        setvalTag(tag_list,1);
        new_entry_indx=1;
    else
        ln_list=length(old_list);
        old_list(ln_list+1)=data_in;
        new_entry_indx=ln_list+1;
    end

    setsTag(tag_list,old_list);
    setvalTag(tag_list,new_entry_indx);
   