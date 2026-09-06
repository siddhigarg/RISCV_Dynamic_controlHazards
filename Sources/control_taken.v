module ctrl_T(input branch_and, input branch_ex_mem, output flush_on_not_taken);
    assign flush_on_not_taken = branch_ex_mem & ~branch_and;
endmodule
