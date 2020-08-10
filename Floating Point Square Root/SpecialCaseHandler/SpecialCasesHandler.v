module SpecialCasesHandler (
                      isInputStable,
                      isFloat,
                      sign,
                      exponent,
                      mantissa,
                      out,
                      isInputNormalized
  );


  parameter SIZE = 8'd64,
            EXPONENT_SIZE = 4'd11,
            MANTISSA_SIZE = 6'd52;


  input     isFloat, isInputStable;
  input     sign;
  input     [EXPONENT_SIZE - 1:0] exponent;
  input     [MANTISSA_SIZE - 1:0] mantissa;
  output    [SIZE -1:0] out;
  reg       [SIZE -1:0] out;
  output    isInputNormalized;
  reg       isInputNormalized;

  always @ ( * ) begin
    if (isInputStable) begin
      isInputNormalized = 0;
      if (isFloat) begin
        // if a is NaN or negative return NaN
        if (sign == 1 || (exponent[7:0] == 255 && mantissa[22:0] != 0)) begin
          out[31] = sign;
          out[30:23] = 255;
          out[22] = 1;
          out[21:0] = 0;
          // state = put_z;
        end
        // if a is inf return inf
        else if (exponent[7:0] == 255) begin
          out[31] = sign;
          out[30:23] = 255;
          out[22:0] = 0;
          // state = put_z;
        // if a is zero return zero
        end
        else if ((exponent[7:0] == 0) && (mantissa[22:0] == 0)) begin
          out[31] = sign;
          out[30:23] = 0;
          out[22:0] = 0;
          // state = put_z;
        end
        else begin
          // Denormalised Number
          if (exponent[7:0] < 255) begin
            isInputNormalized = 1;
            out = {sign, exponent, mantissa};
          end else begin
            isInputNormalized = 0;
            out[31] = sign;
            out[30:23] = 255;
            out[22] = 1;
            out[21:0] = 0;
          end

        end
      end

      else
      begin
        // if a is NaN or negative return NaN
        if (sign == 1 || (exponent[10:0] == 2047 && mantissa[51:0] != 0)) begin
          out[63] = sign;
          out[62:52] = 2047;
          out[51] = 1;
          out[50:0] = 0;
          // state = put_z;
        end
        // if a is inf return inf
        else if (exponent[10:0] == 2047) begin
          out[63] = sign;
          out[62:52] = 2047;
          out[51:0] = 0;
          // state = put_z;
        // if a is zero return zero
        end else if ((($signed(exponent[10:0]) == 0) && (mantissa[51:0] == 0))) begin
          out[63] = sign;
          out[62:52] = 0;
          out[51:0] = 0;
          // state = put_z;
        end
        else begin
          // Denormalised Number
          if (exponent < 2047) begin
            isInputNormalized = 1;
            out = {sign, exponent, mantissa};
          end else begin
            isInputNormalized = 0;
            out[63] = sign;
            out[62:52] = 2047;
            out[51] = 1;
            out[50:0] = 0;

          end
        end
      end
    end
    else begin
      isInputNormalized = 0;
      out = 0;

    end
  end


endmodule // SpecialCasesHandler
