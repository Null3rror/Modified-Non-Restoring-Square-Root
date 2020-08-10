
module ExponentSqrt (
        isFloat,
        exponent,
        out
  );
  parameter DOUBLE_PRECISION_ODD  = 11'd52,
            SINGLE_PRECISION_ODD  = 8'd23,
            DOUBLE_PRECISION_EVEN = 11'd53,
            SINGLE_PRECISION_EVEN = 8'd24,
            EXPONENT_SIZE         = 4'd11;


  // parameter SIZE = 4'd8;
  input     isFloat;
  input     [EXPONENT_SIZE - 1:0] exponent;
  output    [EXPONENT_SIZE - 1:0] out;

  assign    out = (exponent & 1) ? isFloat ? ((exponent - SINGLE_PRECISION_ODD) >> 1) + 8'd75 : ((exponent - 11'd1075 - DOUBLE_PRECISION_ODD) >> 1) + 11'd1075  : isFloat ? ((exponent - SINGLE_PRECISION_EVEN) >> 1) + 8'd75 : ((exponent - 1075 - DOUBLE_PRECISION_EVEN) >> 1) + 11'd1075;




endmodule
