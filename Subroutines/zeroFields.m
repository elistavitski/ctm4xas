function zeroFields(inTags)
for jj=1:length(inTags),
    setvTag(inTags{jj},0);
end