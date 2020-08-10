//CSM
//Sepehr Razmyar 2020
module CSM (
          x,
          y,
          b,
          u,
          bo,
          d
  );

  input x, y, b, u;
  output bo, d;

  wire xNot, yNot, bNot, uNot;

  assign xNot = ~x;
  assign yNot = ~y;
  assign bNot = ~b;
  assign uNot = ~u;

  assign bo = (xNot & (y | b)) | (y & b);
  assign d = ((xNot & uNot) & (y ^ b)) | (x & (u | ~(y ^ b)));

endmodule
