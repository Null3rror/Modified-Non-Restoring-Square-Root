module SqrtMantissa (
  in,
  isFloat,
  isExponentOdd,
  mantissa,
  isDone
  );



  parameter BINARY_SIZE      = 8'd106, // must be even
            HALF_BINARY_SIZE = 8'd53,
            MANTISSA_SIZE    = 6'd52;

  input isFloat, isExponentOdd;
  input [BINARY_SIZE - 1:0] in;
  output [MANTISSA_SIZE - 1:0] mantissa;
  output isDone;

  wire [HALF_BINARY_SIZE-1:0] binarySquareRootOut;
  reg isBinarySquareRootDone;
  SqrtBinary #(.SIZE(BINARY_SIZE), .HALF_SIZE(HALF_BINARY_SIZE)) sqrtBinary (
      .p(in),
      .u(binarySquareRootOut)
    );

  always @ (binarySquareRootOut[0]) begin
    isBinarySquareRootDone = 1;
  end

  ConvertBinaryToMantissa convertBinaryToMantissa (
    .en(isBinarySquareRootDone),
    .isFloat(isFloat),
    .isExponentOdd(isExponentOdd),
    .in(binarySquareRootOut),
    .mantissa(mantissa),
    .isDone(isDone)
    );

endmodule // sqrtMantissa
