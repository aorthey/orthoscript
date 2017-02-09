%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% look only at paths in zero force field, but with
%% non-zero initial velocity v0
%%
%% there are two phases: (1) velocity-dominated phase, 
%% where the path is disturbed by the initial velocity.
%% (2) acceleration dominated phase, where the initial
%% velocity has been compensated by acceleration,
%% and where the complete space is reachable
%%
%% we concentrate here only on (1), and try to find its
%% boundary, so that we have points which are phase-(1)
%% reachable, and points which are phase-(2) reachable
%%
%% phase-(1) reachability should be similar to force 
%% influence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qzp = rot2q([0;0;1],+pi/2);
qzm = rot2q([0;0;1],-pi/2);

amax = 0.5;
L=10;
N=100;
X=linspace(-L,L,N);
Y=linspace(-L,L,N);
B = zeros(N,N);
B(1,1)=1.0;
imagesc(X,Y,B);
hold on;
for aevv = 0.1:0.4:0.9
        aevv
        ae = aevv*[2.2;1.2;0.0];
        aenorm = ae/norm(ae);

        vv=1.0
        %for vv =0.5:4
                v0=vv*[0.2;-1.2;0.0];
                v0norm = v0/norm(v0);

                dk = -ae'*ae+amax*amax;
                T = norm(v0)/amax
                plot(0,0,'w','markersize',N/10)
                hold on;
                plot([0,ae(2)],[0,ae(1)],'w');
                hold on;
                plot([0,v0(2)],[0,v0(1)],'g');
                hold on;

                for angle=0.0:pi/1000:2*pi
                        ai = amax*ones(size(v0));
                        qz = rot2q([0;0;1],angle);
                        aq = quaternion(v0norm(1),v0norm(2),v0norm(3));
                        [aoff,tmpangle] = q2rot(qz*aq*conj(qz));
                        %if aoff*v0 < 0
                        if aoff*v0 < 0
                                T = norm(v0)/norm(aoff*v0);
                                if T < 10
                                        %t = 0:0.1:T;
                                        %xx = v0*t+0.5*amax*aoff'*(t.^2);
                                        %plot(xx(2,:),xx(1,:),'w','linewidth',1);
                                        t = T;%0:0.1:T;
                                        xx = 0.5*ae*t.^2+v0*t+0.5*amax*aoff'*(t.^2);
                                        plot(xx(2,:),xx(1,:),'w','linewidth',1);
                                        hold on;
                                        %pause(0.05);
                                end
                        end
                end
        %end
end
xlabel('y');
ylabel('x');
set(gca,'YDir','normal')
pause
