// Verilog test fixture created from schematic D:\RedFlag\logic2018\exp04_1011_sch\Lampcontrol_led.sch - Thu Oct 11 11:40:35 2018

`timescale 1ns / 1ps

module Lampcontrol_led_Lampcontrol_led_sch_tb();

// Inputs
   reg S3;
   reg S2;
   reg S1;

// Output
   wire F;
   wire Buzzer;
   wire [6:0] LED;

// Bidirs

// Instantiate the UUT
   Lampcontrol_led UUT (
		.F(F), 
		.S3(S3), 
		.S2(S2), 
		.S1(S1), 
		.Buzzer(Buzzer), 
		.LED(LED)
   );
// Initialize Inputs
	initial begin	S3=0;S2=0; S1=0;#50;	           S1=1; #50;		 S2=1;S1=0; #50;              S1=1; #50;    S3=1;S2=0;S1=0; #50;              S1=1; #50;          S2=1;S1=0; #50;		      S1=1; #50;	end
endmodule
