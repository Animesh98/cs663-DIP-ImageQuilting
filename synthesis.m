clc; close all; clear all;
[i,m]=imread("rice.gif");
tex=double(ind2rgb(i,m));
[th,tw,~] = size(tex);
p=60 ;%patch size 
o=p/6 ;%overlap 
 h=7*(p-o)+o; w=12*(p-o)+o;% hieght and width of output image
%   h=720; w=1020;% hieght and width of output image
out= zeros(h,w,3);%output image
n=(h-o)/(p-o);%no. of horizontal patches
m=(w-o)/(p-o);%no. of vertical patches
f = waitbar(0,"Quilting");stepnum = 0;
for i = 1:n
	for j = 1:m
        
        if i==1 && j==1
            rh=randi(th-p);rw=randi(tw-p);
			out(1:p,1:p,:) =tex(rh:rh+p-1,rw:rw+p-1,:);
            
        elseif i==1
            s=((j-1)*(p-o));
            mask=zeros(p);mask(:,1:o)=1;
            cur=out(1:p,s:s+p-1,:);
            next=nextPatch(tex,mask,cur,p,9);
            fp = minErrorBoundaryCut(cur,next,o,'vertical',p);
            out(1:p,s:s+p-1,:) =fp; 
            
        elseif j==1
            s=((i-1)*(p-o));
            mask=zeros(p);mask(1:o,:)=1;
            cur=out(s:s+p-1,1:p,:);
            next=nextPatch1(tex,mask,cur,p);
             fp = minErrorBoundaryCut(cur,next,o,'horizontal',p);
            out(s:s+p-1,1:p,:)=fp;

        else
            s1=((i-1)*(p-o));s2=((j-1)*(p-o));
            mask=zeros(p);mask(:,1:o)=1;mask(1:o,:)=1;
            cur=out(s1:s1+p-1,s2:s2+p-1,:);
            next=nextPatch1(tex,mask,cur,p);
             fp = minErrorBoundaryCut(cur,next,o,'both',p);
            out(s1:s1+p-1,s2:s2+p-1,:)=fp;
        end
        stepnum = stepnum + 1;	
		waitbar(stepnum/((n)*(m)),f,"Quilting");
	end
end