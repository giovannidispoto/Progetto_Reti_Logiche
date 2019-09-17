----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- Create Date: 02.03.2019 11:15:16
-- Design Name:
-- Module Name: project_reti_logiche - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_1164.all;            -- basic logic types

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is

port(
i_clk     : in std_logic;
i_start   : in std_logic;
i_rst     : in std_logic;
i_data    : in std_logic_vector(7 downto 0);
o_address : out std_logic_vector(15 downto 0);
o_done    : out std_logic;
o_en      : out std_logic;
o_we      : out std_logic;
o_data    : out std_logic_vector(7 downto 0)
);
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
type state_type is (STATO_INIZIALE, LEGGI_MASCHERA, LEGGI_X_DA_VALUTARE, LEGGI_Y_DA_VALUTARE, LEGGI_X, LEGGI_Y, CALCOLA_DISTANZA, COMPUTA_MASCHERA ,SCRIVI_MASCHERA, TERMINE_COMPUTAZIONE);

signal state, next_state: state_type;
signal maschera, maschera_next: std_logic_vector (7 downto 0);
signal current_x, current_x_next: std_logic_vector(7 downto 0);
signal current_y, current_y_next: std_logic_vector(7 downto 0);
signal point_x, point_x_next: std_logic_vector (7 downto 0);
signal point_y, point_y_next: std_logic_vector(7 downto 0);
signal index_value, index_value_next: std_logic_vector(7 downto 0);
signal maschera_out, maschera_out_next: std_logic_vector(7 downto 0);
signal distanza, distanza_next: std_logic_vector(8 downto 0);
signal current_index, current_index_next: std_logic_vector(7 downto 0);

signal current_distance, current_distance_next: std_logic_vector(8 downto 0);
signal v1, v2: std_logic_vector(8 downto 0);



begin

--
process(i_clk, i_rst, i_start)

begin
-- gestione dei segnali asicroni e dello stato del componente
if(i_rst = '1' or i_start = '0') then
state <= STATO_INIZIALE;
elsif(rising_edge(i_clk)) then
state <= next_state;
maschera <= maschera_next;
maschera_out <= maschera_out_next;
current_x <= current_x_next;
current_y <= current_y_next;
point_x <= point_x_next;
point_y <= point_y_next;
distanza <= distanza_next;
index_value <= index_value_next;
current_distance <= current_distance_next;
current_index <= current_index_next;
end if;


end process;

process(state, i_start, i_data, index_value,state, current_index, current_distance, current_x, current_y, point_x, point_y, distanza,maschera_out, maschera, current_index, current_distance)
begin

case state is

-- stato inizial del sistema, inizializza tutte le variabili
-- rimango in attesa dello start per iniziare la computazione
when STATO_INIZIALE =>
      maschera_next <= "00000000";
      current_x_next <= "00000000";
      current_y_next <= "00000000";
      distanza_next <= "100000000";
      maschera_out_next <= "00000000";
      o_done <= '0';
      o_data <= maschera_out;
      current_distance_next <= (others => '0');
      current_index_next <= (others => '0');
      index_value_next <= (others => '0');
      point_y_next <= "00000000";
      point_x_next <= "00000000";
      if(i_start = '1') then
        o_we <= '0';
        o_en <= '1';
        o_address <= (others => '0'); -- imposto indirizzo su cui leggere la maschera per averlo disponibile al prossimo clock
        next_state <= LEGGI_MASCHERA;
      else
       o_en <= '0';
       o_we <= '0';
       o_address <= "0000000000000000";
       next_state <= STATO_INIZIALE;
      end if;

