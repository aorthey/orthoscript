ae = [0.7;1.0]
amax = 0.5
delta = @(x,y) ((x*ae(1)+y*ae(2))**2)-((x*x+y*y))*(ae'*ae - amax*amax)
omega = @(x,y) (-(x*x+y*y)*(ae'*ae - amax*amax))

dk = -ae'*ae+amax*amax
A = [ae*ae';dk dk]
L=10;
N=100;
X=linspace(-L,L,N);
Y=linspace(-L,L,N);
B = zeros(N,N);
for i=1:N
        for j=1:N
                d=delta(X(i),Y(j));
                %Om = omega(X(i),Y(j))
                if d>=0
                       %solutions:
                       b = -(X(i)*ae(1)+Y(j)*ae(2));
                       a = (1/4)*ae'*ae + (1/4)*amax*amax;
                       s1 = ((-b+sqrt(d))/(2*a));
                       s2 = ((-b-sqrt(d))/(2*a));

                       B(i,j)=1.0;
                       if s1>0
                               B(i,j)=1.0;
                       end
                end     
                %for t = 0:0.2:2
                %        p = [X(i);Y(j)]-0.5*ae*t*t;
                %        dd = sqrt((p'*p));
                %        if dd <= (0.5*amax*t*t);
                %                B(i,j)=0.5;
                %                break
                %        end
                %end
        end
end
%surf (X, Y, B);

%%% ATTENTION: imagesc is inverted by default
imagesc(X,Y,B);
hold on;
plot(0,0,'w','markersize',N/10)
hold on;
plot([0,ae(2)],[0,ae(1)],'w');
xlabel('y');
ylabel('x');
set(gca,'YDir','normal')
pause
