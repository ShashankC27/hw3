`default_nettype none

module my_mem_tb;
    logic clk;
    reg write;
    reg read;
    reg [7:0] data_in;
    wire [8:0] data_out;
    reg [15:0] address;
    my_mem tb(.clk(clk),.write(write),.read(read),.data_in(data_in),.address(address),.data_out(data_out));
    
    integer i,size=6,error_count=0,j=0;

    struct memorystructure {
        bit [15:0] Address_to_rw;
        bit [7:0] Data_to_Write;
        bit [7:0] Expected_data_Read;
        bit [7:0] Actual_data_Read;  
    };

    initial begin
        clk=0;
        memorystructure memarray[size];
        write=0;
        read=0;
    end

    initial begin
    $dumpfile ("my_mem_tb.vcd");
    $dumpvars (0,my_mem_tb);
    $vcdpluson;
    $vcdplusmemon;
    end

    integer Ecount=0; // declaring variable to count the errors obtained in testing
    always #5 clk = ~clk;
    initial begin

        for (i = 0; i < size; i++) begin
            memarray[i].Address_to_rw = $unsigned($urandom());
            memarray[i].Data_to_Write = $urandom();
        end

    end

    always @(posedge clk ) begin
        if(j<size) begin
            writefunc(j);
            j++;
        end
        else if(j==6) begin
            for (i = 0; i < size; i++) begin
            //$display("key = %h, value = %h", address_arr[i], data_read_expect_assoc[address_arr[i]]);
            end
            j++;
        end
        else if(j>6 && j<13 ) begin
            readfunc(j);
            j++;
        end
        else if(j==13) begin
            lastdisplay();
            j++;
        end
        else begin
            $finish;
        end
    end

task writefunc(integer j);
    data_in=memarray[j].Data_to_Write;
    address=memarray[j].Address_to_rw;
    memarray[j].Expected_data_Read = data_in;
    write=1;
    #10;
    write=0;
endtask

task readfunc(integer j);
    address=memarray[j-7].Address_to_rw;
    read=1;
    //clk=0;
    #10;
    //$display("and values are = %h",data_out);
    //$display("and values are = %h",data_read_expect_assoc[address]);
    memarray[j-7].Actual_data_Read = data_out[7:0];//excluding the parity
    if(memarray[j-7].Actual_data_Read != memarray[j-7].Expected_data_Read) begin
        error_count++;
        end
    read=0;
endtask

task lastdisplay();
    $display("Total Errors = %d and size is %d",error_count,data_read_queue_arr.size());
        //foreach (my_element;data_read_queue_arr) begin
    for (i = 0; i < size; i++) begin
            $display("elements = %h",memarray[i].Actual_data_Read);
    end
        //end
endtask
endmodule