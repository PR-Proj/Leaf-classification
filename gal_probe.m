corr=zeros(10,1);
corr_c=zeros(10,1);
for i = 1:1100
%     minimum= dist(p_hog(i,2:81),g_hog(1,2:81)');
    distances=zeros(500,2);
    distances_c=zeros(500,2);
%     ndx=1;
    for j= 1:500
        t= dist(p_hog(i,2:82),g_hog(j,2:82)');
        t1=pdist2(p_hog(i,2:82),g_hog(j,2:82),'chisq');
        distances(j,:)= [t g_hog(j,1)]';
        distances_c(j,:)= [t1 g_hog(j,1)]';
%          if t <minimum
%              minimum=t;
%              ndx=j;
%          end
    end
%      if ndx==p_hog(i,1)
%          corr(1)=corr(1)+1;
%      end
    s_distances=sortrows(distances,1);
    s_distances_c=sortrows(distances_c,1);
    flg=0;
    for j=1:10
        if(flg==1)
            corr(j)=corr(j)+1;
        else
            if s_distances(j,2)==p_hog(i,1)
                flg=1;
                corr(j)=corr(j)+1;
            end
        end 
    end
    flg=0;
    for j=1:10
        if(flg==1)
            corr_c(j)=corr_c(j)+1;
        else
            if s_distances_c(j,2)==p_hog(i,1)
                flg=1;
                corr_c(j)=corr_c(j)+1;
            end
        end 
    end
end
corr=corr/11;
corr_c=corr_c/11;