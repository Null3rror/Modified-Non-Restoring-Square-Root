//Binary Square root test bench
//Sepehr Razmyar 2020
module SqrtBinaryTB (
  );
  parameter SIZE      = 8'd64, // must be even
            HALF_SIZE = 8'd32;

  reg  [SIZE - 1 : 0] p;
  wire [HALF_SIZE - 1 : 0] u;
  integer fd;


  SqrtBinary #(.SIZE(SIZE), .HALF_SIZE(HALF_SIZE)) unit (
            .p(p),
            .u(u)
  );


  initial begin
    fd =  $fopen("SqrtBinary_output.txt", "w");
    p = 0;
    repeat(100) begin
      p[31:0] = $random;
      p[63:32] = $random;

      #100;
      $fwrite(fd, "%b %b\n%d %d\n", p, u, p, u);
    end
    $fclose(fd);
    $stop;
  end

endmodule
