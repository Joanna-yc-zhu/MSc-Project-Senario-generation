function line_failing_prob = calculate_line_failing_prob(Pr_out, pole_num, line_num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    line_failing_prob = zeros(size(Pr_out,1),size(Pr_out,2));
    for angle_idx = 1:size(Pr_out,2)
        for line = 1:length(Pr_out)
            i = line_num(line,2);
            j = line_num(line,2);
            failing_indv = linspace(Pr_out(i,angle_idx),Pr_out(j,angle_idx),pole_num(line));
            failing_indv = 1 - failing_indv;
            line_failing_prob(line,angle_idx) = 1 - prod(failing_indv);
        end
    end
end