function [t,seat,aisle]=OI6Sim(n,target,seated)

% OI6 分组仿真的部分
%    n  分组人数
%    target 入对的顺序
%    seated 当前座位落座情况

%   t simulation time
%   seat ,seat interference 
%   aisle ,aisle interference 
 

% Initial data
% setting passengers' Value:   
%                   walking          .....   1
%                   waiting          .....   2
%                   putting luggage  .....   3
%                   passing the seat .....   4
%                   sitting           .....  0
 

% on initial time, everyone is waiting,except the first one 

seat=0;
aisle=0;

status=2*ones(1,n);     
status(1)=1;

%初始时刻每个人的位置
%每个人的间距为0.6 row
pos=-(0:0.6:(n-1)*0.6);



   pri=[-1,1:n-1];
   next=[2:n,-1];


RowSpeed=trirnd(0.6,0.95,1.3,1,n);

pab=rand(1,n);
for i=1:n
    if pab(i)<0.4
       aisleTime(i)=0;
    else
        aisleTime(i)=trirnd(3.2,7.1,38.7);
    end
end

% seat interference time
seatTime=trirnd(7.4,9.7,15.5);

t=0;
while sum(status) ~=0
    
    t=t + 0.1;
    for i=1:n
        
        switch status(i)
            case {0}       
                
                 if  next(i)>0 &&abs(status(next(i))-2)<0.1       
                        status(next(i))=1;
                     end
                  
%                  disp('have sit down');

            case {1}        
                 
%                  disp('Walking');
                 
                     if  next(i)>0 &&abs(status(next(i))-2)<0.1       
                        status(next(i))=1;
                     end
                  
                     
                     pos(i)=pos(i)+RowSpeed(i)*0.1;
                 
                     if abs(pos(i)-target(1,i))<0.2  
        
                         status(i)=3;
                         if abs(aisleTime(i))<0.01  
                             aisle=aisle+1;
                         end
                         
                             if  next(i)>0 &&abs(status(next(i))-1)<0.1    
                                                                     
                                 status(next(i))=2;
                         end             
                
                      end

                 
            case {2}         
                  
%                   disp('Blocking');
                  if  next(i)>0 &&abs(status(next(i))-1)<0.1    
                                                                    
                          status(next(i))=2;
                     end 

            case {3}          %put luggage     aisle interference
                
                   disp('aisle interference');
                 
                  if abs(aisleTime(i))<0.01             
                      
                    if  n==12 && target(2,i)==1 && seated(target(1,i),2)==1
                          status(i) = 4;
                          seat=seat+1;
                      elseif  n==12 && target(2,i)==4 && seated(target(1,i),3)==1
                          status(i) = 4;
                          seat=seat+1;
                      else
                          
                           status(i)=0;
                           seated(target(1,i),target(2,i)) = 1;
                      end

                  else
                      aisleTime(i)=aisleTime(i)-0.1;
                      
                  end
                  
            case {4}             % seat interference  
                
                if abs(aisleTime(i))<0.01   % 
                    status(i)=0;
                    seated(target(1,i),target(2,i)) = 1;    
                else
                    
                    seatTime(i)=seatTime(i)-0.1;
                end
                    
                    
            
        end  %switch
    end %for

end %while
   
   
   
   