function Fx = dfdx( F, x )
if nargin<1
   disp('usage:  gradient = central_diff( F, x )')
   return
elseif nargin<2
   m = 1;
   x = 1;
else
   m = length(x);
end

Tflag = 0;
if ismatrix(F) && size(F,1)==1 % Treat row vector as a column vector
   F = F.';
   Tflag = 1;
end;
[n,p] = size(F);
if m==0
   error('x cannot be null')
elseif m~=1 && m~=n
   error('First dimension of F and x must be the same.')
elseif m>1 && ~( all(diff(x)>0) || all(diff(x)<0) )
   error('Vector x must be monotonically increasing or decreasing.')
elseif n<=1
   Fx = F / x;
   return
end

Fx = zeros(size(F));
x  = x(:);

%% Forward difference at left end, and Backward difference at right end
if m>1
   H = x(2) - x(1);
else
   H = x;
end
if n==2 % First-order difference for a single interval with end values
   Fx(1,:) = ( F(2,:) - F(1,:) ) / H;
   Fx(2,:) = Fx(1,:);
else    % Second-order differences
   % Left end forward difference
   if m==1 || abs(diff(x(2:3))-H)<=eps % evenly spaced
      Fx(1,:) = ( [-3, 4, -1]/(2*H)*F(1:3,:) ).';
   else                              % unevenly spaced
      h   = diff(x(1:3));
      hph = sum(h); % h_1 + h+2
      Fx(1,:) = hph/h(1)/h(2)*F(2,:) ...
        - ((2*h(1)+h(2))/h(1)*F(1,:) ...
        +           h(1)/h(2)*F(3,:))/hph;
   end
   % Right end backward difference
   if m==1 || abs(diff(diff(x(m-2:m))))<eps % evenly spaced
      Fx(end,:) = ( [1, -4, 3]/(2*H)*F(m-2:m,:) ).';
   else                                    % unevenly spaced
      h   = diff(x(m-2:m));
      hph = sum(h);
      Fx(end,:) = ( h(2)/h(1)*F(end-2,:) ...
         + (h(1)+2*h(2))/h(2)*F(end,:) )/hph ...
              - hph/h(1)/h(2)*F(end-1,:);
   end
end

%% Central Difference in interior (second-order)
if n > 2
   if m==1 || all(abs(diff(x)-H)<=eps)
      % Evenly spaced formula used in MATLAB's gradient routine
      Fx(2:n-1) = ( F(3:n,:) - F(1:n-2,:) ) / (2*H);
   else
      % Unevenly spaced central difference formula
      h = diff(x); h_i=h(1:m-2,ones(p,1)); h_ip1=h(2:m-1,ones(p,1));
      Fx(2:n-1,:) =  (-(h_ip1./h_i).*F(1:n-2,:) + ...
                       (h_i./h_ip1).*F(3:n,:)   )./ (h_i + h_ip1) + ...
                       ( 1./h_i - 1./h_ip1 ).*F(2:n-1,:);
   end
end
if Tflag, Fx=Fx.'; end
end
