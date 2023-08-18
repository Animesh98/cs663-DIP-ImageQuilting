function patch = nextPatch(tex,mask,cur,p,e)
    [th,tw,~] = size(tex);
    b=true;
    m = repmat(mask, 1, 1, 3);
    while b
        rh=randi(th-p);rw=randi(tw-p);
		patch =tex(rh:rh+p-1,rw:rw+p-1,:);
        temp = patch.*m;
        temp=temp-cur;
        temp=temp.*temp;
        error = sqrt(sum(sum(sum(temp))))
        if error < e
            b=false;
        end
    end
end
