function change_list(tag_list, inc_value)
    old_list=getsTag(tag_list);
    if ~isempty(old_list)
        if iscell(old_list),         
            old_index=getvalTag(tag_list);
            old_list{old_index}=num2str(str2num(old_list{old_index})+inc_value);
        else
            old_list=num2str(str2num(old_list)+inc_value);
        end
        setsTag(tag_list,old_list)
    end