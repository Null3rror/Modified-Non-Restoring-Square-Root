module FloatingPointMerger (
        isFloat,
        sign,
        exponent,
        mantissa,
        out
);
  parameter SIZE = 8'd64,
            EXPONENT_SIZE = 4'd11,
            BINARY_SIZE = 8'd106,
            MANTISSA_SIZE = 8'd52;


  input isFloat;
  input sign;
  input [EXPONENT_SIZE-1:0] exponent;
  input [MANTISSA_SIZE-1:0] mantissa;
  output reg [SIZE-1:0] out;

  always @ ( * ) begin
    if (isFloat) begin
      out = {32'b0, sign, exponent[7:0], mantissa[22:0]};
    end
    else begin
      out = {sign, exponent, mantissa};
    end
  end
endmodule
