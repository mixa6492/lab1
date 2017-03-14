-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
                             );
END clk_counter;

ARCHITECTURE rtl OF clk_counter IS

component reg is
	generic(
		WIDTH    : positive := 26;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component reg;




signal   cnt : STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	cnt1: STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	cnt2 : STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	cnt3 : STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	cnt4 : STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	one_sec: std_logic;
signal 	rst_in:STD_LOGIC;
BEGIN

-- DODATI:
-- brojac koji kada izbroji dovoljan broj taktova generise SIGNAL one_sec_o koji
-- predstavlja jednu proteklu sekundu, brojac se nulira nakon toga


-- Registar
rst_in<=not(rst_i);
r1: reg PORT MAP (
                i_clk  => clk_i,
                in_rst => rst_in,
                i_d    => cnt4,
                o_q   => cnt
                );
--Sabirac
cnt1<=cnt+1;
--MUX1
with one_sec select
cnt2<= 
		"00000000000000000000000000" when '1',
		cnt1 when others;
--MUX2
with cnt_en_i select
cnt3 <=
		cnt when '0',
		cnt2 when others;
--MUX3
with cnt_rst_i select
cnt4 <=
		cnt3 when '0',
		"00000000000000000000000000" when others;
--Out
one_sec_o<=one_sec;

END rtl;