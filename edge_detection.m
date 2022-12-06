function n = edge_detection(a)
ss = size(a) ; 
 
type = size(ss) ;
type = type(1,2) ;
fvar = 10 ;
if(type == 2)
	b = medfilt2(a);
	ss = size(b) ; 
	r = ss(1,1) ; c = ss(1,2) ;
	n = zeros(r,c) ; 
	 
	for i=2:1:r-1
		
		for j=2:1:c-1
		   
			mem = 0 ;
			mem = mem + abs(b(i,j)-b(i,j-1)) ;
			mem = mem + abs(b(i,j)-b(i-1,j-1)) ;
			mem = mem + abs(b(i,j)-b(i-1,j)) ;
			mem = mem + abs(b(i,j)-b(i,j+1)) ;
			mem = mem + abs(b(i,j)-b(i+1,j+1)) ;
			mem = mem + abs(b(i,j)-b(i+1,j)) ;
			
			if(mem > fvar)
				n(i,j) = b(i,j)  ;
            end
        end
    end		
end
end
