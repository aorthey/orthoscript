%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generate all possible particle paths disturbed by 
%% initial velocity v0 and constant homogeneous force
%% field F_e, with implied acceleration F_e = m*a_e
%% -- assuming unit mass particle
%% particle is allowed to move omnidirectional with
%% acceleration amax in each direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

amax = 1.6;
v0=0*[0.2;-1.2;0.0];
ae = 1*[2.2;1.2;0.0];
aenorm = ae/norm(ae);

qzp = rot2q([0;0;1],+pi/2)
qzm = rot2q([0;0;1],-pi/2)

dk = -ae'*ae+amax*amax
L=10;
N=100;
X=linspace(-L,L,N);
Y=linspace(-L,L,N);
B = zeros(N,N);
B(1,1)=1.0;
T = norm(v0)/amax
%for i=1:N
%        for j=1:N
%                for t = 0:0.1:T
%                        p = [X(i);Y(j);0.0]-0.5*ae*t*t-v0*t;
%                        dd = sqrt((p'*p));
%                        if dd <= (0.5*amax*t*t);
%                                B(i,j)=1.0;
%                                break
%                        end
%                end
%        end
%end

imagesc(X,Y,B);
hold on;
plot(0,0,'w','markersize',N/10)
hold on;
plot([0,ae(2)],[0,ae(1)],'w');
hold on;
plot([0,v0(2)],[0,v0(1)],'g');
hold on;

t = 0:0.02:5;
xlabel('y');
ylabel('x');
set(gca,'YDir','normal')

for angle=0:pi/100:2*pi
        qz = rot2q([0;0;1],angle);
        aq = quaternion(aenorm(1),aenorm(2),aenorm(3));
        [aoff,tmpangle] = q2rot(qz*aq*conj(qz));
        xx = 0.5*ae*(t.^2)+v0*t+0.5*amax*aoff'*(t.^2);
        plot(xx(2,:),xx(1,:),'w','linewidth',1,'linestyle','-');
        hold on;
        %pause(0.2);
end
k=0;
pause
