% -----------------------------------------------------------------------------
% Script de génération d'un signal sinusoïdal pour test du filtre FIR parallèle
% 
% Description :
% Ce script génère un signal sinusoïdal avec des paramètres spécifiques afin de 
% tester la réponse du filtre FIR à 16 coefficients. Le signal est échantillonné 
% à une fréquence donnée et stocké sous forme de valeurs discrètes entières dans 
% un fichier nommé `in.dat_16bit` pour être utilisé comme entrée dans la simulation VHDL.
%
% Paramètres du signal :
% - Fréquence d'échantillonnage (Fs) : 3 MHz
% - Fréquence du sinus (f_sinus)     : 300 kHz
% - Nombre d'échantillons (N)        : 400
% - Amplitude minimale/maximale      : 15 à 100
%
% Auteur : DJOMO ELISABETH
% Date   : 20-01-2025
% -----------------------------------------------------------------------------

% Paramètres de simulation
Fs = 3e6;              % Fréquence d'échantillonnage en Hz (3 MHz)
f_sinus = 300e3;       % Fréquence du signal sinusoïdal en Hz (300 kHz)
N = 400;               % Nombre total d'échantillons à générer
amplitude_min = 15;    % Amplitude minimale du signal sinusoïdal
amplitude_max = 100;   % Amplitude maximale du signal sinusoïdal

% -----------------------------------------------------------------------------
% Génération du signal sinusoïdal
% -----------------------------------------------------------------------------

t = (0:N-1) / Fs;      % Génération de l'axe temporel des échantillons

% Calcul de l'amplitude et de l'offset pour centrer le signal
amplitude = (amplitude_max - amplitude_min) / 2;  % Amplitude réelle du sinus
offset = (amplitude_max + amplitude_min) / 2;     % Décalage (offset) pour centrer le signal

% Création du signal sinusoïdal avec amplitude et offset
signal = amplitude * sin(2 * pi * f_sinus * t) + offset;

% Conversion en entier pour respecter les valeurs discrètes de la simulation
signal_int = round(signal);

% Affichage du signal généré
figure;
plot(signal_int);
title('Signal sinusoïdal généré');
xlabel('Échantillons');
ylabel('Amplitude');
grid on;

% -----------------------------------------------------------------------------
% Écriture des données dans un fichier texte pour utilisation en VHDL
% -----------------------------------------------------------------------------

fileID = fopen('in.dat_16bit', 'w');  % Ouverture du fichier en mode écriture
fprintf(fileID, '%d\n', signal_int);  % Écriture des valeurs entières ligne par ligne
fclose(fileID);                       % Fermeture du fichier

disp('Fichier in.dat_16bit généré avec succès.');

