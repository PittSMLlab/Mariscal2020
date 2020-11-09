function barGroupsDistraction(Study,results,groups,params,epochs,indivFlag,colorOrder,mode,ah,f)
%Make a bar plot to compare groups for a given epoch and parameter
%   TO DO: make function be able to accept a group array that is different
%   thand the groups in the results matrix

if isa(params,'char')
    params={params};
end


if nargin<8 || isempty(mode)
    mode=1;
end
if nargin<7 || isempty(colorOrder) || size(colorOrder,2)~=3    
    poster_colors;
    colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]];         
end
% Set grey colors to use when individual subjects are plotted 
greyOrder=[0 0 0 ;1 1 1;0.5 0.5 0.5;0.2 0.2 0.2;0.9 0.9 0.9;0.1 0.1 0.1;0.8 0.8 0.8;0.3 0.3 0.3;0.7 0.7 0.7];

ngroups=length(groups);         
numPlots=length(epochs)*length(params);
numE=length(epochs);
% ah=optimizedSubPlot(numPlots,length(params),numE,'lr',12,10,12);
i=1;
a=0;
for pa=1:length(params)
   limy=[];
   for t=1:numE
       axes(ah(i))
       hold on
       for b=1:ngroups
           nSubs=length(Study.(groups{b}).ID);
           
          if strcmp(params{pa},'spatialContributionNorm2')
              p=1;
          elseif strcmp(params{pa},'stepTimeContributionNorm2')
              p=2;
          elseif strcmp(params{pa},'velocityContributionNorm2') 
              p=3;
          elseif strcmp(params{pa},'netContributionNorm2') 
              p=4;
          elseif strcmp(params{pa},'XAsym') 
              p=5;
          elseif strcmp(params{pa},'alphaAsym')
              p=6;
          end
           
           %attempt to abbreviate group name
%            adaptData=Study.(groups{b}).adaptData{1};
%            group=adaptData.metaData.ID;
%            spaces=find(group==' ');
%            abrevGroup=group(spaces+1);%
%            abrevGroups{b}=[group(1) abrevGroup];
                      
           ind=find(strcmp(fields(Study),groups{b}));
           switch mode
               case 1
                   if nargin>5 && indivFlag
                       bar(b,results.(epochs{t}).avg(b,p),'facecolor',greyOrder(ind,:));
                      errorbar(b,results.(epochs{t}).avg(b,p),results.(epochs{t}).se(b,p),'.','LineWidth',2,'Color','k')
                       for s=1:nSubs
%                            if p==4 && length(params)==3
%                                pa=3;
%                            else
%                                pa=p;
%                            end
                           aux=results.(epochs{t}).indiv.(params{pa});
                           aux=aux(aux(:,1)==b,2);                   
                           plot(b+.2,aux(s),'o','MarkerFaceColor','k','MarkerSize',5,'MarkerEdgeColor','w')%,colorOrder(s,:))                 
                       end
                   else
                      
                       bar(b,results.(epochs{t}).avg(b,p),'facecolor',colorOrder(ind,:));%Normal Code
%                       %To plot on the right order for the paper  
%                        a=a+1;
%                        z(a,1)=results.(epochs{t}).avg(b+1,p);
%                        z(a,2)=results.(epochs{t}).avg(b,p);
% %                        
%                        bar(a,z(a,1),'facecolor',colorOrder(ind,:));
%                        bar(a+3,z(a,2),'facecolor',colorOrder(ind,:));
                       
                   end
               case 2
                   %nop
           end
       end
%        switch mode
%            case 1
% %                 errorbar(results.(epochs{t}).avg(:,p),results.(epochs{t}).se(:,p),'.','LineWidth',2,'Color','k')
%            case 2
%                errorbar(results.(epochs{t}).avg(:,p),results.(epochs{t}).se(:,p),'LineWidth',2,'Color','k')
%        end
       set(gca,'Xtick',1:ngroups,'XTickLabel',groups,'fontSize',12)
       axis tight
       limy=[limy get(gca,'Ylim')];
%        ylabel(params{1}(1:end-17))
%        title(epochs{t})
       i=i+1;
   end
   a=[];
%    set(ah(p*numE-(numE-1):p*numE),'Ylim',[min(limy) max(limy)])
   set(gcf,'Renderer','painters');
end

end

