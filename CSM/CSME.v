//CSME
//Sepehr Razmyar 2020
module CSME (
          x,
          b,
          u,
          bo,
          d
  );
  // y = 0;
  input x, b, u;
  output bo, d;

  wire xNot, bNot, uNot;

  assign xNot = ~x;
  assign bNot = ~b;
  assign uNot = ~u;

  wire temp;
  assign temp = xNot & b;
  assign bo = temp;
  assign d = (temp & uNot) | (x & (u | bNot));


endmodule
