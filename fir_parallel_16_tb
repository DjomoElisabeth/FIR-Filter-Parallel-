----------------------------------------------------------------------------------
-- Testbench du filtre FIR parallèle à 16 échantillons avec pipeline
-- 
-- Description :
-- Ce testbench permet de valider le fonctionnement du filtre FIR parallèle en
-- appliquant différents stimuli, y compris une impulsion pour observer la réponse
-- impulsionnelle.
--
-- Auteur     : DJOMO ELISABETH
-- Date       : 20-01-2025
-- Licence    : MIT License
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- SECTION 1 : SIMULATION DE LA REPONSE IMPULSIONNELLE DU FILTRE
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Nouvelle bibliothèque standard pour les opérations arithmétiques

-- Déclaration de l'entité du testbench
entity fir_parallel_16_tb_impulse is
end entity;

architecture bench of fir_parallel_16_tb_impulse is

  -- Déclaration du composant FIR
  component fir_parallel_16
    port (
      clk       : in  std_logic;                      -- Horloge principale
      reset_n   : in  std_logic;                      -- Réinitialisation active bas
      data_in   : in  std_logic_vector(7 downto 0);   -- Données d'entrée (8 bits)
      clk_can   : out std_logic;                      -- Horloge CAN
      clk_cna   : out std_logic;                      -- Horloge CNA
      data_out  : out std_logic_vector(7 downto 0)    -- Données de sortie filtrées (8 bits)
    );
  end component;

  -- Déclaration des signaux de test
  signal clk       : std_logic := '0';  -- Signal d'horloge principal
  signal reset_n   : std_logic := '1';  -- Signal de réinitialisation actif bas
  signal data_in   : std_logic_vector(7 downto 0);  -- Signal d'entrée de données
  signal clk_can   : std_logic;  -- Horloge pour le CAN
  signal clk_cna   : std_logic;  -- Horloge pour le CNA
  signal data_out  : std_logic_vector(7 downto 0);  -- Signal de sortie de données

  -- Définition de la période d'horloge
  constant clk_period : time := 20 ns;

begin

  -- Instanciation du filtre FIR sous test (DUT)
  uut: fir_parallel_16
    port map (
      clk       => clk,
      reset_n   => reset_n,
      data_in   => data_in,
      clk_can   => clk_can,
      clk_cna   => clk_cna,
      data_out  => data_out
    );

  -- Génération de l'horloge
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -- Application des stimuli : Test de réponse impulsionnelle
  stimulus_process : process
  begin
    report "Début de la simulation - Application de la réinitialisation.";
    reset_n <= '0';
    data_in <= std_logic_vector(to_unsigned(128, 8)); -- Valeur neutre (0 en CA2)
    wait for 40 ns;

    report "Fin de la réinitialisation - Application d'une impulsion.";
    reset_n <= '1';
    data_in <= std_logic_vector(to_unsigned(255, 8)); -- Impulsion
    wait for 20 ns;

    report "Retour à la valeur neutre.";
    data_in <= std_logic_vector(to_unsigned(128, 8));
    wait;
  end process;

end bench;


----------------------------------------------------------------------------------
-- SECTION 2 : SIMULATION DE LA REPONSE DU FILTRE A UN SIGNAL SINUSOÏDAL
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; -- Pour la lecture et l'écriture de fichiers

-- Déclaration de l'entité du testbench
entity fir_parallel_16_tb_sine is
end entity;

architecture bench of fir_parallel_16_tb_sine is

  -- Déclaration du composant FIR
  component fir_parallel_16
    port (
      clk       : in  std_logic;
      reset_n   : in  std_logic;
      data_in   : in  std_logic_vector(7 downto 0);
      clk_can   : out std_logic;
      clk_cna   : out std_logic;
      data_out  : out std_logic_vector(7 downto 0)
    );
  end component;
  
  -- Fichiers d'entrée et de sortie
  file input_file  : text open read_mode is "chemin_vers_le fichier_contenant_les_les valeurs_du_signal_généré_avec_matlab";
  file output_file : text open write_mode is "chemin_vers_le_dossier_ou_vous_voulez_stocker_le_signal_de_sortie";

  -- Déclaration des signaux de test
  signal clk       : std_logic := '0';
  signal reset_n   : std_logic := '1';
  signal data_in   : std_logic_vector(7 downto 0);
  signal clk_can   : std_logic;
  signal clk_cna   : std_logic;
  signal data_out  : std_logic_vector(7 downto 0);

begin

  -- Instanciation du DUT (Device Under Test)
  uut: fir_parallel_16
    port map (
      clk       => clk,
      reset_n   => reset_n,
      data_in   => data_in,
      clk_can   => clk_can,
      clk_cna   => clk_cna,
      data_out  => data_out
    );

  -- Génération de l'horloge
  clk_process : process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  -- Processus de réinitialisation
  reset_process : process
  begin
    reset_n <= '0';
    wait for 10 ns;
    reset_n <= '1';
    wait;
  end process;

  -- Lecture des données d'entrée depuis le fichier
  input_process : process(clk)
    variable line_data : line;
    variable result    : integer;
  begin
    if falling_edge(clk) then
      readline(input_file, line_data);  -- Lecture d'une ligne du fichier
      read(line_data, result);           -- Conversion en entier
      data_in <= std_logic_vector(to_signed(result, 8)); 
    end if;
  end process;

  -- Écriture des résultats dans un fichier de sortie
  output_process : process(clk)
    variable line_data : line;
  begin
    if falling_edge(clk) then
      write(line_data, to_integer(signed(data_out)));  -- Conversion et écriture
      writeline(output_file, line_data);  -- Écriture dans le fichier
    end if;
  end process;

end bench;


end bench;
