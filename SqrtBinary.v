//Binary Square root
//Sepehr Razmyar 2020
module SqrtBinary (
            p,
            u
  );

  parameter SIZE      = 8'd108, // must be even
            HALF_SIZE = 8'd54;


  input  [SIZE-1 : 0] p;
  output [HALF_SIZE - 1:0] u;

  wire [SIZE-1:0] bo [0:HALF_SIZE-1];
  wire [SIZE-1:0] d  [0:HALF_SIZE-1];




  CSMD csm_D_ (p[SIZE-2], bo[HALF_SIZE-1][SIZE-1], bo[HALF_SIZE-1][SIZE-2], d[HALF_SIZE-1][SIZE-2]);
  CSME csm_E_ (p[SIZE-1], bo[HALF_SIZE-1][SIZE-2], bo[HALF_SIZE-1][SIZE-1], bo[HALF_SIZE-1][SIZE-1], d[HALF_SIZE-1][SIZE-1]);

  assign u[HALF_SIZE-1] = ~bo[HALF_SIZE-1][SIZE-1];


  generate
    genvar k;
    if (SIZE > 2) begin
      CSMA csmA (p[0], bo[0][0], d[0][0]);
      CSMB csm_B0_ (p[1], bo[0][0], bo[0][1], d[0][1]);
      for (k = 1; k <= HALF_SIZE - 1; k = k + 1) begin
        CSMC csmC (d[1][(SIZE - 1) - (HALF_SIZE - 2) - k], //x
                   u[HALF_SIZE - k], // y
                   bo[0][(SIZE - 1) - (HALF_SIZE - 2) - k - 1], // b
                   bo[0][(SIZE - 1) - (HALF_SIZE - 2) - k], //bo
                   d[0][(SIZE - 1) - (HALF_SIZE - 2) - k]  //d
        );
      end
      CSMB csm_B1_ (d[1][(SIZE - 1) - (HALF_SIZE - 2)], bo[0][(SIZE - 1) - (HALF_SIZE - 2) - 1], bo[0][(SIZE - 1) - (HALF_SIZE - 2)], d[0][(SIZE - 1) - (HALF_SIZE - 2)]);

      assign u[0] = ~bo[0][(SIZE - 1) - (HALF_SIZE - 2)];
    end

  endgenerate


  generate
    genvar i, j;

    if (SIZE > 4) begin
      for (i = 0; i <= HALF_SIZE - 3; i = 1 + i) begin
        CSMD csmD (p[(SIZE - 4) - i*2], //x
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i], // u
                   bo[(HALF_SIZE - 2) - i][(SIZE - 4) - i*2], //bo
                   d[(HALF_SIZE - 2) - i][(SIZE - 4) - i*2] //d
                   );
        CSME csmE (p[(SIZE - 3) - i*2],  //x
                   bo[(HALF_SIZE - 2) - i][(SIZE - 4) - i*2], // b
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i], //u
                   bo[(HALF_SIZE - 2) - i][(SIZE - 3) - i*2], //bo
                   d[(HALF_SIZE - 2) - i][(SIZE - 3) - i*2] // d
                   );
        for (j = 1; j <= i + 1; j = 1 + j) begin
          CSM csm (d[(HALF_SIZE - 1) - i][(SIZE - 1) - i - j], // x
                   u[HALF_SIZE - j], // y
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i - (j + 1)], // b
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i], // u
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i - j], // bo
                   d[(HALF_SIZE - 2) - i][(SIZE - 1) - i - j]  // d
                  );
        end
        CSMB csmB (d[(HALF_SIZE - 1) - i][(SIZE - 1) - i], //x
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i - 1], //b
                   bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i], // bo
                   d[(HALF_SIZE - 2) - i][(SIZE - 1) - i] // d
                  );
        assign u[(HALF_SIZE - 2) - i] = ~bo[(HALF_SIZE - 2) - i][(SIZE - 1) - i];
      end
    end




  endgenerate

endmodule // sqrtp
