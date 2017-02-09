ae = [0.7;1.0;0.0];
amax = 0.5;
v0=[0.5;-1.2;0.0];

dk = -ae'*ae+amax*amax
L=r;
N=40;
X=linspace(-L,L,N);
Y=linspace(-L,L,N);
Z=linspace(-L,L,N);
B = zeros(N,N,N);
for i=1:N
        for j=1:N
                for k=1:N
                        for t = 0:0.5:2
                                p = [X(i);Y(j);Z(k)]-0.5*ae*t*t-v0*t;
                                dd = sqrt((p'*p));
                                if dd <= (0.5*amax*t*t);
                                        B(i,j,k)=1.0;
                                        break
                                end
                        end
                end
        end
end
B
for i=1:N
        for j=1:N
                for k=1:N
                        if B(i,j,k)>0.1
                                plot(X(i),Y(j),Z(k),'*r');
                                hold on;
                        end
                end
        end
        i
end

hold on;
plot(0,0,'w','markersize',N/10)
hold on;
%plot([0,ae(2)],[0,ae(1)],'w');
%hold on;
%plot([0,v0(2)],[0,v0(1)],'g');
%xlabel('y');
%ylabel('x');
%set(gca,'YDir','normal')
pause
