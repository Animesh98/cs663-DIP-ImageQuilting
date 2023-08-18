function opatch = nextPatch1(tex,mask,cur,p)
    [th,tw,~] = size(tex);
    b=true;
    e=100;
    m = repmat(mask, 1, 1, 3);
    for i = 1:th-p
        for j = 1:tw-p
		patch =tex(i:i+p-1,j:j+p-1,:);
        temp = patch.*m;
        temp=temp-cur;
        temp=temp.*temp;
        error = sqrt(sum(sum(sum(temp))));
        if error <= e
            opatch=patch;
            e=error;
        end
    end
end
