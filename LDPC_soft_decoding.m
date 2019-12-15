I_max  = 50;% 迭代最大次数
cnt_I  = 0 ;
L_r_ml = zeros(508,8763);
L_q_ml = zeros(508,8763);
L_q_l  = zeros(1  ,8763);

L_q_l = LLR_seq;
L_Pl = L_q_l;
% L_q_ml 初始化
for i = 1 : 508
    for j = 1 : H_col_max
        L_q_ml(i,H_1_col_position(i,j)) = L_q_l(1,H_1_col_position(i,j));
    end
end
% =================================================================
while(cnt_I < I_max && any(any(check_res)) )
    fprintf('第%d次纠错失败QAQ，进行第%d次纠错；\n',cnt_I,cnt_I + 1);
%   刷新L_r_ml的值
        for i = 1 : 508
            for j = 1 : H_col_max
%              求L(m)\l的L_q_ml之和
               Multip_tan_L_qml_2 = 1;
               for l = 1 : H_col_max
                   if l == j
                       continue;
                   else
                       Multip_tan_L_qml_2 = Multip_tan_L_qml_2 * tanh(L_q_ml(i,H_1_col_position(i,l))/2);
%                        fprintf('i = %d , j = %d , H_1_col_position = %d\n',i,j,H_1_col_position(i,l));
                   end
               end
               
               L_r_ml(i,H_1_col_position(i,j)) = 2*atanh(Multip_tan_L_qml_2);
                
            end
        end
    
%   刷新L_q_ml与L_q_l的值
        for i = 1 : H_row_max
            for j = 1 : base.codeword_length
                
%              求M(l)\m的L_r_ml之和  
               Sum_tan_L_rml_m = 0;
               for l = 1 : H_row_max
                   if l == i
                       continue;
                   else
                       Sum_tan_L_rml_m = Sum_tan_L_rml_m + L_r_ml(H_1_row_position(l,j),j);
%                        fprintf('i = %d , j = %d , H_1_row_position = %d\n',i,j,H_1_row_position(l,j));
                   end
               end
               
               L_q_ml(H_1_row_position(i,j),j,1) = L_Pl(1,j,1) + Sum_tan_L_rml_m;
            end
        end
  
    
        for j = 1 : base.codeword_length
    %          求M(l)的L_r_ml之和  
               Sum_tan_L_rml = 0;
               for l = 1 : H_row_max
                  Sum_tan_L_rml = Sum_tan_L_rml + L_r_ml(H_1_row_position(l,j),j);
%                   fprintf('i = %d , j = %d , H_1_row_position = %d\n',i,j,H_1_row_position(l,j)); 
               end
               
               L_q_l(1,j) = L_Pl(1,j) + Sum_tan_L_rml;
               
               if L_q_l(1,j) > 0
                   base.correct(1,j) = 0;
               else
                   base.correct(1,j) = 1;
               end
        end
    
    check_res = H_gf * base.correct'; 
       
    error_check = xor(base.correct,codeword);
    error_num = sum(error_check);
    fprintf('error_num = %d\n',error_num);
    
    if(any(any(check_res)) == 0)
        disp('correct successo((≧▽≦o)');
    end
    if(cnt_I == 19)
        disp('correct fail......')
    end
 
    cnt_I = cnt_I + 1;
end  