-- Leggo la maschera in ingresso che corrisponde ai centroidi effettivamente validi per la computazione
when LEGGI_MASCHERA =>
    o_we <= '0';
    o_en <= '1';
    o_done <= '0';
    o_data<= maschera_out;
    o_address <= "0000000000010001"; -- imposto l'indirizzo del prossimo valore da leggere in modo tale da averlo disponibile al prossimo clock
    next_state <= LEGGI_X_DA_VALUTARE;
    maschera_next <= i_data;
    distanza_next <= distanza;
    maschera_out_next <= maschera_out;
    current_index_next <= current_index;
    current_distance_next <= current_distance;
    index_value_next <= index_value;
    point_y_next <= point_y;
    point_x_next <= point_x;
    current_x_next <= current_x;
    current_y_next <= current_y;


 -- Leggo coordinata x del punto da valutare
 when LEGGI_X_DA_VALUTARE =>
 point_x_next <= i_data;
 o_we <= '0';
 o_en <= '1';
 o_done <= '0';
 o_data <= maschera_out;
 o_address <= "0000000000010010";
 index_value_next <= std_logic_vector(to_unsigned( to_integer(unsigned(index_value)) +1 ,8)); -- effettuo il conteggio dei valori per capire a che punto mi trovo
 next_state <= LEGGI_Y_DA_VALUTARE;
 maschera_next <= maschera;
 distanza_next <= distanza;
 maschera_out_next <= maschera_out;
 current_index_next <= current_index;
 current_distance_next <= current_distance;
 point_y_next <= point_y;
 current_x_next <= current_x;
 current_y_next <= current_y;



 -- leggo coordinata y del centroide da valutare
 when LEGGI_Y_DA_VALUTARE =>
 point_y_next <= i_data;
 o_we <= '0';
 o_en <= '1';
 o_done <= '0';
 o_data<= maschera_out;
 index_value_next <= std_logic_vector(to_unsigned( to_integer(unsigned(index_value)) +1 ,8));
 o_address <=  std_logic_vector(to_unsigned( 0 + to_integer(unsigned(index_value)), 16));
 next_state <= LEGGI_X;
 maschera_next <= maschera;
 distanza_next <= distanza;
 maschera_out_next <= maschera_out;
 current_index_next <= current_index;
 current_distance_next <= current_distance;
 point_x_next <= point_x;
 current_x_next <= current_x;
 current_y_next <= current_y;

 -- leggo coordinata x del centroide da valutare
 when LEGGI_X =>
 current_x_next <= i_data;
 o_we <= '0';
 o_en <= '1';
 o_done <= '0';
 o_data<= maschera_out;
 o_address <= std_logic_vector(to_unsigned( 0 + to_integer(unsigned(index_value)), 16));
 index_value_next <= std_logic_vector(to_unsigned(to_integer(unsigned(index_value)) + 1, 8));
 next_state <= LEGGI_Y;
 maschera_next <= maschera;
 distanza_next <= distanza;
 maschera_out_next <= maschera_out;
 current_index_next <= current_index;
 current_y_next <= current_y;
 current_distance_next <= current_distance;
 point_y_next <= point_y;
 point_x_next <= point_x;

 -- leggo coordinata y del centroide
 when LEGGI_Y =>
    o_done <= '0';
    o_en <= '0';
    o_we <= '0';
    o_data<= maschera_out;
   current_y_next <= i_data;
   o_address <= std_logic_vector(to_unsigned( 0 + to_integer(unsigned(index_value)), 16));
   --index_value_next <= std_logic_vector(to_unsigned(to_integer(unsigned(index_value)) + 1, 8));
   next_state <= CALCOLA_DISTANZA;
   maschera_next <= maschera;
   distanza_next <= distanza;
   maschera_out_next <= maschera_out;
   current_index_next <= current_index;
   current_distance_next <= current_distance;
   index_value_next <= index_value;
   point_y_next <= point_y;
   point_x_next <= point_x;
   current_x_next <= current_x;

   -- calcolo distanza rispetto al punto
  when CALCOLA_DISTANZA =>

  current_distance_next <= std_logic_vector(to_unsigned(abs(to_integer(unsigned(current_x)) - to_integer(unsigned(point_x))) + abs(to_integer(unsigned(current_y)) - to_integer(unsigned(point_y))),9));
  current_index_next <= '0' & index_value(7 downto 1);
  o_we <= '0';
  o_en <= '0';
  o_address <=  (others =>'0');
  o_done <= '0';
  o_data<= maschera_out;
  index_value_next<=index_value;
  next_state <= COMPUTA_MASCHERA;
  maschera_next <= maschera;
  distanza_next <= distanza;
  maschera_out_next <= maschera_out;
  point_y_next <= point_y;
  point_x_next <= point_x;
  current_x_next <= current_x;
  current_y_next <= current_y;



 -- preparo la maschera in output abilitando sulla maschera tutti i centroidi che risultano essere in distanze minori o uguali alla distanza minima
 when COMPUTA_MASCHERA =>
 if(maschera(to_integer(unsigned(current_index))-1) = '1') then

        if(to_integer(unsigned(current_distance)) < to_integer(unsigned(distanza))) then
             distanza_next <= current_distance;
             maschera_out_next <= (others =>'0');
           maschera_out_next(to_integer(unsigned(current_index)) - 1) <= '1';
         elsif(to_integer(unsigned(current_distance)) = to_integer(unsigned(distanza))) then
            distanza_next <= current_distance;
            maschera_out_next <= maschera_out;
           maschera_out_next(to_integer(unsigned(current_index)) - 1) <= '1';
         else
             distanza_next <= distanza;
             maschera_out_next <= maschera_out;
         end if;


    else
      maschera_out_next <= maschera_out;
      distanza_next <= distanza;
   end if;


  if(to_integer(unsigned(current_index)) = 8) then
      next_state <= SCRIVI_MASCHERA;
      o_we <= '0';
      o_en <= '0';
      o_address <=  (others =>'0');
      o_done <= '0';
      index_value_next <= index_value;
     else
        o_we <= '0';
        o_en <= '1';
        o_address <=  std_logic_vector(to_unsigned( 0 + to_integer(unsigned(index_value)), 16));
        index_value_next <= std_logic_vector(to_unsigned(to_integer(unsigned(index_value)) + 1, 8));
        o_done <= '0';
        next_state <= LEGGI_X;
    end if;
    o_data<= maschera_out;
    maschera_next <= maschera;
    current_index_next <= current_index;
    current_distance_next <= current_distance;
    point_y_next <= point_y;
    point_x_next <= point_x;
    current_x_next <= current_x;
    current_y_next <= current_y;
 -- scrivo la maschera in memoria
 when SCRIVI_MASCHERA =>
     o_we <= '1';
     o_en <= '1';
     o_done <= '0';
     o_address <= "0000000000010011";
      -- l'and bit a bit mi serve per filtrare i centroidi non validi indicati sulla maschera d'ingresso
     o_data <= maschera_out;
     next_state <= TERMINE_COMPUTAZIONE;
     maschera_next <= maschera;
     distanza_next <= distanza;
     maschera_out_next <= maschera_out;
     current_index_next <= current_index;
     current_distance_next <= current_distance;
     index_value_next <= index_value;
     point_y_next <= point_y;
     point_x_next <= point_x;
     current_x_next <= current_x;
     current_y_next <= current_y;
  -- pongo il segnale ad on
  when TERMINE_COMPUTAZIONE =>
         o_done <= '1';
         o_en <= '0';
         o_we <= '0';
         o_address <= "0000000000000000";
         o_data<= maschera_out;
         next_state <= STATO_INIZIALE;
         maschera_next <= maschera;
         maschera_out_next <= maschera_out;
        distanza_next <= distanza;
        current_index_next <= current_index;
        current_distance_next <= current_distance;
        index_value_next <= index_value;
        point_y_next <= point_y;
        point_x_next <= point_x;
        current_x_next <= current_x;
        current_y_next <= current_y;

end case;

end process;

end Behavioral;
