module ConvertBinaryToMantissa (
          en,
          isFloat,
          isExponentOdd,
          in,
          mantissa,
          isDone
  );
  parameter DOUBLE_PRECISION_ODD  = 11'd52,
            SINGLE_PRECISION_ODD  = 8'd23,
            DOUBLE_PRECISION_EVEN = 11'd53,
            SINGLE_PRECISION_EVEN = 8'd24,
            MANTISSA_SIZE         = 6'd52,
            BINARY_SIZE           = 8'd106;

  input     en, isFloat, isExponentOdd;
  output reg isDone;
  input     [53-1:0] in;
  output    [MANTISSA_SIZE-1:0] mantissa;
  reg       [MANTISSA_SIZE-1:0] mantissa;


  always @ (*) begin

    if (en) begin
      if (isFloat) begin
        if (isExponentOdd) begin
          mantissa = in[22:0];
        end
        else begin
          mantissa = in[22:0];
        end
        isDone = 1;
      end
      else begin
        if (isExponentOdd) begin
          mantissa = in[51:0];
        end
        else begin
          mantissa = in[51:0];
        end
        isDone = 1;
      end
    end
    else begin
      mantissa = 0;
      isDone = 0;
    end
  end


endmodule // ConvertMantissa
