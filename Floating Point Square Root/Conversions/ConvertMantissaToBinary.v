module ConvertMantissaToBinary (
          en,
          isFloat,
          isExponentOdd,
          mantissa,
          out
  );
  parameter DOUBLE_PRECISION_ODD  = 11'd52,
            SINGLE_PRECISION_ODD  = 8'd23,
            DOUBLE_PRECISION_EVEN = 11'd53,
            SINGLE_PRECISION_EVEN = 8'd24,
            MANTISSA_SIZE         = 6'd52,
            SIZE                  = 8'd106;

  input     en, isFloat, isExponentOdd;
  input     [MANTISSA_SIZE-1:0] mantissa;
  output    [SIZE-1:0] out;
  reg       [SIZE-1:0] out;


  always @ (*) begin

    if (en) begin
      if (isFloat) begin
        if (isExponentOdd) begin
          out = {59'b0, 1'b1, mantissa[22:0], 23'b0};
        end
        else begin
          out = {58'b0, 1'b1, mantissa[22:0], 24'b0};
        end
      end
      else begin
        if (isExponentOdd) begin
          out = {1'b0, 1'b1, mantissa[51:0], 52'b0};
        end
        else begin
          out = {1'b1, mantissa[51:0], 53'b0};
        end
      end
    end
    else begin
      out = 0;
    end
  end






endmodule // ConvertMantissa
