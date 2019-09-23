library verilog;
use verilog.vl_types.all;
entity Bombeador is
    port(
        clock_ini       : in     vl_logic;
        ENTER           : in     vl_logic;
        red             : in     vl_logic;
        green           : in     vl_logic;
        blue            : in     vl_logic;
        orange          : in     vl_logic;
        purple          : in     vl_logic;
        clock_end       : out    vl_logic
    );
end Bombeador;
