function opatch = nextPatch1(tex,mask,cur,p)
    [th,tw,~] = size(tex);
    o=p/6 ;
    mask1=zeros(p);mask1(:,1:o)=1;
    mask2=zeros(p);mask2(1:o,:)=1;
    b=true;
    e1=100;e2=100;
    m1 = repmat(mask1, 1, 1, 3);m2 = repmat(mask2, 1, 1, 3);
    for i = 1:th-p
        for j = 1:tw-p
		patch =tex(i:i+p-1,j:j+p-1,:);
        temp1 = patch.*m1;
        temp1=temp1-cur;
        temp1=temp1.*temp1;
        error1 = sqrt(sum(sum(sum(temp1))));
        temp2 = patch.*m2;
        temp2=temp2-cur;
        temp2=temp2.*temp2;
        error2 = sqrt(sum(sum(sum(temp2))));
        if (error1<=e1 && error2<=e2)
            opatch=patch;
            e1=error1;e2=error2;
        end
    end
end
