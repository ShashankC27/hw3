`default_nettype none

module my_mem_tb;
    logic clk;
    reg write;
    reg read;
    reg [7:0] data_in;
    wire [8:0] data_out;
    reg [15:0] address;
    
    integer i,size=6,error_count=0,j=0;

    //declared an structure with the mentioned features that are add,data,expected arra adn actual data
    typedef struct {
        bit [15:0] Address_to_rw;
        bit [7:0] Data_to_Write;
        bit [8:0] Expected_data_Read;
        bit [8:0] Actual_data_Read;  
    } memorystructure;

    memorystructure memarray[];
    my_mem tb(.clk(clk),.write(write),.read(read),.data_in(data_in),.address(address),.data_out(data_out));
    
    initial begin
        clk=0;
        write=0;
        read=0;
        memarray =new[6];//declaiung the array structure with name memarray
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
            $display("VAlues feed are %h and %h",memarray[i].Address_to_rw ,memarray[i].Data_to_Write);
        end

    end

    always @(posedge clk ) begin
        if(j<size) begin
            writefunc(j); //calling the write func to write into the memory
            j++;
        end
        else if(j==6) begin
            shufflefun();//using this to shuffle the array after inserting the data and filling the array structure with address and data and expected array
            j++;
        end
        else if(j>6 && j<13 ) begin
            readfunc(j); //callign the read func to read the memory data
            j++;
        end
        else if(j==13) begin
            lastdisplay(); // displaying the structure with data received and address
            j++;
        end
        else begin
            $finish; // finishing the run
        end
    end

task writefunc(integer j);
    data_in=memarray[j].Data_to_Write;//inserting data
    address=memarray[j].Address_to_rw;// inserting address
    memarray[j].Expected_data_Read = {^memarray[j].Data_to_Write,memarray[j].Data_to_Write}; //inserting the expected array
    write=1;//enabling write pin
    #10;
    write=0;
endtask

task readfunc(integer j);
    address=memarray[j-7].Address_to_rw; // reading the address
    read=1;//enabling read high
    //clk=0;
    #10;
    //$display("and values are = %h",data_out);
    //$display("and values are = %h",data_read_expect_assoc[address]);
    memarray[j-7].Actual_data_Read = data_out;//excluding the parity
    if(memarray[j-7].Actual_data_Read != memarray[j-7].Expected_data_Read) begin
        $display("Obtained Error : Expected data %h and Actualdata received is %h",memarray[j-7].Expected_data_Read,memarray[j-7].Actual_data_Read);
        error_count++;//if expected is not mathced to received data its error and added
        end
    read=0;
endtask

task lastdisplay();
    $display("Total Errors = %d and size is %d",error_count,size);
        //foreach (my_element;data_read_queue_arr) begin
    for (i = 0; i < size; i++) begin
            $display("address  %h and elements =%h",memarray[i].Address_to_rw,memarray[i].Actual_data_Read);
    end
        //end
endtask

task shufflefun();//shuffling the structure
integer s,k;
memorystructure tmp;//used general shuffling method
    for( s=0;s<size;s++) begin
        k=$urandom_range(s,5);//using random range between the iterate number and maximum size
         tmp = memarray[s];
         memarray[s]=memarray[k];
         memarray[k]=tmp;
        end
endtask
endmodule