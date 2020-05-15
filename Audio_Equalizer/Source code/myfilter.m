function out = myfilter(b,a,in)

BufferIn  = zeros(length(b),1);
BufferOut = zeros(length(a),1);
out = zeros(length(in),1);

for i=1:length(in)
    BufferIn(1) = in(i);
    for j=1:length(b)
        out(i) = out(i)+b(j)*BufferIn(j);
    end
    for j=2:length(a)
        out(i) = out(i)-a(j)*BufferOut(j);
    end
    BufferOut(1) = out(i);
    for j=length(b):-1:2
        BufferIn(j) = BufferIn(j-1);
    end
    for j=length(a):-1:2
        BufferOut(j) = BufferOut(j-1);
    end
end




