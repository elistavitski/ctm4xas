function remove_list(tag_list)
    old_list=getsTag(tag_list);
    old_value=getvalTag(tag_list);
    ln_list=length(old_list);
    if ~iscell(old_list),
        setsTag(tag_list,'')
    else
        if ~isempty(old_list)
            if ln_list==1,
                new_list='';
                
            else
                if old_value==ln_list,
                    for jj=1:(ln_list-1),
                        new_list{jj}=old_list{jj};
                    end
                    new_val=length(new_list);
                elseif old_value==1
                    for jj=2:(ln_list),
                        new_list{jj-1}=old_list{jj};
                    end
                    new_val=1;
                else
                    for jj=1:(old_value-1),
                        new_list{jj}=old_list{jj};
                    end
                    for jj=(old_value+1):(ln_list),
                        new_list{jj-1}=old_list{jj};
                    end
                    new_val=old_value-1;
                end
                setvalTag(tag_list,new_val)
            end
             if isempty(new_list)
                  setsTag(tag_list,'')
             else
                 setsTag(tag_list,new_list')
             end
        end
    end