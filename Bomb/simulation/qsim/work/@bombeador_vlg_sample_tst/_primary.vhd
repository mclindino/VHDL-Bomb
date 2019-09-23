library verilog;
use verilog.vl_types.all;
entity Bombeador_vlg_sample_tst is
    port(
        blue            : in     vl_logic;
        clock_ini       : in     vl_logic;
        ENTER           : in     vl_logic;
        green           : in     vl_logic;
        orange          : in     vl_logic;
        purple          : in     vl_logic;
        red             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Bombeador_vlg_sample_tst;
