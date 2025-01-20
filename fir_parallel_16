----------------------------------------------------------------------
-- Filtre FIR parallèle à 16 échantillons avec pipeline
-- 
-- Description :
-- Ce code VHDL implémente un filtre numérique FIR (Finite Impulse Response)
-- à 16 coefficients en utilisant une architecture parallèle et pipelinée.
-- Le filtre est conçu pour le traitement de signaux en temps réel et offre
-- une amélioration des performances grâce au traitement parallèle des 
-- échantillons et à une accumulation progressive des résultats.
--
-- Caractéristiques :
-- - Filtre FIR avec 16 coefficients prédéfinis.
-- - Données d'entrée et de sortie sur 8 bits en complément à deux (CA2).
-- - Architecture parallèle et pipelinée pour un traitement rapide.
-- - Synchronisation interne des horloges avec les signaux `clk_can` et `clk_cna`.
-- - Conçu pour une implémentation sur FPGA.
--
-- Entrées :
-- - clk       : Signal d'horloge principal.
-- - reset_n   : Signal de réinitialisation asynchrone, actif à l'état bas.
-- - data_in   : Données d'entrée sur 8 bits (complément à deux).
--
-- Sorties :
-- - clk_can   : Horloge synchronisée pour le CAN (Convertisseur Analogique-Numérique).
-- - clk_cna   : Horloge synchronisée pour le CNA (Convertisseur Numérique-Analogique).
-- - data_out  : Données de sortie filtrées sur 8 bits.
--
-- Auteur     : DJOMO Elisabeth
-- Date       : 20-01-2025
-- Licence    : Licence MIT 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Bibliothèque pour les opérations arithmétiques

-- Déclaration de l'entité du filtre FIR parallèle
entity fir_par_16echantillon is
    port (
        clk       : in  std_logic;                      -- Horloge principale
        reset_n   : in  std_logic;                      -- Réinitialisation active bas
        data_in   : in  std_logic_vector(7 downto 0);   -- Données d'entrée (8 bits)
        clk_can   : out std_logic;                      -- Horloge CAN
        clk_cna   : out std_logic;                      -- Horloge CNA
        data_out  : out std_logic_vector(7 downto 0)    -- Données de sortie filtrées (8 bits)
    );
end fir_par_16echantillon;


architecture Behavioral of fir_par_16echantillon is
    -- Déclaration des constantes et types
    type coeff_array is array (0 to 15) of integer range -128 to 127;  -- Coefficients du FIR (16 coefficients)
    type shift_reg_array is array (0 to 15) of std_logic_vector(7 downto 0); -- Registre de décalage
    type product_array is array (0 to 15) of signed(15 downto 0); -- Produit entre échantillons et coefficients
    type sum_array_0 is array (0 to 7) of signed(16 downto 0);  -- Somme de premier niveau (8 valeurs)
    type sum_array_1 is array (0 to 3) of signed(17 downto 0);  -- Somme de deuxième niveau (4 valeurs)
    type sum_array_2 is array (0 to 1) of signed(18 downto 0);  -- Somme de troisième niveau (2 valeurs)

    -- Coefficients FIR prédéfinis
    constant fir_coeffs : coeff_array := 
        (-1, -1, 2, 3, -6, -9, 18, 57, 57, 18, -9, -6, 3, 2, -1, -1);

    -- Déclaration des signaux internes
    signal product_result : product_array;   
    signal shift_register : shift_reg_array; 
    signal sum_stage_0    : sum_array_0; 
    signal sum_stage_1    : sum_array_1; 
    signal sum_stage_2    : sum_array_2; 
    signal clock_enable   : std_logic := '0';  -- Signal de basculement d'horloge
    signal signed_data    : signed(7 downto 0); -- Données d'entrée en complément à deux (CA2)
    signal conv_result    : signed(19 downto 0); -- Résultat final de l'accumulation

begin

    -- Assignation des horloges de sortie synchronisées avec l'horloge interne
    clk_can <= clock_enable;
    clk_cna <= clock_enable;

    -- Conversion des données d'entrée en complément à deux (CA2)
    signed_data <= signed(not(data_in(7)) & data_in(6 downto 0));

    -- Processus de gestion du registre de décalage pour les échantillons d'entrée
    shift_register_process : process(clk, reset_n)
    begin
        if reset_n = '0' then
            clock_enable <= '0';           
            shift_register <= (others => (others => '0'));
        elsif rising_edge(clk) then
            clock_enable <= not clock_enable;        
            if clock_enable = '1' then
                for i in 1 to 15 loop
                    shift_register(i) <= shift_register(i - 1); -- Décalage des données
                end loop;
                shift_register(0) <= std_logic_vector(signed_data);
            end if;
        end if;
    end process;            

    -- Processus pour calculer les produits entre les échantillons et les coefficients FIR
    product_calculation : process(clk, reset_n)
    begin
        if reset_n = '0' then
            product_result <= (others => (others => '0'));
        elsif rising_edge(clk) then
            for i in 0 to 15 loop
                product_result(i) <= signed(shift_register(i)) * fir_coeffs(i);
            end loop;
        end if;
    end process;            

    -- Étape d'addition 1 (réduction de 16 à 8 valeurs)
    addition_stage_0 : process(clk, reset_n)
    begin
        if reset_n = '0' then
            sum_stage_0 <= (others => (others => '0'));
        elsif rising_edge(clk) then
            for i in 0 to 7 loop
                sum_stage_0(i) <= resize(product_result(2*i), 17) + resize(product_result(2*i + 1), 17);
            end loop;    
        end if;
    end process;            

    -- Étape d'addition 2 (réduction de 8 à 4 valeurs)
    addition_stage_1 : process(clk, reset_n)
    begin
        if reset_n = '0' then
            sum_stage_1 <= (others => (others => '0'));
        elsif rising_edge(clk) then
            for i in 0 to 3 loop
                sum_stage_1(i) <= resize(sum_stage_0(2*i), 18) + resize(sum_stage_0(2*i + 1), 18);
            end loop;    
        end if;
    end process;            

    -- Étape d'addition 3 (réduction de 4 à 2 valeurs)
    addition_stage_2 : process(clk, reset_n)
    begin
        if reset_n = '0' then
            sum_stage_2 <= (others => (others => '0'));
        elsif rising_edge(clk) then
            for i in 0 to 1 loop
                sum_stage_2(i) <= resize(sum_stage_1(2*i), 19) + resize(sum_stage_1(2*i + 1), 19);
            end loop;    
        end if;
    end process;            

    -- Processus pour la dernière addition et génération de la sortie
    output_register : process(clk, reset_n)
    begin
        if reset_n = '0' then
            conv_result <= (others => '0');
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            clock_enable <= not clock_enable;        
            if clock_enable = '1' then
                conv_result <= resize(sum_stage_2(0), 20) + resize(sum_stage_2(1), 20);
                -- Ajustement du format de sortie avec inversion de signe et troncature
                data_out <= std_logic_vector((not conv_result(14)) & conv_result(13 downto 7));
            end if;
        end if;
    end process;   

end Behavioral;


