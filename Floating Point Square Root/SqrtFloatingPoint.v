module SqrtFloatingPoint (
          isInputStable,
          isFloat,
          in,
          clk,
          rst,
          result,
          isResultStable,
          resultAck
  );


  parameter SIZE = 8'd64,
            EXPONENT_SIZE = 4'd11,
            BINARY_SIZE = 8'd106,
            MANTISSA_SIZE = 8'd52;


  input     clk, rst, isFloat, isInputStable;
  input     [SIZE-1:0] in;
  output reg [SIZE-1:0] result;
  output reg isResultStable;
  input     resultAck;



  wire      sign, isSplitterOutputStable;
  wire      [EXPONENT_SIZE - 1:0] exponent, sqrtExponent;
  wire      [MANTISSA_SIZE - 1:0] mantissa;
  wire      isSqrtMantissaDone;
  wire      isInputNormalized;
  wire      [SIZE - 1:0] specialCasesHandlerOutput;
  wire      [SIZE - 1:0] mergerResult;


  wire      [MANTISSA_SIZE - 1:0] sqrtMantissa;
  wire      [BINARY_SIZE - 1:0]  binaryMantissa;

  reg       [BINARY_SIZE - 1:0]  binaryMantissaReg;
  reg       [EXPONENT_SIZE - 1:0] exponentReg;
  reg       [MANTISSA_SIZE - 1:0] mantissaReg;
  reg       signReg;
  reg       isExponentOddReg;
  reg       isFloatReg;

  FloatingPointSplitter splitter (
          .isInputStable(isInputStable),
          .isFloat(isFloat),
          .in(in),
          .sign(sign),
          .exponent(exponent),
          .mantissa(mantissa),
          .isOutputStable(isSplitterOutputStable)
  );

  SpecialCasesHandler specialCasesHandler(
            .isInputStable(1'b1),
            .isFloat(isFloatReg),
            .sign(signReg),
            .exponent(exponentReg),
            .mantissa(mantissaReg),
            .out(specialCasesHandlerOutput),
            .isInputNormalized(isInputNormalized)
  );


  ExponentSqrt exponentSqrt(
          .isFloat(isFloatReg),
          .exponent(exponentReg),
          .out(sqrtExponent)
  );

  ConvertMantissaToBinary mantissa2Binary (
            .isExponentOdd(isExponentOddReg),
            .en(1'b1),
            .isFloat(isFloatReg),
            .mantissa(mantissaReg),
            .out(binaryMantissa)
  );

  SqrtMantissa  sqrtMantissa0(
      .in(binaryMantissaReg),
      .isFloat(isFloatReg),
      .isExponentOdd(isExponentOddReg),
      .mantissa(sqrtMantissa),
      .isDone(isSqrtMantissaDone)
  );

  FloatingPointMerger merger (
          .isFloat(isFloat),
          .sign(signReg),
          .exponent(exponentReg),
          .mantissa(mantissaReg),
          .out(mergerResult)
  );





  reg       [3:0] state;
  parameter getInput      = 4'd0,
            specialCases  = 4'd1,
            calculateSqrt0 = 4'd2,
            calculateSqrt1 = 4'd3,
            putOutput     = 4'd4;



  always @ (posedge clk) begin
    if (rst) begin
      state <= getInput;
      isResultStable <= 0;
    end
    else begin
      isResultStable <= 0;

      case (state)
        getInput:
        begin
          if (isInputStable) begin
            exponentReg <= exponent;
            mantissaReg <= mantissa;
            signReg <= sign;
            isFloatReg <= isFloat;
            state <= specialCases;
          end
          else
            state <= getInput;
        end


        specialCases:
        begin

          if (isInputNormalized) begin
            isExponentOddReg <= exponentReg & 1;
            state <= calculateSqrt0;
          end
          else begin
            result <= specialCasesHandlerOutput;
            state <= putOutput;
          end
        end

        calculateSqrt0:
        begin
          exponentReg <= sqrtExponent;
          binaryMantissaReg <= binaryMantissa;
          state <= calculateSqrt1;
        end

        calculateSqrt1:
        begin
          if (isSqrtMantissaDone) begin
            mantissaReg <= sqrtMantissa;
            state <= putOutput;
          end
        end

        putOutput:
        begin
          isResultStable <= 1;
          result <= mergerResult;
          if (resultAck & isResultStable) begin

            isResultStable <= 0;
            state <= getInput;
          end

        end



      endcase
    end
  end

endmodule // Sqrt
