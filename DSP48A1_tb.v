module DSP48A1_tb();
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg CLK,CARRYIN;
reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
reg CEA,CEB,CEC,CEM,CEP,CED,CECARRYIN,CEOPMODE;
reg [7:0] OPMODE;
wire [17:0] BCOUT;
wire [47:0] PCOUT;
wire [47:0] P;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;

DSP48A1 DUT(A,B,D,BCIN,C,PCIN,CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE
            ,CEA,CEB,CEC,CEM,CEP,CED,CECARRYIN,CEOPMODE,OPMODE,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

initial begin
    CLK = 0;
    forever begin
        #1 CLK = ~CLK;
    end
end

initial begin
    // Activate all Resets
    RSTA = 1;
    RSTB = 1;
    RSTM = 1;
    RSTP = 1;
    RSTC = 1;
    RSTD = 1;
    RSTCARRYIN = 1;
    RSTOPMODE = 1;
    A = 18'b0;
    B = 18'b0;
    D = 18'b0;
    BCIN = 18'b0;
    C = 48'b0;
    PCIN = 48'b0;
    CARRYIN = 1'b0;
    OPMODE = 8'b0;
    @(negedge CLK);
    RSTA = 0;
    RSTB = 0;
    RSTM = 0;
    RSTP = 0;
    RSTC = 0;
    RSTD = 0;
    RSTCARRYIN = 0;
    RSTOPMODE = 0;

    // Activate all Clock enables
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CED = 1;
    CEP = 1;
    CEM = 1;
    CECARRYIN = 1;
    CEOPMODE = 1;

    // Test case1 
    // PCOUT=((B+D)*A)+PCIN+OPMODE[5] appears after 4 clk cycles
    // B_COUT = B+D appear after 2 clk cycles
    // M = (B+D)*A appear after 4 clk cycles
    A = 18'h03;
    B = 18'h06;
    D = 18'h04;
    BCIN = 18'h05;
    C = 48'h09;
    PCIN = 48'h08;
    CARRYIN = 1;
    OPMODE = 8'b00010101;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 1: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end

    // Test case2 
    // P_COUT = (P_COUT-P_COUT)+OPMODE[5] appear after 1 clk cycles
    // B_COUT = D-B appear after 2 clk cycles
    // M = (D-B)*A appear after 4 clk cycles
    A = 18'h05;
    B = 18'h07;
    D = 18'h08;
    BCIN = 18'h09;
    C = 48'h08;
    PCIN = 48'h02;
    CARRYIN = 1;
    OPMODE = 8'b11001010;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 2: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end

    // Test case3 
    // P_COUT = ({D,A,B}+C)+OPMODE[5] appear after 3 clk cycles
    // B_COUT = B appear after 1 clk cycles
    // M = B*A appear after 3 clk cycles
    A = 18'h09;
    B = 18'h05;
    D = 18'h08;
    BCIN = 18'h09;
    C = 48'h08;
    PCIN = 48'h02;
    CARRYIN = 1;
    OPMODE = 8'b01011111;
    repeat(3) begin
    @(negedge CLK);
    $display("Test Case 3: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end

    // Test case4 
    // P_COUT = (B*A)+C+OPMODE[5] appear after 4 clk cycles
    // B_COUT = B appear after 1 clk cycles
    // M = B*A appear after 2 clk cycles
    A = 18'h03;
    B = 18'h06;
    D = 18'h07;
    BCIN = 18'h09;
    C = 48'hfffffffffffa;
    PCIN = 48'h02;
    CARRYIN = 0;
    OPMODE = 8'b00101101;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 4: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end

    // Test case5 
    // P_COUT = PCOUT+C+OPMODE[5] appear after 3 clk cycles
    // B_COUT = B appear after 1 clk cycles
    // M = B*A appear after 2 clk cycles
    A = 18'h09;
    B = 18'h05;
    D = 18'h08;
    BCIN = 18'h09;
    C = 48'h0fffa;
    PCIN = 48'h02;
    CARRYIN = 0;
    OPMODE = 8'b00101110;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 5: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end 

    // Test case6 
    // P_COUT = PCOUT+PCOUT+OPMODE[5] appear after 1 clk cycles
    // B_COUT = D-B appear after 2 clk cycles
    // M = (D-B)*A appear after 3 clk cycles
    A = 18'h09;
    B = 18'h05;
    D = 18'h08;
    BCIN = 18'h09;
    C = 48'h0fffa;
    PCIN = 48'h02;
    CARRYIN = 0;
    OPMODE = 8'b01111010;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 6: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end

    // Test case7 
    // P_COUT = PCIN+PCOUT+OPMODE[5] appear after 1 clk cycles
    // B_COUT = D-B appear after 2 clk cycles
    // M = (D-B)*A appear after 3 clk cycles
    A = 18'h09;
    B = 18'h05;
    D = 18'h08;
    BCIN = 18'h09;
    C = 48'h0fffa;
    PCIN = 48'hfffffffffffa;
    CARRYIN = 0;
    OPMODE = 8'b01110110;
    repeat(4) begin
    @(negedge CLK);
    $display("Test Case 7: P=%h, BCOUT=%h, M=%h, CARRYOUT=%b",P,BCOUT,M,CARRYOUT);
    end
    $stop;
end

initial begin
    $monitor("BCOUT=%h, PCOUT=%h, P=%h, M=%h, CARRYOUT=%h, CARRYOUTF=%h",BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
end
endmodule