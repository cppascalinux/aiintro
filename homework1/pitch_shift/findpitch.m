function PT = findpitch(s)
[B, A] = butter(5, 800*2/8000);           % ���һ������Ϊ5����һ����ֹƵ��Ϊ700*2/8000�ĵ�ͨ���ְ�����˹�˲���
s = filter(B,A,s);
R = zeros(143,1);   % zeros(m,n)������һ��m��n�е������

for k=1:143
    R(k) = s(144:223)'*s(144-k:223-k);
end

[R1,T1] = max(R(80:143));   % [Y,U]=max(A)������������Y��U��Y������¼A��ÿ�е����ֵ��U������¼ÿ�����ֵ���кš�
T1 = T1 + 79;
R1 = R1/(norm(s(144-T1:223-T1))+1);

[R2,T2] = max(R(40:79));
T2 = T2 + 39;
R2 = R2/(norm(s(144-T2:223-T2))+1);

[R3,T3] = max(R(20:39));
T3 = T3 + 19;
R3 = R3/(norm(s(144-T3:223-T3))+1);

Top = T1;
Rop = R1;
if R2 >= 0.85*Rop
    Rop = R2;
    Top = T2;
end
if R3 > 0.85*Rop
    Rop = R3;
    Top = T3;
end

PT = Top;
return