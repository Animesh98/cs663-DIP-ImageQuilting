function fp = minErrorBoundaryCut(cur,next,o,overlap_type,p)
	fp = zeros(size(next));

	if strcmp(overlap_type,'vertical')
		fp(:,o+1:p,:) = next(:,o+1:p,:);	
		left_overlap = cur(:,1:o,:);
		selected_overlap = next(:,1:o,:);
		diff_patch = left_overlap-selected_overlap;
		e = sum(abs(diff_patch),3);
		E = zeros(size(e));
		E(1,:) = e(1,:);
		for i = 2:p
			for j = 1:o
				if j==1
					E(i,j) = e(i,j) + min([E(i-1,j), E(i-1,j+1)]);
				elseif j==o
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i-1,j)]);
				else
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i-1,j), E(i-1,j+1)]);
				end
			end
		end

		[min_E, prev_ind] = min(E(p,:));
		fp(p,1:prev_ind-1,:) = cur(p,1:prev_ind-1,:);
		fp(p,prev_ind:o,:) = next(p,prev_ind:o,:);	
		for i = p-1:-1:1
			[min_val, prev_ind] = min(abs(E(i,:) - (min_E-e(i+1,prev_ind))));
			min_E = E(i,prev_ind);
			fp(i,1:prev_ind-1,:) = cur(i,1:prev_ind-1,:);
			fp(i,prev_ind:o,:) = next(i,prev_ind:o,:);	
		end

	elseif strcmp(overlap_type,'horizontal')
		fp(o+1:p,:,:) = next(o+1:p,:,:);	
		top_overlap = cur(1:o,:,:);
		selected_overlap = next(1:o,:,:);
		diff_patch = top_overlap-selected_overlap;
		e = sum(diff_patch.*diff_patch,3);
		E = zeros(size(e));
		E(:,1) = e(:,1);
		for j = 2:p
			for i = 1:o
				if i==1
					E(i,j) = e(i,j) + min([E(i,j-1), E(i+1,j-1)]);
				elseif i==o
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i,j-1)]);
				else
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i,j-1), E(i+1,j-1)]);
				end
			end
		end

		[min_E, prev_ind] = min(E(:,p));

		fp(1:prev_ind-1,p,:) = cur(1:prev_ind-1,p,:);
		fp(prev_ind:o,p,:) = next(prev_ind:o,p,:);
		for i = p-1:-1:1
			[min_val, prev_ind] = min(abs(E(:,i) - (min_E-e(prev_ind,i+1))));
			min_E = E(prev_ind,i);
			fp(1:prev_ind-1,i,:) = cur(1:prev_ind-1,i,:);
			fp(prev_ind:o,i,:) = next(prev_ind:o,i,:);
		end
	else
		horizontal_cut_patch = minErrorBoundaryCut(cur,next,o,'horizontal',p);
		fp = minErrorBoundaryCut(cur,horizontal_cut_patch,o,'vertical',p);
	end
end