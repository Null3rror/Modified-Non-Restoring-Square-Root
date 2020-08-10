//CSMD
//Sepehr Razmyar 2020
module CSMD (
          x,
          u,
          bo,
          d
  );

  //y = 1 b = 0

  input x, u;
  output bo, d;

  assign bo = ~x;
  assign d = ~(x ^ u);

endmodule
