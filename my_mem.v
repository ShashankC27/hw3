`default_nettype none

module my_mem(
		input var logic clk,
		input  var logic write,
		input  var logic read,
		input  var logic [7:0] data_in,
		input  var logic [15:0] address,
		output logic [8:0] data_out
);

   // Declare a 9-bit associative array using the logic data type
  bit [8:0] mem_array [int];
  
   always @(posedge clk) begin
      if (write) begin
        mem_array[address] = {^data_in, data_in};
       // $display("called write address %h %h",address,data_in);
      end
      else if (read) begin
        data_out =  mem_array[address];
        //$display("called fead address %h %h",address,data_out);
      end
   end
   
endmodule