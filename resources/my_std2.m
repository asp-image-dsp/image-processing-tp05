function mystd=my_std2( m2d)

s=size(m2d);
N=s(1)*s(2);
mystd= sqrt(1/N*sum(sum(m2d.*m2d))-mean2(m2d)^2);