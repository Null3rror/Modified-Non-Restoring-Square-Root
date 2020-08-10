module SqrtFloatingPointTB ();
  parameter SIZE = 8'd64,
            EXPONENT_SIZE = 4'd11,
            MANTISSA_SIZE = 6'd52;


  reg     clk = 0, rst = 1, isFloat, isInputStable = 0, z_ack;
  reg     [SIZE-1:0] a;
  wire    [SIZE-1:0] z;
  wire    zStable;

  always #5 clk=~clk;  // 50MHz
  integer fd;


  reg [SIZE - 1:0] mem [0:199];
  reg read_ram = 0;
  reg [7:0] idx;

  SqrtFloatingPoint sqrtUUT (
            .isInputStable(isInputStable),
            .in(a),
            .isFloat(isFloat),
            .clk(clk),
            .rst(rst),
            .result(z),
            .isResultStable(zStable),
            .resultAck(z_ack)
            );


  initial begin
    fd =  $fopen("D:/Edu/Computer Scinece and Engineering/CAD/Binary Square root/Modified-Non-Restoring-Square-Root/TestBench Outputs/single_sqrt_output.txt", "w");
    // fd1 = $fopen("D:/Edu/Computer Scinece and Engineering/CAD/Projects/computer-aided-design-sqrt-operation/RTL/Test Outputs/single_sqrt_Xn_output.txt", "w");
    // $fmonitor(fd1, "%b %b %d\n", a, sqrt_UUT.prev_result, sqrt_UUT.curr_iter);

    idx = 0;
    if (read_ram) begin
      $readmemb("D:/Edu/Computer Scinece and Engineering/CAD/Projects/computer-aided-design-sqrt-operation/RTL/input.txt", mem);
    end

    a = 0;
    isFloat = 1;
    rst = 1;
    #995
    rst = 0;

    repeat(100) begin
      z_ack = 0;
      if (read_ram) begin
        a = mem[idx];
      end
      else begin
        isFloat = $random & 1;
        if (isFloat) begin
          a = $random;
        end
        else begin
          a[31:0] = $random;
          a[SIZE - 1:32] = $random;
        end


        // a = 64'b 0000000000000000000000000000000001000000000000000000000000000000;
        // a[SIZE - 1:32] = $random;


      end
      // $fwrite(fd1, "x x x\n");
      isInputStable = 1;
      #10;
      isInputStable = 0;
      while(!zStable)
        #50;
      #20;
      if (isFloat) begin
        $fwrite(fd, "%b %b %b\n", a[31:0], z[31:0]+1, z[31:0]);  //Unsigned Integer
      end
      else begin
        $fwrite(fd, "%b %b %b\n", a, z+1, z);  //Unsigned Integer
      end

      z_ack = 1;
      #10;
      idx = idx + 1;

    end



    $fclose(fd);
    // $fclose(fd1);
    $stop;
  end
  endmodule
