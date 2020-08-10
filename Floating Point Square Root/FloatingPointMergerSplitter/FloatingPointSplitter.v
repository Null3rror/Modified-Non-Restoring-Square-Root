//assumes the in(input) is 64 bits
module FloatingPointSplitter (
                      isInputStable,
                      isFloat,
                      in,
                      sign,
                      exponent,
                      mantissa,
                      isOutputStable
  );

  // parameter SIZE = 8'b64;
  input     isFloat, isInputStable;
  input     [63:0] in;
  output    sign, isOutputStable;
  output    [10:0] exponent;
  output    [51:0] mantissa;


  assign sign = isInputStable ? isFloat ? in[31] : in[63] : 1; // returns negative if isInputStable == false
  assign exponent = isInputStable ? isFloat ? in[30:23] : in[63:52] : 0;
  assign mantissa = isInputStable ? isFloat ? in[22:0] : in[51:0] : 0;
  assign isOutputStable = isInputStable;


endmodule //
