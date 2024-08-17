function line_failing_prob = calculate_line_failing_prob(Pr_out, pole_num, line_num, N0)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    line_failing_prob = zeros(size(Pr_out,1),size(Pr_out,2),N0);
    line_considered = size(Pr_out);
    for s = 1:N0
        for angle_idx = 1:size(Pr_out,2)
            for line = 1:line_considered(1)
                i = line_num(line,2);
                j = line_num(line,3);
                failing_indv = linspace(Pr_out(i,angle_idx,s),Pr_out(j,angle_idx,s),pole_num(line));
                failing_indv = 1 - failing_indv;
                line_failing_prob(line,angle_idx,s) = 1 - prod(failing_indv);
            end
        end
    end
    endm